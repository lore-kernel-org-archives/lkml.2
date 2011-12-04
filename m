Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1LDNyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 08:54:24 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49051 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab1LDNyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 08:54:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAPRPZsAc8wr_2KsRi3LnGi4ic-CzrFLbRvQfkrXckH--vaLkVQ@mail.gmail.com>
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com>
	<20111130154445.GA27198@gere.osrc.amd.com>
	<1E8B869C0C6913418421A406C094DF7C0205358F@sshaexmb1.amd.com>
	<CAPRPZsAL=xUCjTKaSgq117zppvZS0S7fHB0Ebk-JqXvV1vTPCQ@mail.gmail.com>
	<4EDB6C10.10102@ladisch.de>
	<CAPRPZsAc8wr_2KsRi3LnGi4ic-CzrFLbRvQfkrXckH--vaLkVQ@mail.gmail.com>
Date: Sun, 4 Dec 2011 14:54:19 +0100
Message-ID: <CAPRPZsBdnrProsTaSYnMKi6Q3dSsP9nYkw0CKnmb-BrmJxBivw@mail.gmail.com>
Subject: Re: Unhandled IRQs on AMD E-450
From: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Does the problem occur without fglrx?
>
> Good question. I'll try that immediately. Stand by.

I'm afraid it didn't matter.

dmesg log:

-- rmmod'ing e1000 in order not to get stuck while shutting down the X system
[   42.990418] e1000 0000:05:01.0: PCI INT A disabled
-- Killed lightdm
[  102.250141] [fglrx] IRQ 45 Disabled
[  102.405031] HDMI hot plug event: Pin=3 Presence_Detect=1 ELD_Valid=1
[  102.405063] HDMI status: Pin=3 Presence_Detect=1 ELD_Valid=1
-- rmmod'ed fglrx
[  142.964281] pci 0000:00:01.0: PCI INT A disabled
[  142.964323] [fglrx] module unloaded - fglrx 8.90.5 [Oct 12 2011]
-- modprobe'd e1000 again
[  185.635457] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[  185.635469] e1000: Copyright (c) 1999-2006 Intel Corporation.
[  185.635612] e1000 0000:05:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[  186.213243] e1000 0000:05:01.0: eth1: (PCI:33MHz:32-bit) 00:0e:0c:d9:6f:ca
[  186.213263] e1000 0000:05:01.0: eth1: Intel(R) PRO/1000 Network Connection
[  186.248807] ADDRCONF(NETDEV_UP): eth1: link is not ready
-- Lost IRQ 19
[  354.446192] irq 19: nobody cared (try booting with the "irqpoll" option)
[  354.446343] Pid: 0, comm: swapper Tainted: P
3.0.0-13-generic #22-Ubuntu
[  354.446351] Call Trace:
[  354.446357]  <IRQ>  [<ffffffff810cf96d>] __report_bad_irq+0x3d/0xe0
[  354.446385]  [<ffffffff810cfd95>] note_interrupt+0x135/0x180
[  354.446396]  [<ffffffff810cdd89>] handle_irq_event_percpu+0xa9/0x220
[  354.446406]  [<ffffffff810cdf4e>] handle_irq_event+0x4e/0x80
[  354.446417]  [<ffffffff810d06c4>] handle_fasteoi_irq+0x64/0xf0
[  354.446427]  [<ffffffff8100c252>] handle_irq+0x22/0x40
[  354.446438]  [<ffffffff815f422a>] do_IRQ+0x5a/0xe0
[  354.446447]  [<ffffffff815ea913>] common_interrupt+0x13/0x13
[  354.446453]  <EOI>  [<ffffffff813725fb>] ? arch_local_irq_enable+0x8/0xd
[  354.446476]  [<ffffffff810887a5>] ? sched_clock_idle_wakeup_event+0x15/0x20
[  354.446486]  [<ffffffff813730ed>] acpi_idle_enter_simple+0xcc/0x102
[  354.446497]  [<ffffffff814ab5c2>] cpuidle_idle_call+0xa2/0x1d0
[  354.446509]  [<ffffffff8100920b>] cpu_idle+0xab/0x100
[  354.446520]  [<ffffffff815b858e>] rest_init+0x72/0x74
[  354.446531]  [<ffffffff81ad0c2b>] start_kernel+0x3d4/0x3df
[  354.446540]  [<ffffffff81ad0388>] x86_64_start_reservations+0x132/0x136
[  354.446552]  [<ffffffff81ad0140>] ? early_idt_handlers+0x140/0x140
[  354.446561]  [<ffffffff81ad0459>] x86_64_start_kernel+0xcd/0xdc
[  354.446568] handlers:
[  354.446642] [<ffffffffa0001f40>] ahci_interrupt
[  354.446743] [<ffffffffa00496c0>] e1000_intr
[  354.446830] Disabling IRQ #19

/proc/interrupts is consistent (IRQ45 now gone):

           CPU0       CPU1
  0:         45          3   IO-APIC-edge      timer
  1:          0          4   IO-APIC-edge      i8042
  5:          0          0   IO-APIC-edge      parport0
  7:          1          0   IO-APIC-edge
  8:          1          0   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          0          6   IO-APIC-edge      i8042
 16:         11        559   IO-APIC-fasteoi   firewire_ohci, hda_intel
 17:          6        104   IO-APIC-fasteoi   ehci_hcd:usb1,
ehci_hcd:usb2, ehci_hcd:usb3
 18:          0          4   IO-APIC-fasteoi   ohci_hcd:usb4,
ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7
 19:     200703      10373   IO-APIC-fasteoi   ahci, eth1
 40:       1001         66   PCI-MSI-edge      eth0
 41:          0          0   PCI-MSI-edge      xhci_hcd
 42:          0          0   PCI-MSI-edge      xhci_hcd
 43:          0          0   PCI-MSI-edge      xhci_hcd
 44:          1        427   PCI-MSI-edge      hda_intel
NMI:          0          0   Non-maskable interrupts
LOC:      12670      23434   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          0          0   Performance monitoring interrupts
IWI:          0          0   IRQ work interrupts
RES:       4824       3363   Rescheduling interrupts
CAL:        317        240   Function call interrupts
TLB:        388        264   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:          3          3   Machine check polls
ERR:          1
MIS:          0


>> To get the AHCI interrupt away from IRQ 19, try the patch below.
>> (But please don't show that ugly hack to any AMD guy. :)
> I'll try that next too.

Moving on to the patch...

Rgds,


J.
