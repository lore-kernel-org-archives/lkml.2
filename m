Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab2KMSKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:10:32 -0500
Received: from rs130.luxsci.com ([72.32.115.17]:48744 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab2KMSKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:10:31 -0500
Message-ID: <50A28D03.7050002@firmworks.com>
Date: Tue, 13 Nov 2012 08:10:11 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: David Gibson <david@gibson.dropbear.id.au>, Kevin Hilman <khilman@ti.com>,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Russ Dill <Russ.Dill@ti.com>, Scott Wood <scottwood@freescale.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices
 to mach-omap2)
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <50999145.2070306@wwwdotorg.org> <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com> <509D9089.7020407@wwwdotorg.org> <5B124797-6DFD-4C5E-90D7-665AFD4A7873@antoniou-consulting.com> <50A12950.6090808@wwwdotorg.org> <20121113072517.GE25915@truffula.fritz.box> <50A27BF1.4030502@wwwdotorg.org>
In-Reply-To: <50A27BF1.4030502@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Lux-Comment: Message qADIAD4b019552 sent by user #11875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems to me that this capebus discussion is missing an important
point.  The name capebus suggests that it is a bus, so there should be a
parent node to represent that bus.  It should have a driver whose API
implements all of the system-interface functions a cape needs.

If you look at the way that interrupt specifiers work, the default case
is that a child device implicitly delegates the mapping to its parent.
The use of phandles to break out of the tree structure was intended for
use within the "hardwired motherboard domain", not for plug-in devices.

The "new" phandle-based GPIO and clock mechanisms don't have that
parent-delegation feature, but they should, because hierarchical
hardware is a good thing when it exists.  One fix would be to designate
a reserved phandle value - for example 0 or -1 - to mean "my parent". t
The parent node would contain some translator to resolve the actual
target node, similarly to interrupts and addresses.

If done correctly, capebus "overlays" would then just be proper child
nodes of the capebus bus node and there would no need to refer to
"global" information like non-parent phandles.

If something about the design of capebus makes that impossible, I
respectfully suggest that its design should be reviewed, taking into
account the many years of industry experience about modularity.

Mitch
