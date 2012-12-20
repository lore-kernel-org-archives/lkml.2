Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab2LTL2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 06:28:33 -0500
Received: from service87.mimecast.com ([91.220.42.44]:48004 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2LTL20 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 06:28:26 -0500
Message-ID: <50D2F61E.10900@arm.com>
Date: Thu, 20 Dec 2012 11:27:26 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, John Stultz <johnstul@us.ibm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/9] ARM: dt: tegra114: Add new SoC base, Tegra 114 SoC
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com> <1355996654-6579-7-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1355996654-6579-7-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 20 Dec 2012 11:27:26.0941 (UTC) FILETIME=[FD4EB8D0:01CDDEA4]
X-MC-Unique: 112122011272802401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/12/12 09:44, Hiroshi Doyu wrote:
> Initial support for Tegra 114 SoC. This is expected to be included in
> the board DTS files, Tegra 114 SoC based evaluation board family.
> 
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>

You definitely need to add some cpu nodes here, or get someone to merge
the NR_CPUS=0 patch: https://lkml.org/lkml/2012/3/31/131

;-)

> ---
>  arch/arm/boot/dts/tegra114.dtsi |   89 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 89 insertions(+)
>  create mode 100644 arch/arm/boot/dts/tegra114.dtsi
> 
> diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
> new file mode 100644
> index 0000000..a5b7330
> --- /dev/null
> +++ b/arch/arm/boot/dts/tegra114.dtsi
> @@ -0,0 +1,89 @@
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	compatible = "nvidia,tegra114";
> +	interrupt-parent = <&gic>;
> +
> +	gic: interrupt-controller {
> +		compatible = "arm,cortex-a15-gic", "arm,cortex-a9-gic";
> +		reg = <0x50041000 0x1000
> +		       0x50042000 0x1000>;

If this is indeed an A15 GIC, how about adding the GICH and GICV
regions, as well as the VGIC maintenance interrupt?

> +		interrupt-controller;
> +		#interrupt-cells = <3>;
> +	};
> +
> +	timer@60005000 {
> +		compatible = "nvidia,tegra114-timer", "nvidia,tegra20-timer";
> +		reg = <0x60005000 0x400>;
> +		interrupts = <0 0 0x04
> +			      0 1 0x04
> +			      0 41 0x04
> +			      0 42 0x04
> +			      0 121 0x04
> +			      0 122 0x04>;
> +	};
> +
> +	serial@70006000 {
> +		compatible = "nvidia,tegra114-uart", "nvidia,tegra20-uart";
> +		reg = <0x70006000 0x40>;
> +		reg-shift = <2>;
> +		interrupts = <0 36 0x04>;
> +		status = "disabled";
> +	};
> +
> +	serial@70006040 {
> +		compatible = "nvidia,tegra114-uart", "nvidia,tegra20-uart";
> +		reg = <0x70006040 0x40>;
> +		reg-shift = <2>;
> +		interrupts = <0 37 0x04>;
> +		status = "disabled";
> +	};
> +
> +	serial@70006200 {
> +		compatible = "nvidia,tegra114-uart", "nvidia,tegra20-uart";
> +		reg = <0x70006200 0x100>;
> +		reg-shift = <2>;
> +		interrupts = <0 46 0x04>;
> +		status = "disabled";
> +	};
> +
> +	serial@70006300 {
> +		compatible = "nvidia,tegra114-uart", "nvidia,tegra20-uart";
> +		reg = <0x70006300 0x100>;
> +		reg-shift = <2>;
> +		interrupts = <0 90 0x04>;
> +		status = "disabled";
> +	};
> +
> +	serial@70006400 {
> +		compatible = "nvidia,tegra114-uart", "nvidia,tegra20-uart";
> +		reg = <0x70006400 0x100>;
> +		reg-shift = <2>;
> +		interrupts = <0 91 0x04>;
> +		status = "disabled";
> +	};
> +
> +	rtc {
> +		compatible = "nvidia,tegra114-rtc", "nvidia,tegra20-rtc";
> +		reg = <0x7000e000 0x100>;
> +		interrupts = <0 2 0x04>;
> +	};
> +
> +	pmc {
> +		compatible = "nvidia,tegra114-pmc", "nvidia,tegra20-pmc";
> +		reg = <0x7000e400 0x400>;
> +	};
> +
> +	tsc {
> +		compatible = "nvidia,tegra114-tsc";
> +		reg = <0x700f0000 0x20000>;
> +	};
> +
> +	timer {
> +		compatible = "arm,armv7-timer";
> +		interrupts = <1 13 0xf08>,
> +			     <1 14 0xf08>,
> +			     <1 11 0xf08>,
> +			     <1 10 0xf08>;
> +	};
> +};
> 


-- 
Jazz is not dead. It just smells funny...

