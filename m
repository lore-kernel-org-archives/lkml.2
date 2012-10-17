Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab2JQSF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 14:05:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37870 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752112Ab2JQSF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 14:05:26 -0400
Date: Wed, 17 Oct 2012 14:05:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Martin Vysny <vysny@baka.sk>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, <1062114@bugs.launchpad.net>
Subject: Re: usb issue on Intel chipset: abrupt mouse movements, usb keyboard
 loosing key events
In-Reply-To: <507E6235.7040209@baka.sk>
Message-ID: <Pine.LNX.4.44L0.1210171348380.1743-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2012, Martin Vysny wrote:

> Good day,
>    thank you for your mail. I was finally able to reproduce the issue. I 
> am attaching a dmesg output of a correct boot (please note that there 
> still are several unwanted IRQs), and a dmesg output of a reproduced error.

Did you boot with the "irqpoll" option?  Judging by the log, it looks 
like you did.

> [   67.512014] ehci_hcd 0000:00:1d.0: >Unwanted IRQ: c000 0
> [   67.512021] ehci_hcd 0000:00:1d.0: >Unwanted IRQ: e000 0
> [   67.512023] irq 17: nobody cared (try booting with the "irqpoll" option)
> [   67.512026] Pid: 0, comm: swapper/0 Tainted: G           O 3.5.0-17-generic #28
> [   67.512027] Call Trace:
> [   67.512034]  [<c10c6ae9>] __report_bad_irq+0x29/0xd0
> [   67.512037]  [<c10c6db5>] note_interrupt+0x175/0x1c0
> [   67.512041]  [<c1326d63>] ? intel_idle+0xc3/0x120
> [   67.512045]  [<c10c4bdf>] handle_irq_event_percpu+0x9f/0x1d0
> [   67.512047]  [<c10c4d4b>] handle_irq_event+0x3b/0x60
> [   67.512050]  [<c10c7710>] ? unmask_irq+0x30/0x30
> [   67.512052]  [<c10c775e>] handle_fasteoi_irq+0x4e/0xd0
> [   67.512053]  <IRQ>  [<c15d0692>] ? do_IRQ+0x42/0xc0
> [   67.512062]  [<c10689fe>] ? enqueue_hrtimer+0x1e/0x70
> [   67.512064]  [<c15d04f0>] ? common_interrupt+0x30/0x38
> [   67.512069]  [<c10400e0>] ? in_gate_area+0x10/0x50
> [   67.512071]  [<c1326d63>] ? intel_idle+0xc3/0x120
> [   67.512076]  [<c149b7b5>] ? cpuidle_enter+0x15/0x20
> [   67.512078]  [<c149bd18>] ? cpuidle_idle_call+0x88/0x220
> [   67.512081]  [<c101870a>] ? cpu_idle+0xaa/0xe0
> [   67.512086]  [<c159f715>] ? rest_init+0x5d/0x68
> [   67.512090]  [<c18b49be>] ? start_kernel+0x35d/0x363
> [   67.512092]  [<c18b44ed>] ? do_early_param+0x80/0x80
> [   67.512094]  [<c18b4303>] ? i386_start_kernel+0xa6/0xad
> [   67.512095] handlers:
> [   67.512098] [<c142fe00>] usb_hcd_irq
> [   67.512099] Disabling IRQ #17
> [   69.507175] ehci_hcd 0000:00:1d.0: >Unwanted IRQ: c000 0
> [   69.607118] ehci_hcd 0000:00:1d.0: >Unwanted IRQ: c000 0

The debugging output show that the EHCI controller was not the source
of the unwanted IRQs.  And /proc/interrupts shows that ehci-hcd is the
only driver using IRQ #17, for the 0000:00:1d.0 device.

The most likely explanation is that there an interrupt-routing error 
and some other device is causing these problems.  I don't know of any 
easy way to find out what the other device is, however.

Alan Stern

