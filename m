Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab1IGXUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 19:20:33 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49317 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab1IGXUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 19:20:32 -0400
MIME-Version: 1.0
Date: Thu, 8 Sep 2011 00:20:31 +0100
Message-ID: <CANq10gueekcQ+zF0iNG5fO2NKhTphuOT6gP3OZipB4z1ts8zWQ@mail.gmail.com>
Subject: All interrupts going to CPU 1 on a Pentium D system
From: Mikhail Ramendik <mr@ramendik.ru>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ello,

I have a Pentium D system with a SiS 661FX chipset.

I found that most IRQs are always processed by CPU 1 only. This
happens even if I explicitly set the smp_ffinity value for the IRQ to
1, so it would be processed by CPU 0. This happens n both 2.6.32 and
3.0 kernels (Debian builds).

Is this normal? And can this be changed?

(I am debugging stability issues on this system; I don't know if they
can be linked to this).

$ cat /proc/interrupts
            CPU0       CPU1
   0:         41          1   IO-APIC-edge      timer
   1:          0          4   IO-APIC-edge      i8042
   3:          0          2   IO-APIC-edge
   4:          0          2   IO-APIC-edge
   6:          0          2   IO-APIC-edge      floppy
   7:          0          0   IO-APIC-edge      parport0
   8:          0          0   IO-APIC-edge      rtc0
   9:          0          0   IO-APIC-fasteoi   acpi
  12:          0          6   IO-APIC-edge      i8042
  14:          0        425   IO-APIC-edge      pata_sis
  15:          0          0   IO-APIC-edge      pata_sis
  17:          0       8086   IO-APIC-fasteoi   sata_sis
  18:          0        824   IO-APIC-fasteoi   SiS SI7012, 0000:00:09.0
  19:          0          0   IO-APIC-fasteoi   saa7133[0], saa7133[0]
  20:          0        183   IO-APIC-fasteoi   ohci_hcd:usb2
  21:          0        171   IO-APIC-fasteoi   ohci_hcd:usb3
  22:          0          0   IO-APIC-fasteoi   ohci_hcd:usb4
  23:          0          3   IO-APIC-fasteoi   ehci_hcd:usb1
 NMI:          0          0   Non-maskable interrupts
 LOC:       6337       7518   Local timer interrupts
 SPU:          0          0   Spurious interrupts
 PMI:          0          0   Performance monitoring interrupts
 IWI:          0          0   IRQ work interrupts
 RES:        981        703   Rescheduling interrupts
 CAL:       3511        578   Function call interrupts
 TLB:        681        492   TLB shootdowns
 TRM:          0          0   Thermal event interrupts
 THR:          0          0   Threshold APIC interrupts
 MCE:          0          0   Machine check exceptions
 MCP:          1          1   Machine check polls
 ERR:          0
 MIS:          0

--
Yours, Mikhail Ramendik

Unless explicitly stated, all opinions in my mail are my own and do
not reflect the views of any organization
