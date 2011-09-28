Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1I1Ruy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:50:54 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4550 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab1I1Rux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:50:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 28 Sep 2011 10:50:46 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        "Olof Johansson (olof@lixom.net)" <olof@lixom.net>,
        Erik Gilling <konkers@android.com>,
        "Arnd Bergmann (arnd@arndb.de)" <arnd@arndb.de>
Date: Wed, 28 Sep 2011 10:50:45 -0700
Subject: RE: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
Thread-Topic: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
Thread-Index: Acx9ex4gFSki3VItQvuwrAusRIsfLQAixXiA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173955580F@HQMAIL01.nvidia.com>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Tuesday, September 27, 2011 7:08 PM:
> This patch causes the kernel uncompressor to determine the physical address
> of the SDRAM at runtime. This allows the kernel to boot on both tegra20 and
> tegra30 even though SDRAM is at different physical addresses on both SoCs.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

An alternative would be to simply add that config option to the relevant
defconfig/.config file. I see both cases in use in the kernel. Still, the
code change this enables looks fine to just turn on all the time, and will
be needed for Tegra30 support, so I'm fine just selecting it as you have.

Acked-by: Stephen Warren <swarren@nvidia.com>

> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 472a7f8..474737b 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -596,6 +596,7 @@ config ARCH_TEGRA
>  	select HAVE_CLK
>  	select HAVE_SCHED_CLOCK
>  	select ARCH_HAS_CPUFREQ
> +	select AUTO_ZRELADDR
>  	help
>  	  This enables support for NVIDIA Tegra based systems (Tegra APX,
>  	  Tegra 6xx and Tegra 2 series).

P.S. Since this patch relates to Tegra, you should CC the Tegra maintainers
and list; I've done so on this message. I also added Arnd; he might take
this through the arm-soc tree.

-- 
nvpublic

