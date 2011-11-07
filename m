Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab1KGCLS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 21:11:18 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61527 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab1KGCLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 21:11:05 -0500
Message-ID: <4EB73E36.1040602@kernel.org>
Date: Sun, 06 Nov 2011 21:11:02 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] x86, topology.c: Enable CPU0 online/offline
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com> <1317832759-10223-7-git-send-email-fenghua.yu@intel.com> <alpine.LFD.2.02.1110052113370.18778@ionos> <493994B35A117E4F832F97C4719C4C04013E1A6784@orsmsx505.amr.corp.intel.com>
In-Reply-To: <493994B35A117E4F832F97C4719C4C04013E1A6784@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2011 06:47 PM, Yu, Fenghua wrote:

>>> +	bsp_hotplug	[X86] BSP (aka CPU0) is hotpluggable.
>>> +			Suspend/resume depends on BSP. It's said some PCI
>>> +			quirks depend on BSP too. But not sure which quirks.
>>
>> Right, not sure what breaks. Go ahead and watch your machine explode.
>>
>>> +			If don't care the dependencies, you can turn on
>>> +			bsp_ hotplug. Suspend will fail if BSP is offlined
>> and
>>> +			you need to online BSP before suspend/resume.
>>
>> And you forgot poweroff and reboot, which have similar dependencies on
>> some machines. That whole low level ACPI stuff is sensitive.
> 
> I tested poweroff, shutdown, and reboot with various reboot_type on a few different platforms. I haven't seen poweroff and reboot issues after CPU0 is offline.
> 
> Do you have specific platforms that I can test poweroff and reboot dependency on CPU0?

> Or we just assume there are some platforms out there that depend on CPU0 for poweroff/reboot?

A classic Linux/ACPI failure happened when HT first shipped.
Some platforms stopped powering off or rebooting 50% of the time.

It turned out that SMM on those machines assumed
it would be triggered from CPU0 and not CPU1.

the original code should have worked, of course,
and most of the time it did -- but some systems broke.
The same will probably happen here.

-Len
