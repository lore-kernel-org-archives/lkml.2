Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab2JRWoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:44:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37375 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab2JRWn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:43:59 -0400
Message-ID: <5080862C.9030203@wwwdotorg.org>
Date: Thu, 18 Oct 2012 16:43:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] ARM: tegra: fix clock entry of slink controller
References: <1350557795-31487-1-git-send-email-ldewangan@nvidia.com> <1350557795-31487-4-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1350557795-31487-4-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 04:56 AM, Laxman Dewangan wrote:
> Fix the driver name, connection name and clock name
> for slink controller clocks in clock table of
> Tegra20 and Tegra30.

The patch subject isn't entirely accurate here; this patch isn't just
about fixing clock entries.

> diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c

> @@ -90,6 +90,10 @@ struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
>  		       &tegra_ehci3_pdata),
>  	OF_DEV_AUXDATA("nvidia,tegra20-apbdma", TEGRA_APB_DMA_BASE, "tegra-apbdma", NULL),
>  	OF_DEV_AUXDATA("nvidia,tegra20-pwm", TEGRA_PWFM_BASE, "tegra-pwm", NULL),
> +	OF_DEV_AUXDATA("nvidia,tegra20-slink", TEGRA_SLINK1_BASE, "spi-tegra-slink.0", NULL),

Here, can't we just use the existing device names in the clock files...

So we can completely drop the changes to these two files:

> diff --git a/arch/arm/mach-tegra/tegra20_clocks_data.c b/arch/arm/mach-tegra/tegra20_clocks_data.c
> diff --git a/arch/arm/mach-tegra/tegra30_clocks_data.c b/arch/arm/mach-tegra/tegra30_clocks_data.c

The device names will hopefully be irrelevant once we're able to use
DT-based clock lookups.
