Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab2F1RaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:30:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1216 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2F1RaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:30:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 28 Jun 2012 10:29:57 -0700
Message-ID: <4FEC948D.9080606@nvidia.com>
Date: Thu, 28 Jun 2012 22:59:49 +0530
From: Prashant G <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mturquette@ti.com" <mturquette@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH 5/6] ARM: tegra: Port tegra to generic clock framework
References: <1340879846-12900-1-git-send-email-pgaikwad@nvidia.com> <1340879846-12900-6-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1340879846-12900-6-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is not delivered to all mailing lists reason being the 
message body too big.
It can be viewed at https://lkml.org/lkml/2012/6/28/158

Thanks & Regards,
Prashant G

On Thursday 28 June 2012 04:07 PM, Prashant Gaikwad wrote:
> This patch converts tegra clock code to generic clock framework in following way:
>   - Implement clk_ops as required by generic clk framework. (tegraXX_clocks.c)
>   - Use platform specific struct clk_tegra in clk_ops implementation instead of struct clk.
>   - Initialize all clock data statically. (tegraXX_clocks_data.c)
>
> Legacy framework did not have recalc_rate and is_enabled functions. Implemented these functions.
> Removed init function. It's functionality is splitted into recalc_rate and is_enabled.
>
> Static initialization is used since slab is not up in .init_early and clock
> is needed to be initialized before clockevent/clocksource initialization.
> Macros redefined for clk_tegra.
>
> Also, single struct clk_tegra is used for all type of clocks (PLL, peripheral etc.). This
> is to move quickly to generic common clock framework so that other dependent features will
> not be blocked (such as DT binding).
>
> Enabling COMMON_CLOCK config moved to ARCH_TEGRA since it is enabled for both Tegra20
> and Tegra30.
>
> Signed-off-by: Prashant Gaikwad<pgaikwad@nvidia.com>
> ---
>   arch/arm/Kconfig                          |    1 +
>   arch/arm/mach-tegra/clock.h               |    1 +
>   arch/arm/mach-tegra/tegra20_clocks.c      |  986 +++++++++--------
>   arch/arm/mach-tegra/tegra20_clocks.h      |    4 +
>   arch/arm/mach-tegra/tegra20_clocks_data.c | 1318 +++++++++++++----------
>   arch/arm/mach-tegra/tegra30_clocks.c      | 1331 +++++++++++++----------
>   arch/arm/mach-tegra/tegra30_clocks.h      |   14 +-
>   arch/arm/mach-tegra/tegra30_clocks_data.c | 1688 ++++++++++++++++-------------
>   8 files changed, 3029 insertions(+), 2314 deletions(-)
>
>

