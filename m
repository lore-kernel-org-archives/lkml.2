Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab1BRANA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:13:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab1BRAM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:12:57 -0500
Message-ID: <4D5DB962.8020005@redhat.com>
Date: Thu, 17 Feb 2011 22:12:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jan Beulich <JBeulich@novell.com>, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com, arozansk@redhat.com, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, resend] x86/PCI: don't export a __devinit function
References: <4D5D562A0200007800032744@vpn.id2.novell.com>	<4D5D6517.5060600@redhat.com> <AANLkTi=SR-HsBuOA0V6GPtD4wY+s663_6TT9aJVVjjrK@mail.gmail.com>
In-Reply-To: <AANLkTi=SR-HsBuOA0V6GPtD4wY+s663_6TT9aJVVjjrK@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 17-02-2011 21:12, Yinghai Lu escreveu:
> On Thu, Feb 17, 2011 at 10:12 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 17-02-2011 14:08, Jan Beulich escreveu:
>>> Exporting a __devinit function (pcibios_scan_specific_bus()) isn't
>>> correct. (Michal, any reason why modpost only warns about exported
>>> __init functions?) Short of being able to think of a better solution,
>>> and short of making the whole call tree (reaching into the arch-
>>> independent part of the PCI subsystem) non-__devinit, export the
>>> symbol only when HOTPLUG is enabled (which is always the case for non-
>>> expert configurations), use section mismatch avoidance annotations for
>>> that case (knowing that __devinit functions will not be discarded),
>>> and mark the symbol __devinit only in the !HOTPLUG case.
>>>
>>> Consequently, EDAC_I7CORE (consuming the export) then has to depend on
>>> HOTPLUG.
>>
>> Having the entire i7core_edac driver depending on HOTPLUG, just because
>> a few BIOSes want to hide the non-core PCI devices doesn't seem nice.
>> One alternative would be to enclose the code that needs this function
>> with #ifdef CONFIG_HOTPLUG.
>>
>>> A fundamental question of course if whether this driver has
>>> to use that function in the first place (i.e. whether it wouldn't be
>>> better to just remove the export) - the problem it tries to address
>>> happens on other systems too, but the PCI bus the devices in question
>>> live on isn't necessarily bus 255. For the affected system I have, the
>>> alternative approach is to set pcibios_last_bus from __pci_mmcfg_init()
>>> based on the highest bus number on segment 0 being covered by MCFG.
>>
>> I received a few days ago a report that some BIOSes that hide those
>> PCI devices also use a different address for the last bus (0x3f, instead
>> of 0xff). So, it seems that the better would be to use an alternative
>> way to retrieve the last bus.
> 
> just append "pci=lastbus=255" will get all those devices.

I know, but the better would be if this could be detected, instead of
relying on a modprobe parameter.

Cheers,
Mauro
