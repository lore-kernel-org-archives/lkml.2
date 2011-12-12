Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1LLX3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:29:12 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63765 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab1LLX3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:29:07 -0500
Date: Mon, 12 Dec 2011 23:29:03 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC v2 4/9] of: add clock providers
Message-ID: <20111212232903.GC2616@gallagher>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
 <1323727329-4989-4-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323727329-4989-4-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

I'm still going through these and trying to digest them but a couple of 
quick questions/comments.

Jamie

On Mon, Dec 12, 2011 at 03:02:04PM -0700, Grant Likely wrote:
> diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> new file mode 100644
> index 0000000..e40c436
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> @@ -0,0 +1,114 @@
> +This binding is a work-in-progress, and are based on some experimental
> +work by benh[1].
> +
> +Sources of clock signal can be represented by any node in the device
> +tree.  Those nodes are designated as clock providers.  Clock consumer
> +nodes use a phandle and clock specifier pair to connect clock provider
> +outputs to clock inputs.  Similar to the gpio specifiers, a clock
> +specifier is an array of one more more cells identifying the clock
> +output on a device.  The length of a clock specifier is defined by the
> +value of a #clock-cells property in the clock provider node.
> +
> +[1] http://patchwork.ozlabs.org/patch/31551/
> +
> +==Clock providers==
> +
> +Required properties:
> +#clock-cells:	   Number of cells in a clock specifier; typically will be
> +		   set to 1

I'm not sure I fully understand what the extra cells actually mean for 
clocks.  I think the first integer is the clock output to use but some 
of the versatile and highbank ones only have a phandle or is it more 
implementation defined?  The clock-output-names description hints at 
recommended, so I find this a little confusing, but that could just be 
me!

> +Optional properties:
> +clock-output-names: Recommended to be a list of strings of clock output signal
> +		    names indexed by the first cell in the clock specifier.
> +		    However, the meaning of clock-output-name is domain
> +		    specific to the clock provider, and is only provided to
> +		    encourage using the same meaning for the majority of clock
> +		    providers.  This format may not work for clock providers
> +		    using a complex clock specifier format.  In those cases it
> +		    is recommended to omit this property and create a binding
> +		    specific names property.
> +
> +		   Clock consumer nodes must never directly reference
> +		   the provider's clock-output-name property.
> +
> +For example:
> +
> +    oscillator {
> +        #clock-cells = <1>;
> +        clock-output-names = "ckil", "ckih";
> +    };
> +
> +- this node defines a device with two clock outputs, the first named
> +  "ckil" and the second named "ckih".  Consumer nodes always reference
> +  clocks by index. The names should reflect the clock output signal
> +  names for the device.
> +
> +==Clock consumers==
> +
> +Required properties:
> +clocks:		List of phandle and clock specifier pairs, one pair
> +		for each clock input to the device.

Some of the highbank and versatile devicetree nodes have clocks 
properties that aren't a pair e.g. versatile timer has
"clocks = <&tim_clk>;".  

> +clock-names:	List of clock input name strings sorted in the same
> +		order as the clocks property.  Consumers drivers
> +		will use clock-names to match clock input names
> +		with clocks specifiers.

The versatile and highbank patches appears to omit this required 
property in several nodes.  So is this really optional?

Jamie
