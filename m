Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab1LDNge (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 08:36:34 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41961 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab1LDNgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 08:36:33 -0500
MIME-Version: 1.0
In-Reply-To: <4EDB6C10.10102@ladisch.de>
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com>
	<20111130154445.GA27198@gere.osrc.amd.com>
	<1E8B869C0C6913418421A406C094DF7C0205358F@sshaexmb1.amd.com>
	<CAPRPZsAL=xUCjTKaSgq117zppvZS0S7fHB0Ebk-JqXvV1vTPCQ@mail.gmail.com>
	<4EDB6C10.10102@ladisch.de>
Date: Sun, 4 Dec 2011 14:36:32 +0100
Message-ID: <CAPRPZsAc8wr_2KsRi3LnGi4ic-CzrFLbRvQfkrXckH--vaLkVQ@mail.gmail.com>
Subject: Re: Unhandled IRQs on AMD E-450
From: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You previously said that unloading e1000 made things better.  Did this
> affect both IRQs 16 and 19?

No, this only affects IRQ 19. IRQ 16 usually dies within 15min..2hrs.

> Can you check if this problem (on either 16 or 19) happens when you are
> not using the e1000 port (i.e., unplugged)?

The problem occurs with the e1000 idle (unplugged) and under heavy
usage (plugged). Time to failure is also in the same order of
magnitude (i.e. 1..30 minutes). As of now, I never had IRQ 19 disabled
with the e1000 removed. The e1000 delivered with Ubuntu isn't
particularly recent (7.3.21-k8-NAPI). Before I suspected a kernel
problem, I already tried the 8.0.35 compiled from source obtained from
Intel. Exactly the same result: IRQ 19 gets banned.

> The /proc/interrupts doesn't show e1000, but lspci does.  ...?

You are right. I took that lspci after removing e1000, sorry for the
confusion. Please see the new /proc/interrupts:below.

> Does the problem occur without fglrx?

Good question. I'll try that immediately. Stand by.

> To get the AHCI interrupt away from IRQ 19, try the patch below.
> (But please don't show that ugly hack to any AMD guy. :)

I'll try that next too.

>> Is there any way of obtaining more output such as IO-APIC register
>> states to verify that it is indeed a stuck IRQ input line and not an
>> unsuccesful EOI ack ?

> In theory, lspci's "Status: ... INTx+" shows an active interrupt line.

Ok. In that case (taking the lspci from a failed system) no (listed)
device has INTx+.


Thanks,


J.


$ cat /proc/interrupts (with e1000 (eth1) still loaded - this dump is
after IRQ 19 is killed)

           CPU0       CPU1
  0:         45         26   IO-APIC-edge      timer
  1:          1          1   IO-APIC-edge      i8042
  5:          0          0   IO-APIC-edge      parport0
  7:          1          0   IO-APIC-edge
  8:          1          0   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          1          3   IO-APIC-edge      i8042
 16:        121        559   IO-APIC-fasteoi   firewire_ohci, hda_intel
 17:          3        110   IO-APIC-fasteoi   ehci_hcd:usb1,
ehci_hcd:usb2, ehci_hcd:usb3
 18:          0          4   IO-APIC-fasteoi   ohci_hcd:usb4,
ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7
 19:     198169      11097   IO-APIC-fasteoi   ahci, eth1
 40:       3601         71   PCI-MSI-edge      eth0
 41:          0          0   PCI-MSI-edge      xhci_hcd
 42:          0          0   PCI-MSI-edge      xhci_hcd
 43:          0          0   PCI-MSI-edge      xhci_hcd
 44:          4        298   PCI-MSI-edge      hda_intel
 45:          0          3   PCI-MSI-edge      fglrx[0]@PCI:0:1:0
NMI:          0          0   Non-maskable interrupts
LOC:     231521     231457   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          0          0   Performance monitoring interrupts
IWI:          0          0   IRQ work interrupts
RES:      37942      34198   Rescheduling interrupts
CAL:        256        225   Function call interrupts
TLB:        309        243   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:         26         26   Machine check polls
ERR:          1
MIS:          0
