Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab2EGXzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 19:55:24 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:37102 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757743Ab2EGXzX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 19:55:23 -0400
From: Kevin Hilman <khilman@ti.com>
To: "J\, KEERTHY" <j-keerthy@ti.com>
Cc: "AnilKumar\, Chimata" <anilkumar@ti.com>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rjw\@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm\@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "Pihet-XID\, Jean" <j-pihet@ti.com>
Subject: Re: [PATCH V3 04/10] ARM: OMAP3: hwmod: rename the smartreflex entries
Organization: Texas Instruments, Inc.
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
	<1335462041-4949-5-git-send-email-j-keerthy@ti.com>
	<331ABD5ECB02734CA317220B2BBEABC13E9B1AA2@DBDE01.ent.ti.com>
	<CAJ6a13ZSWSa_RpGB9NxtfyChUba9NGivGogpsfyk7oT9pNayjg@mail.gmail.com>
	<87d36fzhkm.fsf@ti.com>
Date: Mon, 07 May 2012 16:55:37 -0700
In-Reply-To: <87d36fzhkm.fsf@ti.com> (Kevin Hilman's message of "Mon, 07 May
	2012 16:39:53 -0700")
Message-ID: <87r4uvwnpi.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Hilman <khilman@ti.com> writes:

> "J, KEERTHY" <j-keerthy@ti.com> writes:

[...]

>>>> diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
>>>> index 2edd1e2..d859277 100644
>>>> --- a/arch/arm/mach-omap2/smartreflex.c
>>>> +++ b/arch/arm/mach-omap2/smartreflex.c
>>>> @@ -183,7 +183,7 @@ static void sr_set_regfields(struct omap_sr *sr)
>>>>               sr->err_weight = OMAP3430_SR_ERRWEIGHT;
>>>>               sr->err_maxlimit = OMAP3430_SR_ERRMAXLIMIT;
>>>>               sr->accum_data = OMAP3430_SR_ACCUMDATA;
>>>> -             if (!(strcmp(sr->name, "sr1"))) {
>>>> +             if (!(strcmp(sr->name, "smartreflex_mpu_iva"))) {
>>>
>>> What if voltage rail is different for mpu and iva? I have seen some devices
>>> supports SmartReflex have different voltage rails for mpu and iva.
>>>
>>
>> I get the point. OMAP3 iva and mpu have a common rail. OMAP4 onwards
>> even we have different rails for mpu and iva. I will enhance the checks here.
>
> Rather than enhancing the checks, this SoC specific data should probably
> just be made part of the SoC specific hwmod dev_attr.

That being said, this is an additional feature we can add after this
driver is moved.

I would like this series to concentrate on the cleanups necessary to
move to drivers/*, then additional features to support other SoCs can be
added on top.

Keerthy, please prepare a patch to generalize this to other SoCs by
using dev_attr for this SoC specific data.   We can add it after this
series is merged upstream.

Thanks,

Kevin
