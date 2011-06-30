Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab1F3M3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:29:15 -0400
Received: from cpalmer.me.uk ([91.84.39.44]:33003 "EHLO cpalmer.me.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab1F3M3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:29:07 -0400
Message-ID: <4E0C6C15.1090205@pobox.com>
Date: Thu, 30 Jun 2011 13:29:09 +0100
From: Chris Palmer <chris.palmer@pobox.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-GB; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Further Sandybridge woes (including IRQ n: nobody cared, and video
 crashes)
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like many other posters I have the dreaded IRQ nobody cared problem. But
whereas others have more complicated situations (e.g. multiple device
sharing an IRQ), mine is quite simple, and none of the workaround
suggestions I've seen work.

There are multiple symptoms which I include here as I don't know which
are related:
- System boots ok but IRQ Nobody Cared occurs on additional ethernet
board after about 15 minutes (main problem)
- Video is fine in character mode. X starts ok, some repaint hiccups,
but terminating X hangs system with loud continuous beep and need to
remove power (even reset doesn't work) if from runlevel 5, or with
several second hang followed by reboot if started from runlevel 3.
- Boot log shows 34 lines such as "*BAD*gran_size: 64K       chunk_size:
8M  num_reg: 10     lose cover RAM: -2M" (benign??)

System details:
- Asus P8H67-V/R3 (latest Bios 0712, default settings except AHCI and
VT-enabled)
- COREi5/2500K
- 4 x 4GB Corsair CMX8GX3M2A1333C9
- On-board video and ethernet (eth1, at11c driver)
- One additional RTL8139 or Broadcom BCM5702X ethernet for eth0 (fails
identically with either)
- FC14 with 2.6.39.2 custom kernel, updates to 30/6/11

I've tried the following kernel options:
- pci=noacpi
- acpi=noirq
- irqpoll
None have any effect on the IRQ problem.

I've tried moving the ethernet board to another slot. Apart from
changing the IRQ from 16 to 19, no effect.

For the video problem, I've tried i915.semaphores = 0 and 1, but no
difference.

lspci:
00:00.0 Host bridge: Intel Corporation Sandy Bridge DRAM Controller (rev 09)
00:01.0 PCI bridge: Intel Corporation Sandy Bridge PCI Express Root Port
(rev 09)
00:02.0 VGA compatible controller: Intel Corporation Device 0112 (rev 09)
00:16.0 Communication controller: Intel Corporation Cougar Point HECI
Controller #1 (rev 04)
00:1a.0 USB Controller: Intel Corporation Cougar Point USB Enhanced Host
Controller #2 (rev 05)
00:1b.0 Audio device: Intel Corporation Cougar Point High Definition
Audio Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port
1 (rev b5)
00:1c.2 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port
3 (rev b5)
00:1c.3 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port
4 (rev b5)
00:1c.4 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port
5 (rev b5)
00:1c.5 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port
6 (rev b5)
00:1c.6 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port
7 (rev b5)
00:1c.7 PCI bridge: Intel Corporation 82801 PCI Bridge (rev b5)
00:1d.0 USB Controller: Intel Corporation Cougar Point USB Enhanced Host
Controller #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation Cougar Point LPC Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation Cougar Point 6 port SATA AHCI
Controller (rev 05)
00:1f.3 SMBus: Intel Corporation Cougar Point SMBus Controller (rev 05)
05:00.0 IDE interface: VIA Technologies, Inc. PATA IDE Host Controller
06:00.0 USB Controller: Device 1b21:1042
07:00.0 Ethernet controller: Atheros Communications Device 1083 (rev c0)
08:00.0 PCI bridge: Device 1b21:1080 (rev 01)
09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5702X
Gigabit Ethernet (rev 02)

cat /proc/interrupts:
           CPU0       CPU1       CPU2       CPU3
  0:        130          0          0          0   IO-APIC-edge      timer
  1:          4          0          0          0   IO-APIC-edge      i8042
  4:      17414          0          0          0   IO-APIC-edge      serial
  8:          1          0          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          5          0          0          0   IO-APIC-edge      i8042
 19:       2302          0          0          0   IO-APIC-fasteoi   eth0
 23:        183          0          0          0   IO-APIC-fasteoi  
ehci_hcd:usb1, ehci_hcd:usb2
 40:          0          0          0          0   PCI-MSI-edge     
PCIe PME
 41:          0          0          0          0   PCI-MSI-edge     
PCIe PME
 42:          0          0          0          0   PCI-MSI-edge     
PCIe PME
 43:          0          0          0          0   PCI-MSI-edge     
PCIe PME
 44:          0          0          0          0   PCI-MSI-edge     
PCIe PME
 45:          0          0          0          0   PCI-MSI-edge     
PCIe PME
 46:          0          0          0          0   PCI-MSI-edge     
PCIe PME
 47:      12756          0          0          0   PCI-MSI-edge      ahci
 48:          0          0          0          0   PCI-MSI-edge     
xhci_hcd
 49:          0          0          0          0   PCI-MSI-edge     
xhci_hcd
 50:          0          0          0          0   PCI-MSI-edge     
xhci_hcd
 51:          0          0          0          0   PCI-MSI-edge     
xhci_hcd
 52:          0          0          0          0   PCI-MSI-edge     
xhci_hcd
 53:       4151          0          0          0   PCI-MSI-edge      eth1
NMI:          0          0          0          0   Non-maskable interrupts
LOC:      40223      39607      28968       5735   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance
monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RES:        191        188        128        129   Rescheduling interrupts
CAL:         51        241        285        430   Function call interrupts
TLB:         47        174        320         67   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          6          6          6          6   Machine check polls
ERR:          0
MIS:          0


Jun 30 13:01:56 woody1 kernel: [ 3254.238083] irq 19: nobody cared (try
booting with the "irqpoll" option)
Jun 30 13:01:56 woody1 kernel: [ 3254.238089] Pid: 0, comm: swapper Not
tainted 2.6.39.2 #1
Jun 30 13:01:56 woody1 kernel: [ 3254.238091] Call Trace:
Jun 30 13:01:56 woody1 kernel: [ 3254.238093]  <IRQ> 
[<ffffffff81081919>] __report_bad_irq+0x45/0xae
Jun 30 13:01:56 woody1 kernel: [ 3254.238106]  [<ffffffff81081cad>]
note_interrupt+0x144/0x1af
Jun 30 13:01:56 woody1 kernel: [ 3254.238110]  [<ffffffff81080387>]
handle_irq_event_percpu+0x182/0x1a0
Jun 30 13:01:56 woody1 kernel: [ 3254.238114]  [<ffffffff810803d6>]
handle_irq_event+0x31/0x4f
Jun 30 13:01:56 woody1 kernel: [ 3254.238120]  [<ffffffff81065eaf>] ?
arch_local_irq_save+0x18/0x1e
Jun 30 13:01:56 woody1 kernel: [ 3254.238124]  [<ffffffff8108239d>]
handle_fasteoi_irq+0x77/0x97
Jun 30 13:01:56 woody1 kernel: [ 3254.238128]  [<ffffffff8100434d>]
handle_irq+0x88/0x90
Jun 30 13:01:56 woody1 kernel: [ 3254.238133]  [<ffffffff813f197d>]
do_IRQ+0x4d/0xa5
Jun 30 13:01:56 woody1 kernel: [ 3254.238138]  [<ffffffff813efb53>]
common_interrupt+0x13/0x13
Jun 30 13:01:56 woody1 kernel: [ 3254.238140]  <EOI> 
[<ffffffff810085b5>] ? paravirt_read_tsc+0x9/0xd
Jun 30 13:01:56 woody1 kernel: [ 3254.238149]  [<ffffffff8123bfda>] ?
intel_idle+0xd4/0xf8
Jun 30 13:01:56 woody1 kernel: [ 3254.238153]  [<ffffffff8123bfb9>] ?
intel_idle+0xb3/0xf8
Jun 30 13:01:56 woody1 kernel: [ 3254.238157]  [<ffffffff81327cd1>]
cpuidle_idle_call+0xa1/0xe9
Jun 30 13:01:56 woody1 kernel: [ 3254.238162]  [<ffffffff8100130b>]
cpu_idle+0xaa/0xcc
Jun 30 13:01:56 woody1 kernel: [ 3254.238166]  [<ffffffff813dd64e>]
rest_init+0x72/0x74
Jun 30 13:01:56 woody1 kernel: [ 3254.238171]  [<ffffffff818a6b5d>]
start_kernel+0x3a4/0x3af
Jun 30 13:01:56 woody1 kernel: [ 3254.238176]  [<ffffffff818a62af>]
x86_64_start_reservations+0xb6/0xba
Jun 30 13:01:56 woody1 kernel: [ 3254.238180]  [<ffffffff818a63b4>]
x86_64_start_kernel+0x101/0x110
Jun 30 13:01:56 woody1 kernel: [ 3254.238182] handlers:
Jun 30 13:01:56 woody1 kernel: [ 3254.238184] [<ffffffffa002dfbc>]
(tg3_interrupt_tagged+0x0/0x91 [tg3])
Jun 30 13:01:56 woody1 kernel: [ 3254.238195] Disabling IRQ #19

Is the paravirt_read_tsc in the trace ok?? It is just a kernel that
includes the paravirtualised drivers running on bare metal...

Apart from these problems it's great. Power management is really good.
Graphics I can live without for now (it's primarily a server). But the
lack of second ethernet is a killer.

Any ideas gratefully accepted. Happy to try things.

Please CC me directly on any replies.

Many thanks
Chris

