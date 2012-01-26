Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2AZU0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 15:26:53 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11767 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab2AZU0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 15:26:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 26 Jan 2012 12:26:37 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jan 2012 12:25:53 -0800
Subject: RE: [PATCH v1 3/8] ARM: tegra: rework Tegra secondary CPU core
 bringup
Thread-Topic: [PATCH v1 3/8] ARM: tegra: rework Tegra secondary CPU core
 bringup
Thread-Index: AczcTRDPkL9m+qbFQ5uJUhtF7lemZwAGz9Bg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178CB8246B@HQMAIL01.nvidia.com>
References: <1327597641-7519-1-git-send-email-pdeschrijver@nvidia.com>
 <1327597641-7519-4-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1327597641-7519-4-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Thursday, January 26, 2012 10:07 AM:
> Prepare the Tegra secondary CPU core bringup code for other Tegra variants.
> The reset handler is also generalized to allow for future introduction of
> powersaving modes which turn off the CPU cores.

> diff --git a/arch/arm/mach-tegra/headsmp.S b/arch/arm/mach-tegra/headsmp.S

>  ENTRY(tegra_secondary_startup)
...
> +	enable_coresight r0

> +ENTRY(__tegra_cpu_reset_handler)
> +
> +#if DEBUG_CPU_RESET_HANDLER
> +	enable_coresight r0
> +	b	.
> +#endif

I'm not sure why the macro call enable_coresight is ifdef'd in one place
but not the other... Should just the instruction "b ." be inside the
ifdef?

> diff --git a/arch/arm/mach-tegra/reset.c b/arch/arm/mach-tegra/reset.c

> +static void tegra_cpu_reset_handler_enable(void)

> +	/*
> +	 * Prevent further modifications to the physical reset vector.
> +	 *  NOTE: Has no effect on chips prior to Tegra30.
> +	 */
> +	reg = readl(sb_ctrl);
> +	reg |= 2;
> +	writel(reg, sb_ctrl);
> +	wmb();

Should we skip that on Tegra20 then?

> +void __init tegra_cpu_reset_handler_init(void)
> +{
> +	unsigned long *cpu_reset_data_start, *cpu_reset_data_end;

Those variables are unused.

-- 
nvpublic

