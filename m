Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab2JEGn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 02:43:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53920 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab2JEGnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 02:43:55 -0400
Message-ID: <506E8157.5030801@ti.com>
Date: Fri, 5 Oct 2012 12:12:31 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Stephen Boyd <sboyd@codeaurora.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: Push selects for TWD/SCU into machine entries
References: <1349340644-13937-1-git-send-email-sboyd@codeaurora.org> <506D52D2.9060105@ti.com> <20121005011237.GA17182@verge.net.au>
In-Reply-To: <20121005011237.GA17182@verge.net.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 October 2012 06:42 AM, Simon Horman wrote:
> On Thu, Oct 04, 2012 at 02:41:46PM +0530, Santosh Shilimkar wrote:
>> On Thursday 04 October 2012 02:20 PM, Stephen Boyd wrote:
>>> The TWD and SCU configs are selected by default as long as
>>> SCORPIONMP is false and/or MCT is false. Implementing the logic
>>> this way certainly saves lines in the Kconfig but it precludes
>>> those machines which select SCORPIONMP or MCT from participating
>>> in the single zImage effort because when those machines are
>>> combined with other SMP capable machines the TWD and SCU are no
>>> longer selected.
>>>
>>> Push the select out to the machine entries so that we can compile
>>> these machines together and still select the appropriate configs.
>>>
>>> Signed-off-by: Stephen Boyd<sboyd@codeaurora.org>
>>> Cc: David Brown<davidb@codeaurora.org>
>>> Cc: Kukjin Kim<kgene.kim@samsung.com>
>>> Cc: Linus Walleij<linus.walleij@linaro.org>
>>> Cc: Pawel Moll<pawel.moll@arm.com>
>>> Cc: Rob Herring<rob.herring@calxeda.com>
>>> Cc: Russell King<linux@arm.linux.org.uk>
>>> Cc: Sascha Hauer<kernel@pengutronix.de>
>>> Cc: Shiraz Hashim<shiraz.hashim@st.com>
>>> Cc: Simon Horman<horms@verge.net.au>
>>> Cc: Srinidhi Kasagar<srinidhi.kasagar@stericsson.com>
>>> Cc: Stephen Warren<swarren@wwwdotorg.org>
>>> Cc: Tony Lindgren<tony@atomide.com>
>>> Cc: Viresh Kumar<viresh.linux@gmail.com>
>>> ---
>>>
>>> Does OMAP5 need to select TWD? I suspect not if it uses the
>>> architected timers.
>>>
>> Nope. OMAP5 don't use TWD. Infact the external SCU is also used
>> for A9 SOCs. You might want to check other A15 SOCS for SCU as
>> well.
>
> In that case I am a bit confused by the following result:
>
> # git checkout v3.6
> # ARCH=arm make omap2plus_defconfig
> # grep '(SOC_OMAP5|_SCU|_TWD|CONFIG_SMP|CONFIG_LOCAL_TIMERS)=' .config
> CONFIG_SOC_OMAP5=y
> CONFIG_SMP=y
> CONFIG_HAVE_ARM_SCU=y
> CONFIG_HAVE_ARM_TWD=y
> CONFIG_LOCAL_TIMERS=y

Thats because omap2plus_defconfig build all the OMAP machines together
including OMAP4 and OMAP5.

Regards
Santosh
