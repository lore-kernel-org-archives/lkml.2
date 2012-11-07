Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab2KGLYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 06:24:03 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:55011 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754101Ab2KGLYB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 06:24:01 -0500
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <509A4232.9090709@ti.com>
Date: Wed, 7 Nov 2012 12:23:25 +0100
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        <linux-omap@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <devicetree-discuss@lists.ozlabs.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <4F38B158-14F7-474E-8232-F455177E774C@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com> <CACxGe6vDzmPWsOZ53HTwkYmDEivg9TpnRrvudY2FK95V06O24w@mail.gmail.com> <A5170602-2AE7-4EC4-BE0F-0DF015A287D7@antoniou-consulting.com> <CACxGe6sJXubOSGGg5AmDK6DQMjv60H44nax9wUnnCGsqXGbfxw@mail.gmail.com> <5ED17D42-07B8-4D4F-B54F-82B4CC60584C@antoniou-consulting.com> <509A3595.7050600@ti.com> <A6697FB9-3614-4027-A71B-59C7556005BF@antoniou-consulting.com> <509A4232.9090709@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Nov 7, 2012, at 12:12 PM, Benoit Cousson wrote:

> On 11/07/2012 12:02 PM, Pantelis Antoniou wrote:
>> Hi Benoit,
>> 

[snip]

>> I don't know if this breaks any conventions but seems to work fine for our case.
> 
> Yeah, my main concern with that approach is that you change the
> structure of the tree by adding an extra node/hierarchy that will not be
> there in case of non-versioned tree.
> That's why I think we should have something lighter that will not change
> the structure.
> Ideally we should be able to add extra versioned node to the original
> dts without changing it at all.
> 

You will still need the versioned nodes to be injected to the non-versioned
ones. FWIW the driver will use the standard of_property_read_* interface.

You can patch of_property_read to hide the version node matching, and it will
work.

I'll leave Grant answer what approach is better, I don't claim to have the insight
to handle all cases.

>>> Maybe some extra version match table can just be passed during the board machine_init 
>>> 
>>> 	of_platform_populate(NULL, omap_dt_match_table, NULL, NULL, panda_version_match_table);
>>> 
>> 
>> Would we need explicit of_platform_populate calls if we have node modification notifiers?
>> In that case the notifier would pick it up automatically, and can do the per
>> version matching internally.
> 
> Yes indeed, but here I was thinking about an intermediate step, i.e.
> now, without any dynamic node insertion mechanism.
> Thanks to this simple approach, when can already fix the board
> versionning problem.
> 

As I pointed, with a kind of injection mechanism. the versioned node contents end up in
the proper place in the device tree.
Your method will work in a much more simpler way.

> Regards,
> Benoit
> 

Regards

-- Pantelis


