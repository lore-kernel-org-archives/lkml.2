Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab2JHMQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 08:16:05 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39894 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2JHMQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:16:01 -0400
Message-ID: <1349698556.4322.18.camel@hornet>
Subject: Re: [PATCH] ARM: Push selects for TWD/SCU into machine entries
From: Pawel Moll <pawel.moll@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Simon Horman <horms@verge.net.au>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tony Lindgren <tony@atomide.com>,
        Viresh Kumar <viresh.linux@gmail.com>
Date: Mon, 08 Oct 2012 13:15:56 +0100
In-Reply-To: <1349340644-13937-1-git-send-email-sboyd@codeaurora.org>
References: <1349340644-13937-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: Evolution 3.2.3-0ubuntu6
Mime-Version: 1.0
X-OriginalArrivalTime: 08 Oct 2012 12:15:57.0614 (UTC) FILETIME=[AC0C6CE0:01CDA54E]
X-MC-Unique: 112100813155906001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 09:50 +0100, Stephen Boyd wrote:
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
[...]
> diff --git a/arch/arm/mach-vexpress/Kconfig b/arch/arm/mach-vexpress/Kconfig
> index c952960..4f8e0db 100644
> --- a/arch/arm/mach-vexpress/Kconfig
> +++ b/arch/arm/mach-vexpress/Kconfig
> @@ -11,6 +11,8 @@ config ARCH_VEXPRESS
>  	select HAVE_CLK
>  	select HAVE_PATA_PLATFORM
>  	select HAVE_SMP
> +	select HAVE_ARM_SCU if SMP
> +	select HAVE_ARM_TWD if LOCAL_TIMERS
>  	select ICST
>  	select MIGHT_HAVE_CACHE_L2X0
>  	select NO_IOPORT

If you move these two lines before HAVE_CLK so everything stays in
alphabetical order ;-) you can add my Acked-by for vexpress:

Acked-by: Pawel Moll <pawel.moll@arm.com>

Thanks!

Pawel


