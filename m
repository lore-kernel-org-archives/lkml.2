Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab1KLD0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 22:26:35 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50557 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab1KLD0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 22:26:34 -0500
Message-ID: <4EBDE766.5080505@gmail.com>
Date: Fri, 11 Nov 2011 21:26:30 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 01/10] arm/tegra: initial device tree for tegra30
References: <1321010541-31337-1-git-send-email-pdeschrijver@nvidia.com> <1321010541-31337-2-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1321010541-31337-2-git-send-email-pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2011 05:22 AM, Peter De Schrijver wrote:
> This patch adds the initial device tree for tegra30
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>  arch/arm/boot/dts/tegra30.dtsi |  127 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 127 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/boot/dts/tegra30.dtsi
> 
> diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
> new file mode 100644
> index 0000000..fabe243
> --- /dev/null
> +++ b/arch/arm/boot/dts/tegra30.dtsi
> @@ -0,0 +1,127 @@
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	compatible = "nvidia,tegra30";

Needs documentation.

> +	interrupt-parent = <&intc>;
> +
> +	intc: interrupt-controller@50041000 {
> +		compatible = "nvidia,tegra30-gic", "nvidia,tegra20-gic";
> +		interrupt-controller;
> +		#interrupt-cells = <1>;

Is the Tegra GIC really different from a standard A9 gic? You need to
update to use the gic binding. The cells should be 3 for example.

Rob

> +		reg = < 0x50041000 0x1000 >,
> +		      < 0x50040100 0x0100 >;
> +	};
> +
> +	i2c@7000c000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible =  "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
> +		reg = <0x7000C000 0x100>;
> +		interrupts = < 70 >;
> +	};
> +
> +	i2c@7000c400 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
> +		reg = <0x7000C400 0x100>;
> +		interrupts = < 116 >;
> +	};
> +
> +	i2c@7000c500 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
> +		reg = <0x7000C500 0x100>;
> +		interrupts = < 124 >;
> +	};
> +
> +	i2c@7000c700 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
> +		reg = <0x7000c700 0x100>;
> +		interrupts = < 152 >;
> +	};
> +
> +	i2c@7000d000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
> +		reg = <0x7000D000 0x100>;
> +		interrupts = < 85 >;
> +	};
> +
> +	gpio: gpio@6000d000 {
> +		compatible = "nvidia,tegra30-gpio", "nvidia,tegra20-gpio";
> +		reg = < 0x6000d000 0x1000 >;
> +		interrupts = < 64 65 66 67 87 119 121 >;
> +		#gpio-cells = <2>;
> +		gpio-controller;
> +	};
> +
> +	serial@70006000 {
> +		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
> +		reg = <0x70006000 0x40>;
> +		reg-shift = <2>;
> +		interrupts = < 68 >;
> +	};
> +
> +	serial@70006040 {
> +		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
> +		reg = <0x70006040 0x40>;
> +		reg-shift = <2>;
> +		interrupts = < 69 >;
> +	};
> +
> +	serial@70006200 {
> +		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
> +		reg = <0x70006200 0x100>;
> +		reg-shift = <2>;
> +		interrupts = < 78 >;
> +	};
> +
> +	serial@70006300 {
> +		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
> +		reg = <0x70006300 0x100>;
> +		reg-shift = <2>;
> +		interrupts = < 122 >;
> +	};
> +
> +	serial@70006400 {
> +		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
> +		reg = <0x70006400 0x100>;
> +		reg-shift = <2>;
> +		interrupts = < 123 >;
> +	};
> +
> +	sdhci@78000000 {
> +		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
> +		reg = <0x78000000 0x200>;
> +		interrupts = < 46 >;
> +	};
> +
> +	sdhci@78000200 {
> +		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
> +		reg = <0x78000200 0x200>;
> +		interrupts = < 47 >;
> +	};
> +
> +	sdhci@78000400 {
> +		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
> +		reg = <0x78000400 0x200>;
> +		interrupts = < 51 >;
> +	};
> +
> +	sdhci@78000600 {
> +		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
> +		reg = <0x78000600 0x200>;
> +		interrupts = < 63 >;
> +	};
> +
> +	pinmux: pinmux@70000000 {
> +		compatible = "nvidia,tegra30-pinmux";
> +		reg = < 0x70000868 0xd0     /* Pad control registers */
> +			0x70003000 0x3e0 >; /* Mux registers */
> +	};
> +};

