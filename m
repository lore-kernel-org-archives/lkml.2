Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1JKRkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:40:37 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:56730 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754830Ab1JKRkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:40:36 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Koyamangalath\, Abhilash" <abhilash.kv@ti.com>
Cc: "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony\@atomide.com" <tony@atomide.com>,
        "linux\@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson\, Benoit" <b-cousson@ti.com>,
        "paul\@pwsan.com" <paul@pwsan.com>, "V\, Aneesh" <aneesh@ti.com>,
        "Shilimkar\, Santosh" <santosh.shilimkar@ti.com>,
        "christian.gmeiner\@gmail.com" <christian.gmeiner@gmail.com>,
        "Hiremath\, Vaibhav" <hvaibhav@ti.com>
Subject: Re: [PATCH v5 2/3] omap_twl: Prevent SR to enable for am3517/am3505 devices
Organization: Texas Instruments, Inc.
References: <1317363153-10259-1-git-send-email-abhilash.kv@ti.com>
	<1317363153-10259-2-git-send-email-abhilash.kv@ti.com>
	<1317363153-10259-3-git-send-email-abhilash.kv@ti.com>
	<87r52xhhkb.fsf@ti.com> <874nztfw6w.fsf@ti.com>
	<FCCFB4CDC6E5564B9182F639FC356087037AF843F8@dbde02.ent.ti.com>
Date: Tue, 11 Oct 2011 10:40:28 -0700
In-Reply-To: <FCCFB4CDC6E5564B9182F639FC356087037AF843F8@dbde02.ent.ti.com>
	(Abhilash Koyamangalath's message of "Tue, 11 Oct 2011 13:29:01
	+0530")
Message-ID: <87hb3f4eb7.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Koyamangalath, Abhilash" <abhilash.kv@ti.com> writes:

> hi Kevin,
> Apologies for the delayed response, I was on vacation.
>
> On October 01, 2011 4:57 AM, Hilman, Kevin wrote:
>>
>> Abhilash,
>>
>> Kevin Hilman <khilman@ti.com> writes:
>>
>>> Abhilash K V <abhilash.kv@ti.com> writes:
>>>
>>>> From: Abhilash K V <abhilash.kv@ti.com>
>>>>
>>>> In case of AM3517 & AM3505, SmartReflex is not applicable so
>>>> we must not enable it. So omap3_twl_init() is now not called
>>>> when the processor does not support SR.
>>>
>>> This still isn't right.
>>>
>>> The reason to skip the TWL PMIC init is not because SR is not available
>>> (TWL PMICs are quite usable without SR).  The reason to skip TWL PMIC
>>> init is because the PMIC is not present.
> [Abhilash K V] yes, I understand now.
>>>
>>> Instead, we need to fix up the TWL/PMIC init so that TWL-specifics are
>>> only registered if a TWL driver is registered.
>>>
>>
>> Below is a test patch that is a first pass at implementing what I
>> suggested above.  I tested this (along with your patch 3/3) on a
>> 3430/n900 after removing the omap_pmic_init() call frome the board file.
> [Abhilash K V] I'll re-submit the patch with this change (i,e. if you've not already
> pulled it into your branch).

I haven't posted/merged this yet, but I will now that you've tested it.

Thanks.

>>
>> Can you let me know if this solves the problem you're seeing on
>> platforms that don't have TWL PMICs?
> [Abhilash K V] It should, I have validated on  am3517_evm

Thanks, will add a Tested-by from you.

>> After digging into this more, I'm increasingly aware that the way we're
>> managing the init of PMIC stuff is a mess.  Guess I need another round
>> of voltage layer cleanups to fix that up.
> [Abhilash K V] True, and to add to this, the changes required to support only 
> ONE voltage-domain for am35xx would be too many, I believe.

I don't see that part to be an obstacle.

Let's just be sure to use the clock, clockdomain, powerdomain &
voltagedomain data files to describe the hardware.  That is the only
scalable and maintainable way to support these devices.

Any core code changes to fix assumption's we've made that are now wrong
need to be raised and addressed.

Stated differently, we know we have assumptions in the PM core code that
may now be mistaken in light of these new AM3xxx devices.  Rather than
try to trick the core PM code into thinking these devices are "normal"
OMAP3/4 devices, let's fix those assumptions so we can properly support
the new devices.

Kevin
