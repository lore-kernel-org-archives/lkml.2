Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab1KQTvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 14:51:01 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6848 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab1KQTu7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 14:50:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 17 Nov 2011 11:50:42 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 17 Nov 2011 11:50:40 -0800
Subject: RE: [PATCH 09/10] arm/tegra: implement support for tegra30
Thread-Topic: [PATCH 09/10] arm/tegra: implement support for tegra30
Thread-Index: AcylRVKsjgPnVLrDS8O6G5XBqxGKSQAHH63w
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740D74C51@HQMAIL01.nvidia.com>
References: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
 <1321546766-26770-10-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1321546766-26770-10-git-send-email-pdeschrijver@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter De Schrijver wrote at Thursday, November 17, 2011 9:19 AM:
> Add support for tegra30 SoC. This includes a device tree compatible type for
> this SoC ("nvidia,tegra30") and adds L2 cache initialization for this new SoC.
> The clock framework is still missing, which prevents most drivers from working.
> The basic IRQs are the same, so remove the dependency on
> CONFIG_ARCH_TEGRA_2x_SOC.

> diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
> index 416446b..0b9d184 100644
> --- a/arch/arm/mach-tegra/board-dt.c
> +++ b/arch/arm/mach-tegra/board-dt.c
> @@ -149,3 +149,11 @@ DT_MACHINE_START(TEGRA_DT, "nVidia Tegra20 (Flattened Device Tree)")
>  	.init_machine	= tegra_dt_init,
>  	.dt_compat	= tegra20_dt_board_compat,
>  MACHINE_END

Since you're reving the patch, a blank line between the two machines would
be nice.

> +DT_MACHINE_START(TEGRA30_DT, "nVidia Tegra30 (Flattened Device Tree)")
> +	.map_io		= tegra_map_common_io,
> +	.init_early	= tegra30_init_early,
> +	.init_irq	= tegra_init_irq,
> +	.timer		= &tegra_timer,
> +	.init_machine	= tegra_dt_init,
> +	.dt_compat	= tegra30_dt_board_compat,

That variable doesn't exist until the next patch; that'll break git bisect.

Do the two DT_MACHINE_START's need if be ifdef'd based on CONFIG variables too?
If not, I'm not sure how a Tegra20- or Tegra30-only kernel builds, since aren't
some of those init functions ifdef'd out but referenced here?

> +MACHINE_END

-- 
nvpublic

