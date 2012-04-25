Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab2DYMyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:54:18 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:60821 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752882Ab2DYMyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:54:16 -0400
X-Greylist: delayed 151186 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2012 08:54:16 EDT
MIME-Version: 1.0
In-Reply-To: <CAMQu2gzwijaSzXprEwTNTie3zCgFcNPonAexzrO_AWc2a8jOkw@mail.gmail.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
	<1328203851-20435-12-git-send-email-tarun.kanti@ti.com>
	<13629551.hP3ZV1ajDo@vclass>
	<CAC83ZvK630=6B-k2TfV3XBg8w7ZosLVDNE4ezjDYnn=hcXA48Q@mail.gmail.com>
	<CAC83ZvJDDvCu8NKTOYh75USA3fvSAKEGaXXi9PtCM955K_keSA@mail.gmail.com>
	<20120424160447.GI3739@atomide.com>
	<CAC83Zv+CCLQfZHfqMcbof6JtA-hOK1PfX5Gs0BBVQhBAiWzX_g@mail.gmail.com>
	<CAMQu2gzwijaSzXprEwTNTie3zCgFcNPonAexzrO_AWc2a8jOkw@mail.gmail.com>
Date: Wed, 25 Apr 2012 18:24:14 +0530
Message-ID: <CAC83ZvKN_Qxw-9RPfpJaL5434j0HgysZ364F+b29rdSCQWhm7A@mail.gmail.com>
Subject: Re: [PATCH v9 11/25] gpio/omap: cleanup omap_gpio_mod_init function
From: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>, linux-omap@vger.kernel.org,
        grant.likely@secretlab.ca, khilman@ti.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Charulatha V <charu@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 12:09 PM, Shilimkar, Santosh
<santosh.shilimkar@ti.com> wrote:
> On Wed, Apr 25, 2012 at 10:04 AM, DebBarma, Tarun Kanti
> <tarun.kanti@ti.com> wrote:
>> On Tue, Apr 24, 2012 at 9:34 PM, Tony Lindgren <tony@atomide.com> wrote:
>>> * DebBarma, Tarun Kanti <tarun.kanti@ti.com> [120424 08:40]:
>>>> Hi Janusz,
>>>>
>>>> On Tue, Apr 24, 2012 at 12:24 AM, DebBarma, Tarun Kanti
>>>> <tarun.kanti@ti.com> wrote:
>>>> > On Sat, Apr 21, 2012 at 7:33 PM, Janusz Krzysztofik
>>>> > <jkrzyszt@tis.icnet.pl> wrote:
>>>> >> On Thursday 02 of February 2012 23:00:37 Tarun Kanti DebBarma wrote:
>>>> >>> With register offsets now defined for respective OMAP versions we can get rid
>>>> >>> of cpu_class_* checks. This function now has common initialization code for
>>>> >>> all OMAP versions...
>>>> >>>
>>>> >>> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
>>>> >>> Signed-off-by: Charulatha V <charu@ti.com>
>>>> >>> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>>> >>> Acked-by: Tony Lindgren <tony@atomide.com>
>>>> >>
>>>> >> Sorry for being so late with my comment for chanes already present in
>>>> >> mainline, but this patch breaks GPIO on Amstrad Delta at least, and I
>>>> >> have neither enough spare time nor enough experience with non OMAP1
>>>> >> machines to provide a solution myself.
>>>> > Yes, I looked at the omap_gpio_mod_init() and OMAP1 configurations are
>>>> > overwritten.
>>>> > Also looks like there is issue in making distinction between omap15xx
>>>> > and omap16xx.
>>>> > I will post a patch and you can help me testing it in OMAP1 platform.
>>>> > Thanks for pointing this out.
>>> ...
>>>
>>>> Here is the patch, with attachment as well. I have just tested on
>>>> OMAP4 platform.
>>>> Testing on other OMAP2+ platforms is pending. In the meantime can you please
>>>> validate on OMAP1 platform and confirm? Thanks.
>>>> --
>>>> Tarun
>>>>
>>>> From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
>>>> Date: Tue, 24 Apr 2012 20:34:32 +0530
>>>> Subject: [PATCH] gpio/omap: fix omap1 register overwrite in omap_gpio_mod_init
>>>>
>>>> Initialization of irqenable, irqstatus registers is the common
>>>> operation done in this function for all OMAP platforms, viz.
>>>> OMAP1, OMAP2+. The latter _gpio_rmw()'s to irqenable register
>>>> was overwriting the correctly programmed OMAP1 value at the
>>>> beginning. As a result, even though it worked on OMAP2+
>>>> platforms it was breaking OMAP1 functionality.
>>>
>>> Sounds like the original patch was never tested on omap1?
>> That's right, only bootup test was done on OMAP1710-SDP.
>>
>>>
>>>> On closer observation it is found that the first _gpio_rmw()
>>>> which is supposedly done to take care of OMAP1 platform is
>>>> generic enough and takes care of OMAP2+ platform as well.
>>>> Therefore remove the latter _gpio_rmw() to irqenable as they
>>>> are redundant.
>>>>
>>>> Also, changing the sequence and logic of initializing the
>>>> irqstatus.
>>>
>>> Please mention also the breaking commit here and get this fix
>>> merged as a regression as soon as it's tested for the current
>>> -rc series.
>> Sure, I will do that!
>
> Looks like it is regression on 3.4 as well so CC stable when you
> post the patch.
Ok, I will do that.
--
Tarun
>
> Regards
> Santosh
