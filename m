Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab0IGJEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 05:04:53 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.30]:60571 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab0IGJEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 05:04:48 -0400
Message-ID: <4C860043.9000501@ladisch.de>
Date: Tue, 07 Sep 2010 11:05:07 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Hungry for hardware timers
References: <AANLkTiktFQWvz-TzewKYEd1wtEbe3cVFjFca4dFtUTCV@mail.gmail.com>	<4C85F0E3.2050908@ladisch.de> <AANLkTi=-=88y=6kvV-WC3b5Pw7cf_ZoPaxhUnYugQK81@mail.gmail.com>
In-Reply-To: <AANLkTi=-=88y=6kvV-WC3b5Pw7cf_ZoPaxhUnYugQK81@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> On Tue, Sep 7, 2010 at 1:29 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
>> Jaswinder Singh Rajput wrote:
>>> I am investigating how many hardware timers are available for kernel,
>>> system applications and user applications for x86 platforms.
>>
>> Why would you want to have a separate timer for your application?
> 
> I need a programmable periodic interrupt for an embedded project.

And why do you not want to use POSIX timers for this?

>>> HPET have 3 timers :
>>> T0 and T2 is already used by Linux and T1 is used for RTC
>>
>> T2 shouldn't be used.
> 
> [    0.323613] hpet: hpet_msi_capability_lookup(621):
> ..
> [    0.325323] hpet: T2: CFG_l: 0x0, CFG_h: 0xf00800
> [    0.325483] hpet: T2: CMP_l: 0xffffffff, CMP_h: 0x0
> [    0.325639] hpet: T2 ROUTE_l: 0x0, ROUTE_h: 0x0
> [    0.325958] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [    0.326279] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> [    0.328003] hpet: hpet_late_init(951):
> ..
> [    0.331006] hpet: T2: CFG_l: 0x0, CFG_h: 0xf00800
> [    0.331167] hpet: T2: CMP_l: 0xdfe12a, CMP_h: 0x0
> [    0.331327] hpet: T2 ROUTE_l: 0x0, ROUTE_h: 0x0
> 
> As you can see after hpet_late_init(951) T2 CMP_l is changed.

Strange; nobody should be accessing this.
Do you need to use it before hpet_late_init?

>> What does /proc/interrupts say?
> 
> $ cat /proc/interrupts
>            CPU0       CPU1
>   0:     192286          0   IO-APIC-edge      timer
>   1:       1039          0   IO-APIC-edge      i8042
>   8:         50          0   IO-APIC-edge      rtc0
>   9:        637       1903   IO-APIC-fasteoi   acpi
>  12:        163        515   IO-APIC-edge      i8042
>  16:      21285          0   IO-APIC-fasteoi   i915, ath9k, ehci_hcd:usb1, uhci_hcd:usb2
>  17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
>  18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
>  19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
>  44:       3511       9569   PCI-MSI-edge      ahci
>  45:        515       1569   PCI-MSI-edge      hda_intel
>  46:          2          0   PCI-MSI-edge      eth0

Nobody is using /dev/hpet, you should be able to grab it for T2.

> By the way why I am getting this :
> 
> [  568.301571] CE: hpet increased min_delta_ns to 7500 nsec
> [  568.301736] CE: hpet increased min_delta_ns to 11250 nsec
> [  568.301888] CE: hpet increased min_delta_ns to 16875 nsec

On my AMD machine, this happens only if I have C1E enabled, and only up
to 11250 ns.  It seems your BIOS has installed a SMI.


Regards,
Clemens
