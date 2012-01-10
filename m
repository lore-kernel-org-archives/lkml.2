Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab2AJVdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 16:33:44 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:65510 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab2AJVdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 16:33:42 -0500
Date: Tue, 10 Jan 2012 21:33:38 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC v2 4/9] of: add clock providers
Message-ID: <20120110213338.GD3226@page>
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

On Mon, Dec 12, 2011 at 03:02:04PM -0700, Grant Likely wrote:
> Based on work by Ben Herrenschmidt and Jeremy Kerr, this patch adds an
> of_clk_get function to allow platforms to retrieve clock data from the
> device tree.
> 
> Platform register a provider through of_clk_add_provider, which will be
> called when a device references the provider's OF node for a clock
> reference.
[...]
> diff --git a/Documentation/devicetree/bindings/clock/fixed-clock.txt b/Documentation/devicetree/bindings/clock/fixed-clock.txt
> new file mode 100644
> index 0000000..9a75342
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/fixed-clock.txt
> @@ -0,0 +1,21 @@
> +Binding for simple fixed-rate clock sources.
> +
> +This binding uses the common clock binding[1].
> +
> +[1] Documentation/devicetree/bindings/clock/fixed-clock.txt

This appears to reference itself?

> +
> +Required properties:
> +- compatible : shall be "fixed-clock".
> +- #clock-cells : from common clock binding; shall be set to 0.
> +- clock-frequency : frequency of clock in Hz. May be multiple cells.
> +
> +Optional properties:
> +- gpios : From common gpio binding; gpio connection to clock enable pin.

This seems a little odd to me to have in the common binding, but I'm not 
that familiar with too many platforms.

> +- clock-output-names : From common clock binding
> +
> +Example:
> +	clock {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <1000000000>;
> +	};

I wonder if this should have an optional clock consumer with a standard 
name for parenting?  For example, on picoxcell there is a fixed 200MHz 
APB clock that is really a PLL from a 20MHz reference input and I'd like 
to represent that in the clock tree.

I'm about to start trying to get this and Mike's common struct clk 
patches working on picoxcell, and the one thing I'm not understanding at 
the moment is how to handle the tree itself.  Currently I was planning 
on iterating over all clocks and finding a named input clock "ref" or 
"input" perhaps.  This would be fine for picoxcell, but I guess more 
complicated chips may need something else.

Jamie
