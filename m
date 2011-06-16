Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab1FPQUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:20:36 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:13070
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754446Ab1FPQUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:20:33 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 17 Jun 2011 00:26:01 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: <devicetree-discuss@lists.ozlabs.org>, Randy Dunlap <rdunlap@xenotime.net>,
        <linaro-dev@lists.linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: [RFC] (early draft) dt: Linux dt usage model documentation
Message-ID: <20110616162600.GA9611@S2100-06.ap.freescale.net>
References: <20110613132935.16600.94753.stgit@ponder>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110613132935.16600.94753.stgit@ponder>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 07:32:15AM -0600, Grant Likely wrote:
[...]
> +About now is a good time to lay out an example.  Here is part of the
> +device tree for the NVIDIA Tegra board.
> +
> +/{
> +	compatible = "nvidia,harmony", "nvidia,tegra250";
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	interrupt-parent = <&intc>;
> +
> +	chosen { };
> +	aliases { };
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0x00000000 0x40000000>;
> +	};
> +
> +	soc {
> +		compatible = "nvidia,tegra250-soc", "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		intc: interrupt-controller@50041000 {
> +			compatible = "nvidia,tegra250-gic";
> +			interrupt-controller;
> +			#interrupt-cells = <1>;
> +			reg = <0x50041000 0x1000>, < 0x50040100 0x0100 >;
> +		};
> +
> +		serial@70006300 {
> +			compatible = "nvidia,tegra250-uart";
> +			reg = <0x70006300 0x100>;
> +			interrupts = <122>;
> +		};
> +
> +		i2s-1: i2s@70002800 {

It seem dtc does not compile the label name "i2s-1".  Instead,
"i2s_1" seems good.

> +			compatible = "nvidia,tegra250-i2s";
> +			reg = <0x70002800 0x100>;
> +			interrupts = <77>;
> +			codec = <&wm8903>;
> +		};
> +
> +		i2c@7000c000 {
> +			compatible = "nvidia,tegra250-i2c";
> +			#address-cells = <1>;
> +			#size-cells = <1>;

#size-cells should be 0 ...

> +			reg = <0x7000c000 0x100>;
> +			interrupts = <70>;
> +
> +			wm8903: codec@1a {
> +				compatible = "wlf,wm8903";
> +				reg = <0x1a>;

... Otherwise, reg needs a size here.

> +				interrupts = <347>;
> +			};
> +		};
> +	};
> +
> +	sound {
> +		compatible = "nvidia,harmony-sound";
> +		i2s-controller = <&i2s-1>;
> +		i2s-codec = <&wm8903>;
> +	};
> +};
> +

-- 
Regards,
Shawn

