Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab2KMFWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 00:22:11 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48449 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab2KMFWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 00:22:09 -0500
Message-ID: <50A1D8FF.7060104@wwwdotorg.org>
Date: Mon, 12 Nov 2012 22:22:07 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: David Gibson <david@gibson.dropbear.id.au>
CC: Grant Likely <grant.likely@secretlab.ca>, Kevin Hilman <khilman@ti.com>,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Scott Wood <scottwood@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices
 to mach-omap2)
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <20121109022624.GI23553@truffula.fritz.box> <CACxGe6vQ50aS0Fe7QvTHKfV=EDpsZoLC7SOxXLGc0pkMvyk5DQ@mail.gmail.com> <20121113010505.GR4696@truffula.fritz.box>
In-Reply-To: <20121113010505.GR4696@truffula.fritz.box>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 06:05 PM, David Gibson wrote:
> On Fri, Nov 09, 2012 at 09:42:37PM +0000, Grant Likely wrote:
...
> 2) graft bundle
> 
> The base tree has something like this:
> 
> 	...
> 	i2c@XXX {
> 		...
> 		cape-socket {
> 			compatible = "vendor,cape-socket";
> 			id = "Socket-A";
> 			piece-id = "i2c";
> 			ranges = < ... >;
> 		};
> 	};
> 	...
> 	spi@YYY {
> 		...
> 		cape-socket {
> 			compatible = "vendor,cape-socket";
> 			id = "Socket-A";
> 			piece-id = "spi";
> 			ranges = < ... >;
> 		};
> 	};
> 	...
> 	cape-socket {
> 		compatible = "vendor,cape-socket";
> 		id = "Socket-A";
> 		piece-id = "misc";
> 		interrupt-map = < ... >;
> 		interrupt-map-mask = < ... >;
> 		gpio-map = < ... >;
> 		gpio-map-mask = < ... >;
> 	};
> 
> Then instead of grafting a single subtree for the socket, we install a
> "bundle" of subtrees, one each for each of the pieces within the
> socket.  That bundle could either be an actual set of multiple fdts,
> or they could be placed into one fdt with a dummy root node, something like:
>
> 	/ {
> 		plugin-bundle;
> 		compatible = "vendor,cape-plugin";
> 		version = ...;
> 		i2c-piece = {
> 			piece-id = "i2c";
> 			...
> 		};
> 		misc-piece = {
> 			piece-id = "misc";
> 			...
> 		};
> 	};

I do like this approach; it's the kind of thing I proposed at:

> http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg20414.html

One question though: Perhaps the base board has two instances of the
same type of connector vendor,cape-socket, allowing 2 independent capes
to be plugged in. When overlaying/grafting the child board's .dts, we'd
need some way to specify the socket ID that was being plugged into. Is
that the intent of the "id" property in your base board example above?
