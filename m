Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab1HVWsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 18:48:46 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:33976 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754178Ab1HVWso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 18:48:44 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Koyamangalath\, Abhilash" <abhilash.kv@ti.com>
Cc: "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "tony\@atomide.com" <tony@atomide.com>,
        "linux\@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson\, Benoit" <b-cousson@ti.com>,
        "paul\@pwsan.com" <paul@pwsan.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hiremath\, Vaibhav" <hvaibhav@ti.com>
Subject: Re: [PATCH 2/2] omap_twl: Prevent SR to enable for am3517/am3505 devices
Organization: Texas Instruments, Inc.
References: <1312473569-1212-1-git-send-email-abhilash.kv@ti.com>
	<87hb5w3kq0.fsf@ti.com>
	<FCCFB4CDC6E5564B9182F639FC3560870370A4D96E@dbde02.ent.ti.com>
Date: Mon, 22 Aug 2011 15:48:40 -0700
In-Reply-To: <FCCFB4CDC6E5564B9182F639FC3560870370A4D96E@dbde02.ent.ti.com>
	(Abhilash Koyamangalath's message of "Mon, 8 Aug 2011 18:18:40 +0530")
Message-ID: <87obzhgj07.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Koyamangalath, Abhilash" <abhilash.kv@ti.com> writes:

> Kevin Hilman wrote:
>>Abhilash K V <abhilash.kv@ti.com> writes:
>> 
>> > From: Vaibhav Hiremath <hvaibhav@ti.com>
>> >
>> > In case of AM3517 & AM3505, Smart Reflex is not applicable so
>> > we must not enable it. So add check for am3517/05 cpu revision
>> > in omap3_twl_init() and return -ENODEV if true, else continue.
>> >
>> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
>> > Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
>> > ---
>> >  arch/arm/mach-omap2/omap_twl.c |    8 ++++++++
>> >  1 files changed, 8 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/arch/arm/mach-omap2/omap_twl.c
>> b/arch/arm/mach-omap2/omap_twl.c
>> > index 07d6140..92fadcb 100644
>> > --- a/arch/arm/mach-omap2/omap_twl.c
>> > +++ b/arch/arm/mach-omap2/omap_twl.c
>> > @@ -269,6 +269,14 @@ int __init omap3_twl_init(void)
>> >        if (!cpu_is_omap34xx())
>> >                return -ENODEV;
>> > 
>> > +     /*
>> > +      * In case of AM3517/AM3505 we should not be going down
>> > +      * further, since SR is not applicable there.
>> > +      */
>> > +     if (cpu_is_omap3505() || cpu_is_omap3517()) {
>> > +             return -ENODEV;
>> > +     }
>> > +
>> 
>> Rather than using cpu_is_*, you should add a new "feature" flag for
>> SmartReflex.  We already have this for things like SGX, IVA, NEON, etc.
>> See <plat/feature.h>
> I did not find a feature.h; 

sorry, I meant <plat/cpu.yh>

> did you mean OMAP3_CHECK_FEATURE macro which is used by
> omap3_check_features(), which gleans for presence of L2CACHE, IVA, SGX, NEON, ISP features
> from the Control Device Status Register (0x4800 244C) ?

yes, OMAP3_HAS_FEATURE()

> There is no such bit-field to indicate the presence of smart-reflex feature in this register.
> AFAIK, there is no such global register as well which could indicate this.

There doesn't have to be a register read to indicate this.  See for
example the HAS_IO_WAKEUP feature.

Kevin


> - Abhilash
>
>> Kevin
>> 
>> 
>> >        if (cpu_is_omap3630()) {
>> >                omap3_mpu_volt_info.vp_vddmin =
>> OMAP3630_VP1_VLIMITTO_VDDMIN;
>> >                omap3_mpu_volt_info.vp_vddmax =
>> OMAP3630_VP1_VLIMITTO_VDDMAX; 
>> 
>> 
