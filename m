Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab2KIXGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 18:06:22 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47541 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab2KIXGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 18:06:21 -0500
Message-ID: <509D8C69.7060004@wwwdotorg.org>
Date: Fri, 09 Nov 2012 16:06:17 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices
 to mach-omap2)
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
In-Reply-To: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 01:40 PM, Grant Likely wrote:
> As promised, here is my early draft to try and capture what device
> tree overlays need to do and how to get there. Comments and
> suggestions greatly appreciated.

Here's one other requirement I'd like that I don't think I saw
explicitly mentioned in your document:

Assuming a base file board.dts and a child board file child.dts, the
compiled file child.dtb should be usable with a modified board.dtb
assuming it exports the same set of attachment-points (hashed phandles,
socket objects, whatever). This allows bug-fixes etc. to board.dts
without forcing every child.dts to be recompiled.

If the attachment points is hashed node names or node content from
board.dts, I'm not sure how this is possible?

I suppose this is implicit if child.dtb can be used with either
board-a.dtb and board-b.dtb though.
