Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2KIXOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 18:14:33 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:57160 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab2KIXOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 18:14:30 -0500
Message-ID: <509D8E52.1010505@wwwdotorg.org>
Date: Fri, 09 Nov 2012 16:14:26 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
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
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <20121109022624.GI23553@truffula.fritz.box>
In-Reply-To: <20121109022624.GI23553@truffula.fritz.box>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 07:26 PM, David Gibson wrote:
...
> So, let me take a stab at this from a more bottom-up approach, and see
> if we meet in the middle somewhere.  As I discussed in the other
> thread with Daniel Mack, I can see two different operationso on the
> fdt that might be useful in this context.  I think of them as "graft"
> - which takes one fdt and adds it as a new subtree to an existing fdt
> - and "overlay" where a new fdt adds or overrides arbitrary properties
> in an existing tree.  Overlay is more or less what we do at the source
> level in dtc already.

One more thought on the differences between overlay and grafting:

With overlay, it's possible to make your overlay a complete DT tree
rooted at /. In some cases, you might find a lower-level node which all
overlaid elements share, and root the overlay process there.

With grafting, you're basically guaranteed to want the child/graft file
to have different parts of itself grafted into different points in the
parent/underlying tree, e.g. to add nodes to an I2C bus, an SPI bus, and
perhaps some bus-less devices at the root (e.g. a new gpio-leds device).
This will require that a child/graft file to consist of multiple chunks
of DT all to be grafted as separate operations, whereas with overlay you
may be able to get away with a single chunk to be overlaid (although
with some of the use-cases discussed, even the overlay approach might
require multiple chunks to be applied).
