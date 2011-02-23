Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab1BWAgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 19:36:41 -0500
Received: from ozlabs.org ([203.10.76.45]:58240 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab1BWAgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 19:36:39 -0500
Date: Wed, 23 Feb 2011 11:07:59 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 02/10] MIPS: Octeon: Add device tree source files.
Message-ID: <20110223000759.GA26300@yookeroo>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
	ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
	grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
References: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com>
 <1298408274-20856-3-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298408274-20856-3-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 12:57:46PM -0800, David Daney wrote:
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> ---
>  arch/mips/cavium-octeon/.gitignore      |    2 +
>  arch/mips/cavium-octeon/Makefile        |   13 ++
>  arch/mips/cavium-octeon/octeon_3xxx.dts |  314 +++++++++++++++++++++++++++++++
>  arch/mips/cavium-octeon/octeon_68xx.dts |   99 ++++++++++
>  4 files changed, 428 insertions(+), 0 deletions(-)
>  create mode 100644 arch/mips/cavium-octeon/.gitignore
>  create mode 100644 arch/mips/cavium-octeon/octeon_3xxx.dts
>  create mode 100644 arch/mips/cavium-octeon/octeon_68xx.dts
> 
> diff --git a/arch/mips/cavium-octeon/.gitignore b/arch/mips/cavium-octeon/.gitignore
> new file mode 100644
> index 0000000..39c9686
> --- /dev/null
> +++ b/arch/mips/cavium-octeon/.gitignore
> @@ -0,0 +1,2 @@
> +*.dtb.S

.dtb.S?

[snip]
> +/dts-v1/;
> +/* OCTEON 3XXX, 5XXX, 63XX device tree skeleton. */
> +/ {
> +  model = "OCTEON";

1 tab indents are the usual convention for device trees.

> +  compatible = "octeon,octeon";

There's no model number at all for this board?

> +  #address-cells = <2>;
> +  #size-cells = <2>;
> +
> +  soc@0 {
> +    device_type = "soc";

Drop this device_type.

> +    compatible = "simple-bus";
> +    #address-cells = <2>;
> +    #size-cells = <2>;
> +    ranges; /* Direct mapping */
> +
> +    ciu: ciu-3xxx@1070000000000 {
> +      compatible = "octeon,ciu-3xxx";

So, names or compatible values with "wildcards" like 3xxx should be
avoided.  Instead, use the specific model number of this device, then
future devices can claim compatibility with the earlier one.

But, in addition the generic names convention means that the node name
should be "interrupt-controller" rather than something model specific.

> +      interrupt-controller;
> +      #address-cells = <0>;
> +      #interrupt-cells = <2>;
> +      reg = <0x10700 0x00000000 0x0 0x7000>;
> +    };
> +
> +    /* SMI0 */
> +    mdio0: mdio@1180000001800 {

If SMI0 is the name generally used in the documentation, using that in
the label instead of mdio0 might be more useful.

> +      compatible = "octeon,mdio";

No model or revision number?

> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      reg = <0x11800 0x00001800 0x0 0x40>;
> +      device_type = "mdio";

Drop this device_type.

> +
> +      phy0: ethernet-phy@0 {
> +	reg = <0>;
> +      };
> +
> +      phy1: ethernet-phy@1 {
> +	reg = <1>;
> +      };
> +
> +      phy2: ethernet-phy@2 {
> +	reg = <2>;
> +	marvell,reg-init = <3 0x10 0 0x5777>,
> +			   <3 0x11 0 0x00aa>,
> +                           <3 0x12 0 0x4105>,
> +                           <3 0x13 0 0x0a60>;
> +      };
> +      phy3: ethernet-phy@3 {
> +	reg = <3>;
> +	marvell,reg-init = <3 0x10 0 0x5777>,
> +			   <3 0x11 0 0x00aa>,
> +                           <3 0x12 0 0x4105>,
> +                           <3 0x13 0 0x0a60>;
> +      };
> +      phy4: ethernet-phy@4 {
> +	reg = <4>;
> +	marvell,reg-init = <3 0x10 0 0x5777>,
> +			   <3 0x11 0 0x00aa>,
> +                           <3 0x12 0 0x4105>,
> +                           <3 0x13 0 0x0a60>;
> +      };
> +      phy5: ethernet-phy@5 {
> +	reg = <5>;
> +	marvell,reg-init = <3 0x10 0 0x5777>,
> +			   <3 0x11 0 0x00aa>,
> +                           <3 0x12 0 0x4105>,
> +                           <3 0x13 0 0x0a60>;
> +      };
> +
> +      phy6: ethernet-phy@6 {
> +	reg = <6>;
> +	marvell,reg-init = <3 0x10 0 0x5777>,
> +			   <3 0x11 0 0x00aa>,
> +                           <3 0x12 0 0x4105>,
> +                           <3 0x13 0 0x0a60>;
> +      };
> +      phy7: ethernet-phy@7 {
> +	reg = <7>;
> +	marvell,reg-init = <3 0x10 0 0x5777>,
> +			   <3 0x11 0 0x00aa>,
> +                           <3 0x12 0 0x4105>,
> +                           <3 0x13 0 0x0a60>;
> +      };
> +      phy8: ethernet-phy@8 {
> +	reg = <8>;
> +	marvell,reg-init = <3 0x10 0 0x5777>,
> +			   <3 0x11 0 0x00aa>,
> +                           <3 0x12 0 0x4105>,
> +                           <3 0x13 0 0x0a60>;
> +      };
> +      phy9: ethernet-phy@9 {
> +	reg = <9>;
> +	marvell,reg-init = <3 0x10 0 0x5777>,
> +			   <3 0x11 0 0x00aa>,
> +                           <3 0x12 0 0x4105>,
> +                           <3 0x13 0 0x0a60>;
> +      };
> +    };
> +
> +    /* SMI1 */
> +    mdio1: mdio@1180000001900 {
> +      compatible = "octeon,mdio";
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      reg = <0x11800 0x00001900 0x0 0x40>;
> +      device_type = "mdio";
> +    };
> +
> +    mgmt0: ethernet@1070000100000 {
> +      compatible = "octeon,mgmt";
> +      device_type = "network";
> +      model = "mgmt";
> +      reg = <0x10700 0x00100000 0x0 0x100>, /* MIX */
> +            <0x11800 0xE0000000 0x0 0x300>, /* AGL */
> +            <0x11800 0xE0000400 0x0 0x400>, /* AGL_SHARED  */
> +            <0x11800 0xE0002000 0x0 0x8>;   /* AGL_PRT_CTL */
> +      unit-number = <0>;

What is this 'unit-number' property for?

> +      interrupt-parent = <&ciu>;
> +      interrupts = <0 62>, <1 46>;
> +      local-mac-address = [ 00 00 00 00 00 00 ];

That's not a valid MAC address of course.  If this has to be patched
in by the bootloader / later processing, you should add a comment to
that effect.

> +      phy-handle = <&phy0>;
> +    };
> +
> +    mgmt1: ethernet@1070000100800 {
> +      compatible = "octeon,mgmt";
> +      device_type = "network";
> +      model = "mgmt";
> +      reg = <0x10700 0x00100800 0x0 0x100>, /* MIX */
> +            <0x11800 0xE0000800 0x0 0x300>, /* AGL */
> +            <0x11800 0xE0000400 0x0 0x400>, /* AGL_SHARED  */
> +            <0x11800 0xE0002008 0x0 0x8>;   /* AGL_PRT_CTL */
> +      unit-number = <1>;
> +      interrupt-parent = <&ciu>;
> +      interrupts = <1 18>, < 1 46>;
> +      local-mac-address = [ 00 00 00 00 00 00 ];
> +      phy-handle = <&phy1>;
> +    };
> +
> +    pip: pip@11800a0000000 {
> +      compatible = "octeon,pip";
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      reg = <0x11800 0xa0000000 0x0 0x2000>;
> +
> +      interface@0 {

These subnodes and subsubnodes should have compatible values too, even
if it's just "octeon,pip-interface" and "octeon,pip-ethernet".

> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        reg = <0>; /* interface */
> +
> +        ethernet@0 {
> +          device_type = "network";
> +          model = "pip";

This model property doesn't look very useful.

[snip]
> +    /* TWSI 0 */
> +    i2c0: i2c@1180000001000 {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      compatible = "octeon,twsi";
> +      reg = <0x11800 0x00001000 0x0 0x200>;
> +      interrupt-parent = <&ciu>;
> +      interrupts = <0 45>;
> +      clock-rate = <100000>;
> +
> +      rtc@68 {
> +        compatible = "dallas,ds1337";
> +        reg = <0x68>;
> +      };
> +    };
> +
> +    /* TWSI 1 */
> +    i2c1: i2c@1180000001200 {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      compatible = "octeon,twsi";
> +      reg = <0x11800 0x00001200 0x0 0x200>;
> +      interrupt-parent = <&ciu>;
> +      interrupts = <0 59>;
> +      clock-rate = <100000>;
> +    };
> +  };

Uh.. where are the CPUs?

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
