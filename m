Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2JDJNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 05:13:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43846 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab2JDJNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 05:13:05 -0400
Message-ID: <506D52D2.9060105@ti.com>
Date: Thu, 4 Oct 2012 14:41:46 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: <linux-arm-kernel@lists.infradead.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Simon Horman <horms@verge.net.au>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] ARM: Push selects for TWD/SCU into machine entries
References: <1349340644-13937-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1349340644-13937-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 October 2012 02:20 PM, Stephen Boyd wrote:
> The TWD and SCU configs are selected by default as long as
> SCORPIONMP is false and/or MCT is false. Implementing the logic
> this way certainly saves lines in the Kconfig but it precludes
> those machines which select SCORPIONMP or MCT from participating
> in the single zImage effort because when those machines are
> combined with other SMP capable machines the TWD and SCU are no
> longer selected.
>
> Push the select out to the machine entries so that we can compile
> these machines together and still select the appropriate configs.
>
> Signed-off-by: Stephen Boyd<sboyd@codeaurora.org>
> Cc: David Brown<davidb@codeaurora.org>
> Cc: Kukjin Kim<kgene.kim@samsung.com>
> Cc: Linus Walleij<linus.walleij@linaro.org>
> Cc: Pawel Moll<pawel.moll@arm.com>
> Cc: Rob Herring<rob.herring@calxeda.com>
> Cc: Russell King<linux@arm.linux.org.uk>
> Cc: Sascha Hauer<kernel@pengutronix.de>
> Cc: Shiraz Hashim<shiraz.hashim@st.com>
> Cc: Simon Horman<horms@verge.net.au>
> Cc: Srinidhi Kasagar<srinidhi.kasagar@stericsson.com>
> Cc: Stephen Warren<swarren@wwwdotorg.org>
> Cc: Tony Lindgren<tony@atomide.com>
> Cc: Viresh Kumar<viresh.linux@gmail.com>
> ---
>
> Does OMAP5 need to select TWD? I suspect not if it uses the
> architected timers.
>
Nope. OMAP5 don't use TWD. Infact the external SCU is also used
for A9 SOCs. You might want to check other A15 SOCS for SCU as
well.

[..]

>   arch/arm/mach-omap2/Kconfig    | 4 ++++

[..]

> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index a6219ea..b618748 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -58,7 +58,9 @@ config ARCH_OMAP4
>   	select CPU_V7
>   	select ARM_GIC
>   	select HAVE_SMP
> +	select HAVE_ARM_SCU if SMP
>   	select LOCAL_TIMERS if SMP
> +	select HAVE_ARM_TWD if LOCAL_TIMERS
>   	select PL310_ERRATA_588369
>   	select PL310_ERRATA_727915
>   	select ARM_ERRATA_720789
Ok.

> @@ -75,6 +77,8 @@ config SOC_OMAP5
>   	select CPU_V7
>   	select ARM_GIC
>   	select HAVE_SMP
> +	select HAVE_ARM_SCU if SMP
> +	select HAVE_ARM_TWD if LOCAL_TIMERS
>   	select ARM_CPU_SUSPEND if PM
>   	select SOC_HAS_REALTIME_COUNTER
>   	select ARM_ARCH_TIMER
Drop this change.

With that fixed, for OMAP changes

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
