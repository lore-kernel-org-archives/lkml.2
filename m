Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2G3DEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 23:04:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48860 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab2G3DEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 23:04:04 -0400
X-AuditID: cbfee60c-b7f9d6d000002370-2c-5015f9a02dfb
Date: Mon, 30 Jul 2012 03:04:00 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: Gethering power management/policy hw drivers under drivers/power/?
 (Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences)
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Alex Courbot <acourbot@nvidia.com>, Jean Pihet <j-pihet@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Liam Girdwood <lrg@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120730025844645@myungjoo.ham
Msgkey: 20120730025844645@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120730025844645@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <31696994.4431343617434187.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t/tGboLfooGGPQfsbK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZe1ZfYS7oEar4d/s8awPjGcEuRk4OIQF1iUVLTrJ1MXJwSAiY
	SDzsEwUJSwiISVy4tx4ozAVUMp9RomvtFVaQBIuAqsTM0+9YQerZBMwl7s8IAqkRFuhllFjY
	MwmsRkSgXGLOi+OMIAlmgUVsEs9/32CCWKYksWbfKxYQm1dAUOLkzCcsENtUJS59Wc8EEVeT
	+De5nx0iLiExa/oFVgibV2JG+1OoejmJaV/XMEPY0hLnZ21ghLl68ffHUHF+iWO3dzBBPMYr
	8eR+MMyY3Zu/sEHYAhJTzxyEatWSePb8GZTNJ7Fm4VsWmDG7Ti1nhum9v2Uu2JnMAooSU7of
	skPYWhJffuxjQ/cWr4CDxN3OT4wTGOVmIUnNQtI+C0k7spoFjCyrGEVTC5ILipPSU430ihNz
	i0vz0vWS83M3MYLj/BnPDsY5DRaHGAU4GJV4eI0uiwYIsSaWFVfmHmKU4GBWEuG9dg4oxJuS
	WFmVWpQfX1Sak1p8iFGag0VJnPez11d/IYH0xJLU7NTUgtQimCwTB6dUA2OMZ0R432WuHa/y
	6k+vWhm12mTajppLTpdnnFXgstFYYXC+wjdUcJL+jrmHC4SPi79s8lUufPtiTRjzbIUHFkbF
	IR7r7acLPbm6TsrDVPf8reOJK92ChOUWlP3lu8b4q1xbdmNQ1cIbvKE8tz/8NdwwW59d4uH8
	1BmRz0vnSgjfk4m4p3o4co4SS3FGoqEWc1FxIgC5CC4g7wIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6U34iiG002727

> On Mon, Jul 30, 2012 at 10:51:42AM +0900, Alex Courbot wrote:
> [...]
> > On the other hand I have just noticed that the apparently unrelated
> > Adaptive Voltage Scaling driver just appeared in drivers/power/avs.
> > So if Anton and David are ok with this, maybe I could put the power
> > sequences code in its own subdirectory within drivers/power.
> 
> Well, currently drivers/power/ is indeed just for power supply class
> subsystem and drivers. But if the trend is to gather power management
> ("policy") stuff under one directory, i.e.
> 
> drivers/
>   power/
>     supplies/    <- former "power supply class and drivers"
>     regulators/
>     idle/
>     cpuidle/
>     cpufreq/
>     devfreq/
>     avs/
>     ...
> 
> That would probably make sense, we could easily see the big picture.
> But if we're not going to do this long-term, I would suggest to stick
> to just a new directory under drivers (and move drivers/power/avs/ to
> drivers/avs).
> 
> Cc'ing some more people...
> 
> Thanks,
> 
> p.s. Jean, why am I the last person who discovers drivers/power/avs/?
> Would be nice to Cc me on such patches; by moving AVS under
> drivers/power/ you effectively nominated me as its maintainer. :-)
> 
> -- 
> Anton Vorontsov
> Email: cbouatmailru@gmail.com
> 

Having power-supplies at /drivers/power/ and other power-related drivers spread at /drivers/ have been bugging me as well. I'd like to see the change you've suggested though I'm not sure how significant the side-effect will be at this point.

Generally speaking, yes, I also think the proposal is more reasonable than the current structure.



Cheers!
MyungJoo


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
