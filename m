Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286Ab1KBPqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:46:31 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14655 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab1KBPq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:46:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 02 Nov 2011 08:46:15 -0700
Date: Wed, 2 Nov 2011 17:46:10 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 8/8] arm/tegra: add support for tegra30 based board
 cardhu
Message-ID: <20111102154610.GJ13358@tbergstrom-lnx.Nvidia.com>
References: <1320242948-21061-1-git-send-email-pdeschrijver@nvidia.com>
 <1320242948-21061-9-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1320242948-21061-9-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 03:09:07PM +0100, Peter De Schrijver wrote:
> Add support for the tegra30 based cardhu development board. Cardhu is a tablet
> formfactor reference design for tegra30. The patch provides a device tree for
> the board, updates Makefile.boot to build the dtb, includes the platform in
> Kconfig and updates board-dt.c.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>  arch/arm/boot/dts/tegra-cardhu.dts |   36 ++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-tegra/Kconfig        |    7 +++++++
>  arch/arm/mach-tegra/Makefile.boot  |    1 +
>  arch/arm/mach-tegra/board-dt.c     |    1 +
>  4 files changed, 45 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/boot/dts/tegra-cardhu.dts
> 
> diff --git a/arch/arm/boot/dts/tegra-cardhu.dts b/arch/arm/boot/dts/tegra-cardhu.dts
> new file mode 100644
> index 0000000..70c41fc
> --- /dev/null
> +++ b/arch/arm/boot/dts/tegra-cardhu.dts
> @@ -0,0 +1,36 @@
> +/dts-v1/;
> +
> +/include/ "tegra30.dtsi"
> +
> +/ {
> +	model = "NVIDIA Tegra30 Cardhu evaluation board";

And this should probably be removed.

> +	compatible = "nvidia,cardhu", "nvidia,tegra30";
> +
> +	memory {
> +		reg = < 0x80000000 0x40000000 >;
> +	};
> +
> +	serial@70006000 {
> +		clock-frequency = < 408000000 >;
> +	};
> +
> +	i2c@7000c000 {
> +		clock-frequency = <100000>;
> +	};
> +
> +	i2c@7000c400 {
> +		clock-frequency = <100000>;
> +	};
> +
> +	i2c@7000c500 {
> +		clock-frequency = <100000>;
> +	};
> +
> +	i2c@7000c700 {
> +		clock-frequency = <100000>;
> +	};
> +
> +	i2c@7000d000 {
> +		clock-frequency = <100000>;
> +	};
> +};
> diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
> index f2eb6d1..43a6352 100644
> --- a/arch/arm/mach-tegra/Kconfig
> +++ b/arch/arm/mach-tegra/Kconfig
> @@ -83,6 +83,13 @@ config MACH_VENTANA
>         help
>           Support for the nVidia Ventana development platform
>  
> +config MACH_CARDHU
> +       bool "Cardhu board"
> +       depends on ARCH_TEGRA_3x_SOC
> +       select MACH_TEGRA_DT
> +       help
> +         Support for the nVidia Cardhu development platform

This should have been NVIDIA. Will be fixed in the next version. Most other
nvidia boards use 'nVidia' in their description. What should we do?

Cheers,

Peter.
