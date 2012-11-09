Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab2KIXce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 18:32:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54500 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2KIXcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 18:32:31 -0500
MIME-Version: 1.0
In-Reply-To: <509D8C69.7060004@wwwdotorg.org>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <509D8C69.7060004@wwwdotorg.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 9 Nov 2012 23:32:10 +0000
X-Google-Sender-Auth: 8hyiXmOQCcifb4spt3ix_BmCo5Y
Message-ID: <CACxGe6vAqO-JFAVssYyZ8MXtgp=yVDW8aKw_jB4Uz4bHtBJz=A@mail.gmail.com>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 11:06 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/05/2012 01:40 PM, Grant Likely wrote:
>> As promised, here is my early draft to try and capture what device
>> tree overlays need to do and how to get there. Comments and
>> suggestions greatly appreciated.
>
> Here's one other requirement I'd like that I don't think I saw
> explicitly mentioned in your document:
>
> Assuming a base file board.dts and a child board file child.dts, the
> compiled file child.dtb should be usable with a modified board.dtb
> assuming it exports the same set of attachment-points (hashed phandles,
> socket objects, whatever). This allows bug-fixes etc. to board.dts
> without forcing every child.dts to be recompiled.

No, I hadn't explicitly captured that one, but yes it is the intent.

> If the attachment points is hashed node names or node content from
> board.dts, I'm not sure how this is possible?

Ummm, I think there is misunderstanding about the hashed phandles. My
thought is merely that using a hash to generate a phandle is 'better'
than starting at 1 and counting upwards when dtc compiles the tree.
That way, if the path to the node has not changed, then the phandle
will not have changed.

However, phandles can still be explicitly specified if slightly
different trees need to have the same target point.

That said, if portability of dtb files is a strong requirement, then
it will be difficult to do with simple overlays. Even if the phandles
line up, the irq/gpio specifiers probably need to be different. That
makes things harder.

g.
