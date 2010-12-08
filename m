Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab0LHPW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:22:29 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44114 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab0LHPW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:22:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Zd4yA8VIhpRiACvijJ6ClnP6/btEA6atVymUCSz4BZT3ZI9U39lcPbrYPivnpT/Hni
         tbWDi8eMPViopRLdsFHRmLodDc/U4RGXuv5WzYHV9V0F6VcEprPMVxX9IdEKiX7kUzxL
         TtAW7mh/bl4RMIT6XX6+OEtrd6fnfDXAqf5U0=
MIME-Version: 1.0
In-Reply-To: <201012080845.49604.pluto@agmk.net>
References: <201012071906.47161.pluto@agmk.net>
	<4CFEE2F9.90600@gmail.com>
	<201012080845.49604.pluto@agmk.net>
Date: Wed, 8 Dec 2010 09:22:26 -0600
Message-ID: <AANLkTi=UveeX1o1XX0DMERRe-=pY2H55The1cKg2BtUJ@mail.gmail.com>
Subject: Re: [2.6.36.1] IGB driver handles all ethX interrupts on single cpu core.
From: Robert Hancock <hancockrwd@gmail.com>
To: =?ISO-8859-2?Q?Pawe=B3_Sikora?= <pluto@agmk.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/8 Pawe³ Sikora <pluto@agmk.net>:
> On Wednesday 08 of December 2010 02:44:25 Robert Hancock wrote:
>> On 12/07/2010 12:06 PM, Pawe³ Sikora wrote:
>> > hi,
>> >
>> > i'm currently testing a new server with 2x opteron-6128 with dual gigabit port
>> > and observing that the igb driver uses only single core for all ethX interrupts.
>> > is it a correct behaviour for this driver?
>> >
>> > BR,
>> > Pawel.
>>
>> The CPU affinity for the IRQ isn't really under the driver's control. It
>> looks like all your interrupts are being handled on CPU0. You likely
>> need to run the irqbalance daemon.
>
> ok, so why e.g. on one machine (dual amd opteron) irqbalance daemon is required
> and on second machine (single intel quad-core) irqs are balanced w/o daemon?
> this looks inconsistent to me.
>
> $ cat /proc/interrupts
>           CPU0       CPU1       CPU2       CPU3
>  0:         49          2          0          0   IO-APIC-edge      timer
>  1:          0          1          0          1   IO-APIC-edge      i8042
>  8:         13         11         12         13   IO-APIC-edge      rtc0
>  9:          0          0          0          0   IO-APIC-fasteoi   acpi
>  12:          0          0          3          1   IO-APIC-edge      i8042
>  16:        224        236        235        232   IO-APIC-fasteoi   pata_marvell, uhci_hcd:usb3
>  17:          0          0          0          0   IO-APIC-fasteoi   saa7133[0], saa7133[0]
>  18:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb5, uhci_hcd:usb8
>  19:        695        672        660        630   IO-APIC-fasteoi   uhci_hcd:usb7
>  21:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
>  23:          1          1          1          0   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb6
>  40:       3409       3446       3441       3403   PCI-MSI-edge      ahci
>  41:         63         60         60         61   PCI-MSI-edge      hda_intel
>  42:       3219       3180       3237       3192   PCI-MSI-edge      radeon
>  43:        505        487        496        498   PCI-MSI-edge      eth0
> NMI:         11          7         12          8   Non-maskable interrupts
> LOC:      14822      15293      17577      14404   Local timer interrupts
> SPU:          0          0          0          0   Spurious interrupts
> PMI:         11          7         12          8   Performance monitoring interrupts
> PND:          0          0          0          0   Performance pending work
> RES:        493        498        525        495   Rescheduling interrupts
> CAL:       3975        248       2729        299   Function call interrupts
> TLB:        937       1727        913       1600   TLB shootdowns
> TRM:          0          0          0          0   Thermal event interrupts
> THR:          0          0          0          0   Threshold APIC interrupts
> MCE:          0          0          0          0   Machine check exceptions
> MCP:          2          2          2          2   Machine check polls
> ERR:          3
> MIS:          0

Is the kernel configuration the same? Also, I think some chipsets
handle IRQ distribution differently than others (I believe if
interrupts are enabled for more than one CPU for a given IRQ line,
some chipsets will distribute them across CPUs and some send them all
to the same CPU).
