Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab1AaPQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:16:54 -0500
Received: from mail-zbox20.bo3.lycos.com ([209.202.250.20]:46322 "EHLO
	mailbox20.lycos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab1AaPQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:16:52 -0500
Date: Mon, 31 Jan 2011 10:16:47 -0500 (EST)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org
Message-ID: <30495832.55191296487007601.JavaMail.root@mail-zbox20.bo3.lycos.com>
In-Reply-To: <4D46BF6E.4090401@ladisch.de>
Subject: Re: irq N: nobody cared (try booting with the "irqpoll" option)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.16.76.68]
X-Mailer: Zimbra 5.0 (ZimbraWebClient - FF3.0 (Linux)/5.0.18_GA_3028.CentOS5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Clemens Ladisch" <clemens@ladisch.de> wrote:

> Artem S. Tashkinov wrote:
> > I've never faced this problem before but after I've recently
> > renewed my PC (a new MoBo and CPU) I'm now randomly getting
> > this kernel message after booting the PC:
> > 
> > irq 18: nobody cared
> 
> One of the devices on interrupt line 18 has raised an interrupt, but
> no driver has accepted it.
> 
> Have a look into /proc/interrupts to see which drivers are registered
> for irq 18 (e100 in your case), then search in the output of "lspci
> -v"
> for any _other_ devices that use irq 18.
> 
> It's also possible that one of the drivers is buggy and mistakenly
> said
> "this interrupt is not from my device", or, in theory, that the BIOS
> is
> buggy and has mislabeled some device's interrupt.
> 
> 
> According to Google, there are other reports of this message with the
> e100 driver.  Does your network work?  If not, does irqpoll help?
> 

eth1/e100 is what I'm using to get into the Internet so it's working 
correctly.

According to lspci -v I have two devices using IRQ 18:

00:1f.3 SMBus: Intel Corporation Cougar Point SMBus Controller (rev 04)
        Subsystem: ASUSTeK Computer Inc. Device 844d
        Flags: medium devsel, IRQ 18
        Memory at fb624000 (64-bit, non-prefetchable) [size=256]
        I/O ports at f000 [size=32]
        Kernel driver in use: i801_smbus
        Kernel modules: i2c-i801

and

08:00.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 (rev 10)
        Subsystem: Intel Corporation Device 0070
        Flags: bus master, medium devsel, latency 32, IRQ 18
        Memory at fb231000 (32-bit, non-prefetchable) [size=4K]
        I/O ports at c080 [size=64]
        Memory at fb200000 (32-bit, non-prefetchable) [size=128K]
        Expansion ROM at fb220000 [disabled] [size=64K]
        Capabilities: [dc] Power Management version 2
        Kernel driver in use: e100
        Kernel modules: e100

According to /proc/interrupts only e100 module claims this interrupt:

           CPU0       CPU1       CPU2       CPU3
  0:        110          0          0          0   IO-APIC-edge      timer
  1:      53483          0         12          0   IO-APIC-edge      i8042
  4:          2          0          0          0   IO-APIC-edge
  8:         34          0          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 18:    1200001          0          0          0   IO-APIC-fasteoi   eth1
 19:    1864975          0          0          0   IO-APIC-fasteoi   ahci, EMU10K1
 23:     452718        884          0          0   IO-APIC-fasteoi   ehci_hcd:usb3, ehci_hcd:usb4
 40:          0          0          0          0   PCI-MSI-edge      PCIe PME
 41:          0          0          0          0   PCI-MSI-edge      PCIe PME
 42:          0          0          0          0   PCI-MSI-edge      PCIe PME
 43:          0          0          0          0   PCI-MSI-edge      PCIe PME
 44:          0          0          0          0   PCI-MSI-edge      PCIe PME
 45:          0          0          0          0   PCI-MSI-edge      PCIe PME
 46:          0          0          0          0   PCI-MSI-edge      PCIe PME
 47:     317397          0          0          0   PCI-MSI-edge      ahci
 48:          0          0          0          0   PCI-MSI-edge      ahci
 49:       9453          0          0          0   PCI-MSI-edge      eth0
 50:          1          0          0          0   PCI-MSI-edge      xhci_hcd
 51:          0          0          0          0   PCI-MSI-edge      xhci_hcd
 52:          0          0          0          0   PCI-MSI-edge      xhci_hcd
 53:          0          0          0          0   PCI-MSI-edge      xhci_hcd
 54:          0          0          0          0   PCI-MSI-edge      xhci_hcd
 55:          1          0          0          0   PCI-MSI-edge      xhci_hcd
 56:          0          0          0          0   PCI-MSI-edge      xhci_hcd
 57:          0          0          0          0   PCI-MSI-edge      xhci_hcd
 58:          0          0          0          0   PCI-MSI-edge      xhci_hcd
 59:          0          0          0          0   PCI-MSI-edge      xhci_hcd
 60:        647        340          0          0   PCI-MSI-edge      hda_intel
 61:      18966          0          0          0   PCI-MSI-edge      nvidia
NMI:          0          0          0          0   Non-maskable interrupts
LOC:   10419216   12012477   13088898   10786868   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RES:      18626      25210      16331      15105   Rescheduling interrupts
CAL:      24856      22805      45874      51634   Function call interrupts
TLB:      42997      27281      20665      18604   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:         65         65         65         65   Machine check polls
ERR:          3
MIS:          0

I will try to reboot with irqpoll a bit later however before I try it I'd
be very grateful to know what exactly this option does/if it affects
performance/stability/etc and why it's not used/enabled by default.
