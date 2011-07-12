Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab1GLHrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:47:37 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:49948 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab1GLHrg (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 12 Jul 2011 03:47:36 -0400
X-Greylist: delayed 1215 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jul 2011 03:47:35 EDT
Subject: x86: interrupt routing question
From: Mike Galbraith <mgalbraith@novell.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 09:27:00 +0200
Message-ID: <1310455620.4844.29.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I have an x3550 M3 box which shows different behavior than my Q6600
desktop box.  The below is the rt kernel, but it doesn't matter which
kernel I boot, all interrupts are on CPU0 unless I move them.  On Q6600
box, IRQs magically appear on every cpu in the affinity mask.  Change
the eth0 mask while flood pinging, numbers start/stop changing on the
fly.

On x3550 M3, setting eg IRQ 63's mask to '0xe' will move irq to CPU2,
but nothing that I have found will make the thing behave the same as
trusty old Q6600 box, which seems strange.  Is this some kind of BIOS
thingie, or is every kernel busted on this hardware?  Busted kernel
seems highly doubtful.

OT question.  I have HT turned off on the x3550 because I do rt testing
on it, and occasionally boot idle=poll.  Is it still the case that you
should not run idle=poll with HT enabled, or can you do that with HT
these days (E5620 CPU) without munching too many cycles?

            CPU0       CPU1       CPU2       CPU3       
   0:        132          0          0          0   IO-APIC-edge      timer
   1:          0          0          0          0   IO-APIC-edge      i8042
   3:          1          0          0          0   IO-APIC-edge    
   4:          1          0          0          0   IO-APIC-edge    
   8:         26          0          0          0   IO-APIC-edge      rtc0
   9:          0          0          0          0   IO-APIC-fasteoi   acpi
  14:          0          0          0          0   IO-APIC-edge      ata_piix
  15:          0          0          0          0   IO-APIC-edge      ata_piix
  16:       5450          0          0          0   IO-APIC-fasteoi   megasas
  17:         52          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb3, uhci_hcd:usb5
  18:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb4, uhci_hcd:usb6
  19:      61939          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb7
  21:          0          0          0          0   IO-APIC-fasteoi   ata_piix
  54:          3          0          0          0   PCI-MSI-edge      ioat-msix
  55:          3          0          0          0   PCI-MSI-edge      ioat-msix
  56:          3          0          0          0   PCI-MSI-edge      ioat-msix
  57:          3          0          0          0   PCI-MSI-edge      ioat-msix
  58:          3          0          0          0   PCI-MSI-edge      ioat-msix
  59:          3          0          0          0   PCI-MSI-edge      ioat-msix
  60:          3          0          0          0   PCI-MSI-edge      ioat-msix
  61:          3          0          0          0   PCI-MSI-edge      ioat-msix
  62:        178          0          0          0   PCI-MSI-edge      eth1-0
  63:    6327232          0          0          0   PCI-MSI-edge      eth1-1
  64:         73          0          0          0   PCI-MSI-edge      eth1-2
  65:    6327230          0          0          0   PCI-MSI-edge      eth1-3
  66:          2          0          0          0   PCI-MSI-edge      eth1-4
 NMI:          0          0          0          0   Non-maskable interrupts
 LOC:    2096607    2366453     260343    2225391   Local timer interrupts
 SPU:          0          0          0          0   Spurious interrupts
 PMI:          0          0          0          0   Performance monitoring interrupts
 PND:          0          0          0          0   Performance pending work
 RES:       1981       2973       2405       2001   Rescheduling interrupts
 CAL:         49         43         74         72   Function call interrupts
 TLB:        638        784       1175        674   TLB shootdowns
 TRM:          0          0          0          0   Thermal event interrupts
 THR:          0          0          0          0   Threshold APIC interrupts
 MCE:          0          0          0          0   Machine check exceptions
 MCP:        603        603        603        606   Machine check polls
 ERR:          0
 MIS:          0


