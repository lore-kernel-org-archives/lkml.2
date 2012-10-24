Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935402Ab2JXRy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:54:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59756 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934943Ab2JXRy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:54:58 -0400
Message-ID: <50882B6E.5020103@wwwdotorg.org>
Date: Wed, 24 Oct 2012 11:54:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCHv2] ARM: Push selects for TWD/SCU into machine entries
References: <1351099475-29349-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1351099475-29349-1-git-send-email-sboyd@codeaurora.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 11:24 AM, Stephen Boyd wrote:
> The TWD and SCU configs are selected by default as long as
> MSM_SCORPIONMP is false and/or MCT is false. Implementing the
> logic this way certainly saves lines in the Kconfig but it
> precludes those machines which select MSM_SCORPIONMP or MCT from
> participating in the single zImage effort because when those
> machines are combined with other SMP capable machines the TWD and
> SCU are no longer selected by default.
> 
> Push the select out to the machine entries so that we can compile
> these machines together and still select the appropriate configs.

Acked-by: Stephen Warren <swarren@nvidia.com>

> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig

> @@ -633,6 +633,8 @@ config ARCH_TEGRA
>  	select GENERIC_GPIO
>  	select HAVE_CLK
>  	select HAVE_SMP
> +	select HAVE_ARM_SCU if SMP
> +	select HAVE_ARM_TWD if LOCAL_TIMERS
>  	select MIGHT_HAVE_CACHE_L2X0
>  	select SPARSE_IRQ
>  	select USE_OF

Where will this patch be merged?

It probably won't happen for 3.8, but that config fragment will move to
arch/arm/mach-tegra/Kconfig when Tegra enables single zImage support, I
believe. So, it'd be good to make sure this patch gets merged somewhere
that could be used as a baseline for other arm-soc branches if needed,
to avoid merge conflicts.
