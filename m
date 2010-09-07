Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab0IGIXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 04:23:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36950 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab0IGIXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 04:23:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MtKfhbMK14resO1UtV7glwlIYlA59BpIZ1PUftvMaRUh3CU0DfaKpTovZpTMPhN9AX
         FShas2bjYibm0nVS0zjEDkEGezWrdg7MAaFNnTcii4GbVm+urQBr7l7I+8pdbEjejUpn
         +sNGaVvMtUKvZXum9AfT40FwvP5dNGcSHa8nE=
MIME-Version: 1.0
In-Reply-To: <4C85F0E3.2050908@ladisch.de>
References: <AANLkTiktFQWvz-TzewKYEd1wtEbe3cVFjFca4dFtUTCV@mail.gmail.com>
	<4C85F0E3.2050908@ladisch.de>
Date: Tue, 7 Sep 2010 13:53:23 +0530
Message-ID: <AANLkTi=-=88y=6kvV-WC3b5Pw7cf_ZoPaxhUnYugQK81@mail.gmail.com>
Subject: Re: Hungry for hardware timers
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 7, 2010 at 1:29 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Jaswinder Singh Rajput wrote:
>> I am investigating how many hardware timers are available for kernel,
>> system applications and user applications for x86 platforms.
>
> Why would you want to have a separate timer for your application?
>

I need a programmable periodic interrupt for an embedded project.

>> Is there any help available for it so that systems developers can use
>> a hook up an interrupt and use any hardware timer.
>
> The kernel is supposed to abstract away the hardware; just use POSIX
> timers.
>
>> In APIC timer, but each core is having only one timer and it is
>> already utilized by Linux :
>> ... APIC TMICT: 00002078
>> ... APIC TMCCT: 00000b5f
>> ... APIC TDCR: 00000003
>
> Having per-CPU timers allows the kernel to avoid synchronizing between
> CPUs.
>
>> HPET have 3 timers :
>> [    0.328157] hpet: ID: 0x8086a201, PERIOD: 0x429b17f
>> [    0.328315] hpet: CFG: 0x3, STATUS: 0x0
>> [    0.328472] hpet: COUNTER_l: 0x6ff120, COUNTER_h: 0x0
>> [    0.329006] hpet: T0: CFG_l: 0x138, CFG_h: 0xf00000
>> [    0.329165] hpet: T0: CMP_l: 0x701baa, CMP_h: 0x0
>> [    0.329324] hpet: T0 ROUTE_l: 0x0, ROUTE_h: 0x0
>> [    0.329483] hpet: T1: CFG_l: 0x0, CFG_h: 0xf00000
>> [    0.330006] hpet: T1: CMP_l: 0xffffffff, CMP_h: 0x0
>> [    0.330166] hpet: T1 ROUTE_l: 0x0, ROUTE_h: 0x0
>> [    0.331005] hpet: T2: CFG_l: 0x0, CFG_h: 0xf00800
>> [    0.331168] hpet: T2: CMP_l: 0xdf751c, CMP_h: 0x0
>> [    0.331328] hpet: T2 ROUTE_l: 0x0, ROUTE_h: 0x0
>>
>> T0 and T2 is already used by Linux and T1 is used for RTC
>
> T2 shouldn't be used.

[    0.323613] hpet: hpet_msi_capability_lookup(621):
..
[    0.325323] hpet: T2: CFG_l: 0x0, CFG_h: 0xf00800
[    0.325483] hpet: T2: CMP_l: 0xffffffff, CMP_h: 0x0
[    0.325639] hpet: T2 ROUTE_l: 0x0, ROUTE_h: 0x0
[    0.325958] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.326279] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.328003] hpet: hpet_late_init(951):
..
[    0.331006] hpet: T2: CFG_l: 0x0, CFG_h: 0xf00800
[    0.331167] hpet: T2: CMP_l: 0xdfe12a, CMP_h: 0x0
[    0.331327] hpet: T2 ROUTE_l: 0x0, ROUTE_h: 0x0

As you can see after hpet_late_init(951) T2 CMP_l is changed.


> What does /proc/interrupts say?
>

$ cat /proc/interrupts
           CPU0       CPU1
  0:     192286          0   IO-APIC-edge      timer
  1:       1039          0   IO-APIC-edge      i8042
  8:         50          0   IO-APIC-edge      rtc0
  9:        637       1903   IO-APIC-fasteoi   acpi
 12:        163        515   IO-APIC-edge      i8042
 16:      21285          0   IO-APIC-fasteoi   i915, ath9k,
ehci_hcd:usb1, uhci_hcd:usb2
 17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
 44:       3511       9569   PCI-MSI-edge      ahci
 45:        515       1569   PCI-MSI-edge      hda_intel
 46:          2          0   PCI-MSI-edge      eth0
NMI:          0          0   Non-maskable interrupts
LOC:     164087     274764   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          0          0   Performance monitoring interrupts
PND:          0          0   Performance pending work
RES:      56164      64218   Rescheduling interrupts
CAL:        650        484   Function call interrupts
TLB:       1165        625   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:          2          2   Machine check polls
ERR:          1
MIS:          0
$

>> System 8254 timer have 3 timers but it seems it is also used by Linux :
>> [ 4923.510233] 0: 83ae 1: 1102 2: 37f2
>> [ 4923.510251] 0: 8382 1: d10 2: 37dc
>
> That thing is horribly slow; nobody would want to use this, if possible.
>

As you seen timers are running may be due to these code :
arch/x86/kernel/apm_32.c:       outb_pit(0x34, PIT_MODE);
 /* binary, mode 2, LSB/MSB, ch 0 */
arch/x86/kernel/i8253.c:                outb_pit(0x34, PIT_MODE);
arch/x86/kernel/i8253.c:                        outb_pit(0x30, PIT_MODE);
arch/x86/kernel/i8253.c:                outb_pit(0x38, PIT_MODE);
arch/x86/kernel/i8253.c:        outb_pit(0x00, PIT_MODE);       /*
latch the count ASAP */
arch/x86/kernel/i8253.c:                outb_pit(0x34, PIT_MODE);
arch/x86/kernel/vmiclock_32.c:  outb_pit(0x3a, PIT_MODE); /* binary,
mode 5, LSB/MSB, ch 0 */

It is also used secretly :
arch/x86/include/asm/mach_timer.h:      outb(0xb0, 0x43);
         /* binary, mode 0, LSB/MSB, Ch 2 */
arch/x86/kernel/acpi/realmode/wakemain.c:               outb(0xb6,
0x43);       /* Ctr 2, squarewave, load, binary */
arch/x86/kernel/tsc.c:  outb(0xb0, 0x43);
arch/x86/kernel/tsc.c:  outb(0xb0, 0x43);


By the way why I am getting this :

[  568.301571] CE: hpet increased min_delta_ns to 7500 nsec
[  568.301736] CE: hpet increased min_delta_ns to 11250 nsec
[  568.301888] CE: hpet increased min_delta_ns to 16875 nsec

Thanks,
--
Jaswinder Singh.
