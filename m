Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab1GSXAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 19:00:21 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4846 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab1GSXAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 19:00:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 19 Jul 2011 16:00:12 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Andrew Chew <AChew@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "olof@lixom.net" <olof@lixom.net>,
        Dan Willemsen <dwillemsen@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Venkat Moganty <vmoganty@nvidia.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@vger.kernel.org" <linux-arm-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Chew <AChew@nvidia.com>
Date: Tue, 19 Jul 2011 16:00:11 -0700
Subject: RE: [PATCH 2/3] dt: tegra20: Add ehci host controller nodes.
Thread-Topic: [PATCH 2/3] dt: tegra20: Add ehci host controller nodes.
Thread-Index: AcxGZjibySVyNvOjT6ieM+DaizC9YgAAOLuA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049EBDED27@HQMAIL01.nvidia.com>
References: <1311115617-9697-1-git-send-email-achew@nvidia.com>
 <1311115617-9697-2-git-send-email-achew@nvidia.com>
In-Reply-To: <1311115617-9697-2-git-send-email-achew@nvidia.com>
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

achew@nvidia.com wrote at Tuesday, July 19, 2011 4:47 PM:
> From: Andrew Chew <achew@nvidia.com>
> 
> These values were derived from various headers in arch/arm/mach-tegra.
> 
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
>  arch/arm/boot/dts/tegra20.dtsi |   52 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 52 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
> index 83fedf3..a0353bb 100644
> --- a/arch/arm/boot/dts/tegra20.dtsi
> +++ b/arch/arm/boot/dts/tegra20.dtsi
> @@ -160,5 +160,57 @@
>  		interrupts = < 63 >;
>  		status = "disabled";
>  	};
> +
> +	ehci@c5000000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;

I don't think those two properties are needed for an EHCI node; children
of the EHCI controller are probed rather than specified in device tree.

> +		compatible = "nvidia,tegra20-ehci";
> +		reg = <0xc5000000 0x4000>;
> +		interrupts = < 52 >;
> +		mode = < 1 >;

Should we make mode a string; device, host, or otg?

> +		power_down_on_bus_suspend;
> +		type = "utmi";
> +		hssync_start_delay = < 0 >;
> +		idle_wait_delay = < 17 >;
> +		elastic_limit = < 16 >;
> +		term_range_adj = < 6 >;
> +		xcvr_setup = < 15 >;
> +		xcvr_lsfslew = < 2 >;
> +		xcvr_lsrslew = < 2 >;
> +		status = "disabled";

In the latest devicetree/test, tegra20.dtsi doesn't specify status for
any nodes, but leaves everything enabled. Instead, board-specific files
disable any unused devices.

> +	};
> +
> +	ehci@c5004000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "nvidia,tegra20-ehci";
> +		reg = <0xc5004000 0x4000>;
> +		interrupts = < 53 >;
> +		mode = < 1 >;
> +		power_down_on_bus_suspend;
> +		type = "ulpi";
> +		reset_gpio = < 169 >;
> +		clk = "cdev2";
> +		status = "disabled";
> +	};
> +
> +	ehci@c5008000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "nvidia,tegra20-ehci";
> +		reg = <0xc5008000 0x4000>;
> +		interrupts = < 129 >;
> +		mode = < 1 >;
> +		power_down_on_bus_suspend;
> +		type = "utmi";
> +		hssync_start_delay = < 0 >;
> +		idle_wait_delay = < 17 >;
> +		elastic_limit = < 16 >;
> +		term_range_adj = < 6 >;
> +		xcvr_setup = < 8 >;
> +		xcvr_lsfslew = < 2 >;
> +		xcvr_lsrslew = < 2 >;
> +		status = "disabled";
> +	};
>  };
> 
> --
> 1.7.6

-- 
nvpublic

