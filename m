Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab2JVP5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:57:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52435 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab2JVP47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:56:59 -0400
Message-ID: <50856CC6.7010403@wwwdotorg.org>
Date: Mon, 22 Oct 2012 09:56:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Ralf Baechle <ralf@linux-mips.org>,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: Make the generic clock API available by default
References: <1350910970-9095-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1350910970-9095-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 07:02 AM, Mark Brown wrote:
> Rather than requiring platforms to select the generic clock API to make
> it available make the API available as a user selectable option unless the
> user either selects HAVE_CUSTOM_CLK (if they have their own implementation)
> or selects COMMON_CLK (if they depend on the generic implementation).
> 
> All current architectures that HAVE_CLK but don't use the common clock
> framework have selects of HAVE_CUSTOM_CLK added.
> 
> This allows drivers to use the generic API on platforms which have no need
> for the clock API at platform level.

> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig

> @@ -632,6 +634,7 @@ config ARCH_TEGRA
>  	select GENERIC_CLOCKEVENTS
>  	select GENERIC_GPIO
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	select HAVE_SMP
>  	select MIGHT_HAVE_CACHE_L2X0
>  	select SPARSE_IRQ

Since v3.7-rc1, Tegra uses common clock, so I don't think the change
above is right is it?
