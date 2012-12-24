Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2LXJ7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 04:59:09 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:59745 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab2LXJ7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 04:59:06 -0500
Message-ID: <50D82760.6060706@gmail.com>
Date: Mon, 24 Dec 2012 17:58:56 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        Jason Cooper <jason@lakedaemon.net>, Shawn Guo <shawn.guo@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/9] ARM: Initial support for Tegra 114 SoC.
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 05:43 PM, Hiroshi Doyu wrote:
> Hi,
> 
> This patchset adds initial support for the NVIDIA's new Tegra 114
> SoC (T114) based on the ARM Cortex-A15 MP. It has the minimal support
> to allow the kernel to boot up into shell console. This can be used as
> a basis for adding other device drivers for this SoC. Currently there
> are 2 evaluation boards available, "Dalmore" and "Pluto".
> 
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

I think we also need to enable:

CONFIG_ARM_APPENDED_DTB
CONFIG_ARM_ATAG_DTB_COMPAT

because currently we append the dtb to the kernel image(will not do this
after u-boot supports dalmore and we can load the dtb in u-boot cmd), so
we need to make kernel being aware of this.

My experience is after I enabled these 2 configs, kernel starts up normally.

Mark
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
