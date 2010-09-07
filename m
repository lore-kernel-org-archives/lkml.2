Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab0IGKF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 06:05:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43297 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab0IGKFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 06:05:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JXCwZWPQkH6BLS6HzD/OO1ktzzzdHOqaAaqyA0vM+bOnfYzm42Ymz8XH51S3/I/m98
         zL+Go1Y3T5pcjHDPQuZVgKKHFVTWDjEQbgFc6sI57BkL49Z20GqswM5etzfSsfnvKGoS
         5UYQP0GWJhkNOcxeTSGCXPCgQjKjju/bf9r84=
MIME-Version: 1.0
In-Reply-To: <4C860043.9000501@ladisch.de>
References: <AANLkTiktFQWvz-TzewKYEd1wtEbe3cVFjFca4dFtUTCV@mail.gmail.com>
	<4C85F0E3.2050908@ladisch.de>
	<AANLkTi=-=88y=6kvV-WC3b5Pw7cf_ZoPaxhUnYugQK81@mail.gmail.com>
	<4C860043.9000501@ladisch.de>
Date: Tue, 7 Sep 2010 15:27:09 +0530
Message-ID: <AANLkTimbDOb-iJgRmpEb29GVfP-K0_6TtvPSF7eK-2ts@mail.gmail.com>
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

On Tue, Sep 7, 2010 at 2:35 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Jaswinder Singh Rajput wrote:
>> On Tue, Sep 7, 2010 at 1:29 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
>>> Jaswinder Singh Rajput wrote:
>>>> I am investigating how many hardware timers are available for kernel,
>>>> system applications and user applications for x86 platforms.
>>>
>>> Why would you want to have a separate timer for your application?
>>
>> I need a programmable periodic interrupt for an embedded project.
>
> And why do you not want to use POSIX timers for this?
>

OK, I will try POSIX timers for the application but for system module
my preference is HPET T2.

>>>> HPET have 3 timers :
>>>> T0 and T2 is already used by Linux and T1 is used for RTC
>>>
>>> T2 shouldn't be used.
>>
>> [    0.323613] hpet: hpet_msi_capability_lookup(621):
>> ..
>> [    0.325323] hpet: T2: CFG_l: 0x0, CFG_h: 0xf00800
>> [    0.325483] hpet: T2: CMP_l: 0xffffffff, CMP_h: 0x0
>> [    0.325639] hpet: T2 ROUTE_l: 0x0, ROUTE_h: 0x0
>> [    0.325958] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
>> [    0.326279] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
>> [    0.328003] hpet: hpet_late_init(951):
>> ..
>> [    0.331006] hpet: T2: CFG_l: 0x0, CFG_h: 0xf00800
>> [    0.331167] hpet: T2: CMP_l: 0xdfe12a, CMP_h: 0x0
>> [    0.331327] hpet: T2 ROUTE_l: 0x0, ROUTE_h: 0x0
>>
>> As you can see after hpet_late_init(951) T2 CMP_l is changed.
>
> Strange; nobody should be accessing this.

But it is changing in vanilla kernel.

> Do you need to use it before hpet_late_init?
>

No.

>>> What does /proc/interrupts say?
>>
>> $ cat /proc/interrupts
>>            CPU0       CPU1
>>   0:     192286          0   IO-APIC-edge      timer
>>   1:       1039          0   IO-APIC-edge      i8042
>>   8:         50          0   IO-APIC-edge      rtc0
>>   9:        637       1903   IO-APIC-fasteoi   acpi
>>  12:        163        515   IO-APIC-edge      i8042
>>  16:      21285          0   IO-APIC-fasteoi   i915, ath9k, ehci_hcd:usb1, uhci_hcd:usb2
>>  17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
>>  18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
>>  19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
>>  44:       3511       9569   PCI-MSI-edge      ahci
>>  45:        515       1569   PCI-MSI-edge      hda_intel
>>  46:          2          0   PCI-MSI-edge      eth0
>
> Nobody is using /dev/hpet, you should be able to grab it for T2.
>

OK. What will be IRQ # for T2.

If I access /dev/hpet by hpet_example it shows that it is using HPET
T0 as hi_hpet is 0 :

#./hpet_example info /dev/hpet
-hpet: executing info
hpet_info: hi_irqfreq 0x0 hi_flags 0x0 hi_hpet 0 hi_timer 2

As per dmesg([    0.325958] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0)
so IRQs are like this :
HPET T0 : 2
HPET T1 : 8
HPET T2 : 0

Is it right, or I am missing something.

Thanks,
--
Jaswinder Singh.
