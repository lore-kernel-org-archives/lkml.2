Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1IMHLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 03:11:52 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44114 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1IMHLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 03:11:51 -0400
MIME-Version: 1.0
Date: Tue, 13 Sep 2011 19:11:50 +1200
Message-ID: <CAKaWdxbcpZKL9pkf0sKS3OarSE-jRgy8QKuGu=0NEd3Rigq0dg@mail.gmail.com>
Subject: IRQ Storm - nobody cared
From: Keith Chew <keith.chew@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have been trying trace through an IRQ problem, but without any
success. Summary of problem:
- Hardware with Intel ICH7 chipset, and PCI video capture card =
Working flawlessly, getting 100+ interrupts per second from
/proc/interrupts (units have been in production for 6+ years)
- New hardware with Intel ICH9 chipset = getting spurious interrupts
(20000+ per second), and these from dmesg at bootup:
--------------------------------------
Sep 13 18:49:01 localhost kernel: bttv1: timeout: drop=0 irq=1/1974,
risc=36b4301c, bits: VSYNC HSYNC RISCI
Sep 13 18:49:01 localhost kernel: bttv1: timeout: drop=0 irq=1/1974,
risc=36b4301c, bits: VSYNC HSYNC RISCI
Sep 13 18:49:02 localhost kernel: bttv3: timeout: drop=0 irq=3/1806,
risc=36818744, bits: VSYNC HSYNC RISCI
Sep 13 18:49:03 localhost kernel: bttv3: timeout: drop=0 irq=3/1806,
risc=36b3b03c, bits: VSYNC HSYNC RISCI
Sep 13 18:49:03 localhost kernel: irq 17: nobody cared (try booting
with the "irqpoll" option)
Sep 13 18:49:03 localhost kernel: Pid: 0, comm: swapper Not tainted 2.6.39.4 #10
Sep 13 18:49:03 localhost kernel: Call Trace:
Sep 13 18:49:03 localhost kernel: [<c0471785>] ? __report_bad_irq+0x25/0x90
Sep 13 18:49:03 localhost kernel: [<c0471969>] ? note_interrupt+0x179/0x1b0
Sep 13 18:49:03 localhost kernel: [<c04702a3>] ?
handle_irq_event_percpu+0x93/0x1e0
Sep 13 18:49:03 localhost kernel: [<c0471ed0>] ? handle_percpu_irq+0x50/0x50
Sep 13 18:49:03 localhost kernel: [<c0470409>] ? handle_irq_event+0x19/0x30
Sep 13 18:49:03 localhost kernel: [<c0471f05>] ? handle_fasteoi_irq+0x35/0x80
Sep 13 18:49:03 localhost kernel: <IRQ>  [<c040371a>] ? do_IRQ+0x3a/0xb0
Sep 13 18:49:03 localhost kernel: [<c075f0b0>] ? common_interrupt+0x30/0x40
Sep 13 18:49:03 localhost kernel: [<c040887d>] ? mwait_idle+0x5d/0x140
Sep 13 18:49:03 localhost kernel: [<c0401b7c>] ? cpu_idle+0x6c/0x90
Sep 13 18:49:03 localhost kernel: [<c093f7d6>] ? start_kernel+0x32b/0x330
Sep 13 18:49:03 localhost kernel: [<c093f2eb>] ? kernel_init+0x11c/0x11c
Sep 13 18:49:03 localhost kernel: [<c093f0b5>] ? i386_start_kernel+0xb5/0xc0
Sep 13 18:49:03 localhost kernel: handlers:
Sep 13 18:49:03 localhost kernel: [<fb16b830>] (bttv_irq+0x0/0x9d0 [bttv])
Sep 13 18:49:03 localhost kernel: [<fb16b830>] (bttv_irq+0x0/0x9d0 [bttv])
Sep 13 18:49:03 localhost kernel: Disabling IRQ #17
Sep 13 18:49:04 localhost kernel: irq 18: nobody cared (try booting
with the "irqpoll" option)
Sep 13 18:49:04 localhost kernel: Pid: 0, comm: swapper Not tainted 2.6.39.4 #10
Sep 13 18:49:04 localhost kernel: Call Trace:
Sep 13 18:49:04 localhost kernel: [<c0471785>] ? __report_bad_irq+0x25/0x90
Sep 13 18:49:04 localhost kernel: [<f99892c0>] ?
piix_irq_check+0x10/0x20 [ata_piix]
Sep 13 18:49:04 localhost kernel: [<c0471969>] ? note_interrupt+0x179/0x1b0
Sep 13 18:49:04 localhost kernel: [<c04702a3>] ?
handle_irq_event_percpu+0x93/0x1e0
Sep 13 18:49:04 localhost kernel: [<c0419917>] ? __io_apic_modify_irq+0x77/0x90
Sep 13 18:49:04 localhost kernel: [<c0471ed0>] ? handle_percpu_irq+0x50/0x50
Sep 13 18:49:04 localhost kernel: [<c0471ed0>] ? handle_percpu_irq+0x50/0x50
Sep 13 18:49:04 localhost kernel: [<c0470409>] ? handle_irq_event+0x19/0x30
Sep 13 18:49:04 localhost kernel: [<c0471f05>] ? handle_fasteoi_irq+0x35/0x80
Sep 13 18:49:04 localhost kernel: <IRQ>  [<c040371a>] ? do_IRQ+0x3a/0xb0
Sep 13 18:49:04 localhost kernel: [<c075f0b0>] ? common_interrupt+0x30/0x40
Sep 13 18:49:04 localhost kernel: [<c040887d>] ? mwait_idle+0x5d/0x140
Sep 13 18:49:04 localhost kernel: [<c0401b7c>] ? cpu_idle+0x6c/0x90
Sep 13 18:49:04 localhost kernel: [<c093f7d6>] ? start_kernel+0x32b/0x330
Sep 13 18:49:04 localhost kernel: [<c093f2eb>] ? kernel_init+0x11c/0x11c
Sep 13 18:49:04 localhost kernel: [<c093f0b5>] ? i386_start_kernel+0xb5/0xc0
Sep 13 18:49:04 localhost kernel: handlers:
Sep 13 18:49:04 localhost kernel: [<c0661f60>] (usb_hcd_irq+0x0/0x50)
Sep 13 18:49:04 localhost kernel: [<fb16b830>] (bttv_irq+0x0/0x9d0 [bttv])
Sep 13 18:49:04 localhost kernel: [<fb16b830>] (bttv_irq+0x0/0x9d0 [bttv])
Sep 13 18:49:04 localhost kernel: Disabling IRQ #18
Sep 13 18:49:36 localhost kernel: irq 19: nobody cared (try booting
with the "irqpoll" option)
Sep 13 18:49:36 localhost kernel: Pid: 1502, comm: mplayer Not tainted
2.6.39.4 #10
Sep 13 18:49:36 localhost kernel: Call Trace:
Sep 13 18:49:36 localhost kernel: [<c0471785>] ? __report_bad_irq+0x25/0x90
Sep 13 18:49:36 localhost kernel: [<f99892c0>] ?
piix_irq_check+0x10/0x20 [ata_piix]
Sep 13 18:49:36 localhost kernel: [<c0471969>] ? note_interrupt+0x179/0x1b0
Sep 13 18:49:36 localhost kernel: [<c04702a3>] ?
handle_irq_event_percpu+0x93/0x1e0
Sep 13 18:49:36 localhost kernel: [<c0419917>] ? __io_apic_modify_irq+0x77/0x90
Sep 13 18:49:36 localhost kernel: [<c0471ed0>] ? handle_percpu_irq+0x50/0x50
Sep 13 18:49:36 localhost kernel: [<c0471ed0>] ? handle_percpu_irq+0x50/0x50
Sep 13 18:49:36 localhost kernel: [<c0470409>] ? handle_irq_event+0x19/0x30
Sep 13 18:49:36 localhost kernel: [<c0471f05>] ? handle_fasteoi_irq+0x35/0x80
Sep 13 18:49:36 localhost kernel: <IRQ>  [<c040371a>] ? do_IRQ+0x3a/0xb0
Sep 13 18:49:36 localhost kernel: [<c075f0b0>] ? common_interrupt+0x30/0x40
Sep 13 18:49:36 localhost kernel: [<c075007b>] ? pci_scan_bridge+0xdc/0x4dc
Sep 13 18:49:36 localhost kernel: [<c0750000>] ? pci_scan_bridge+0x61/0x4dc
Sep 13 18:49:36 localhost kernel: handlers:
Sep 13 18:49:36 localhost kernel: [<c0646f20>] (ata_bmdma_interrupt+0x0/0x1e0)
Sep 13 18:49:36 localhost kernel: [<c0646f20>] (ata_bmdma_interrupt+0x0/0x1e0)
Sep 13 18:49:36 localhost kernel: [<fb16b830>] (bttv_irq+0x0/0x9d0 [bttv])
Sep 13 18:49:36 localhost kernel: [<fb16b830>] (bttv_irq+0x0/0x9d0 [bttv])
Sep 13 18:49:36 localhost kernel: Disabling IRQ #19
--------------------------------------

Have tested on 3 pieces of new hardware, and all same results (so it
is not faulty RAM, CPU, HDD or PCI card).

I have updated the BIOS to the latest, and also tried all possible
combinations: nosmp, noapic, nolapic, noriqdebug, irqpoll, etc. From
the kernel compilation options, I have tried all the things that are
related to IRQs and PCI, eg disable MSI, PCIe, ASPM, etc. I end up
with the same results.

Also upgraded to the lastest kernel 2.6.39.4, and getting the same
results. This is driving me insane.

I have analysed the dmesg, and I cannot pin point the culprit.  But if
I pull out the PCI video capture card, then the system behaves well.
So, perhaps this is a BUG in the bttv driver with ICH9 chipset?

Regards
Keith
