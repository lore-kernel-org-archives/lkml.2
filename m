Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab3ACOHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:07:42 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11904 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab3ACOHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:07:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 03 Jan 2013 06:04:28 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "olof@lixom.net" <olof@lixom.net>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 3 Jan 2013 15:06:56 +0100
Subject: Re: [PATCH 0/9] ARM: Initial support for Tegra 114 SoC.
Thread-Topic: [PATCH 0/9] ARM: Initial support for Tegra 114 SoC.
Thread-Index: Ac3pu5h0rgYJANECRVe0+3Jxv3NnVg==
Message-ID: <20130103.160656.1043855724416946158.hdoyu@nvidia.com>
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Hiroshi Doyu <hdoyu@nvidia.com> wrote @ Thu, 20 Dec 2012 10:43:58 +0100:

> Hi,
> 
> This patchset adds initial support for the NVIDIA's new Tegra 114
> SoC (T114) based on the ARM Cortex-A15 MP. It has the minimal support
> to allow the kernel to boot up into shell console. This can be used as
> a basis for adding other device drivers for this SoC. Currently there
> are 2 evaluation boards available, "Dalmore" and "Pluto".

I'll resend v2 of this series just with /cpus node in DT added. The
rest would be same since TSC initialization and dynamic core
detections are still necessary/valid for Tegra as backup of /cpus DT
failure. Or if you take this series as is first, I'll make a /cpus DT
patchset agaist this series.

> This patchset is against Stephen Warren's linux-next_common branch:
> 
>   git://nv-tegra.nvidia.com/user/swarren/linux-2.6 linux-next_common
> 
> For those who want to try:
> 
>   $ make ARCH=arm tegra_defconfig
>   $ scripts/config -e ARCH_TEGRA_114_SOC -d DRM -d SUSPEND \
>     	-d PM_RUNTIME -d CPU_FREQ -d CPU_IDLE
>   $ make ARCH=arm menuconfig # if needed to configure more
>   $ make ARCH=arm all -j9
> 
> Verified that this single image booted up with "Dalmore(T114)",
> "Pluto(T114)" and "Cardhu(T30)". For "Cardhu(T30)" with this single
> image, SPI driver doesn't seem to afford the above configuration , it
> hangs at boot-up. With SPI disabled, it's ok.
> 
> 
> Hiroshi Doyu (9):
>   ARM: tegra: fuse: Add chipid TEGRA114 0x35
>   HACK: ARM: tegra: Use CLK_IGNORE_UNUSED for Tegra 114 SoC
>   ARM: tegra: # of CPU cores detection w/ & w/o HAVE_ARM_SCU
>   clocksource: tegra: Reorganize funcs by clock functionarities
>   clocksource: tegra: Enable ARM arch_timer with TSC
>   ARM: dt: tegra114: Add new SoC base, Tegra 114 SoC
>   ARM: dt: tegra114: Add new board, Dalmore
>   ARM: dt: tegra114: Add new board, Pluto
>   ARM: tegra: Add initial support for Tegra 114 SoC.
> 
>  .../bindings/arm/tegra/nvidia,tegra114-tsc.txt     |   11 +
>  arch/arm/boot/dts/Makefile                         |    4 +-
>  arch/arm/boot/dts/tegra114-dalmore.dts             |   21 ++
>  arch/arm/boot/dts/tegra114-pluto.dts               |   21 ++
>  arch/arm/boot/dts/tegra114.dtsi                    |   89 ++++++++
>  arch/arm/mach-tegra/Kconfig                        |   10 +
>  arch/arm/mach-tegra/Makefile                       |    1 +
>  arch/arm/mach-tegra/board-dt-tegra114.c            |   48 +++++
>  arch/arm/mach-tegra/common.c                       |    1 +
>  arch/arm/mach-tegra/fuse.h                         |    1 +
>  arch/arm/mach-tegra/platsmp.c                      |   31 ++-
>  arch/arm/mach-tegra/tegra30_clocks_data.c          |    2 +
>  drivers/clocksource/tegra20_timer.c                |  222 +++++++++++++-------
>  13 files changed, 384 insertions(+), 78 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/tegra/nvidia,tegra114-tsc.txt
>  create mode 100644 arch/arm/boot/dts/tegra114-dalmore.dts
>  create mode 100644 arch/arm/boot/dts/tegra114-pluto.dts
>  create mode 100644 arch/arm/boot/dts/tegra114.dtsi
>  create mode 100644 arch/arm/mach-tegra/board-dt-tegra114.c
> 
> -- 
> 1.7.9.5
> 
