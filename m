Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1LIOaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:30:16 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47762 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab1LIOaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:30:14 -0500
Message-ID: <4EE21B67.5040006@gmail.com>
Date: Fri, 09 Dec 2011 08:29:59 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>, Gary King <gking@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v6 10/10] arm/tegra: add support for tegra30 based board
 cardhu
References: <1323348254-29072-1-git-send-email-pdeschrijver@nvidia.com> <1323348254-29072-11-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1323348254-29072-11-git-send-email-pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 06:43 AM, Peter De Schrijver wrote:
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
> +	compatible = "nvidia,cardhu", "nvidia,tegra30";
> +
> +	memory {

memory@80000000

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
> index aad54ca..6bae1bb 100644
> --- a/arch/arm/mach-tegra/Kconfig
> +++ b/arch/arm/mach-tegra/Kconfig
> @@ -91,6 +91,13 @@ config MACH_VENTANA
>         help
>           Support for the nVidia Ventana development platform
>  
> +config MACH_CARDHU
> +       bool "Cardhu board"
> +       depends on ARCH_TEGRA_3x_SOC
> +       select MACH_TEGRA_DT
> +       help
> +         Support for the NVIDIA Cardhu development platform
> +

You should not be adding kconfig entries for boards. They should
eventually go away with DT.

>  choice
>          prompt "Low-level debug console UART"
>          default TEGRA_DEBUG_UART_NONE
> diff --git a/arch/arm/mach-tegra/Makefile.boot b/arch/arm/mach-tegra/Makefile.boot
> index cf51a00..7c1110f 100644
> --- a/arch/arm/mach-tegra/Makefile.boot
> +++ b/arch/arm/mach-tegra/Makefile.boot
> @@ -7,3 +7,4 @@ dtb-$(CONFIG_MACH_PAZ00) += tegra-paz00.dtb
>  dtb-$(CONFIG_MACH_SEABOARD) += tegra-seaboard.dtb
>  dtb-$(CONFIG_MACH_TRIMSLICE) += tegra-trimslice.dtb
>  dtb-$(CONFIG_MACH_VENTANA) += tegra-ventana.dtb
> +dtb-$(CONFIG_MACH_CARDHU) += tegra-cardhu.dtb

Likewise, this should be more like:
dtb-$(CONFIG_MACH_TEGRA_DT) += tegra-seaboard.dtb tegra-trimslice.dtb
tegra-ventana.dtb ...

Rob
> diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
> index d1ed473..14ef047 100644
> --- a/arch/arm/mach-tegra/board-dt.c
> +++ b/arch/arm/mach-tegra/board-dt.c
> @@ -157,6 +157,7 @@ MACHINE_END
>  
>  #ifdef CONFIG_ARCH_TEGRA_3x_SOC
>  static const char *tegra30_dt_board_compat[] = {
> +	"nvidia,cardhu",
>  	NULL
>  };
>  
