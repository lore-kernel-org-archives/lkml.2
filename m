Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab2JaFJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:09:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40407 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab2JaFJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:09:38 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
CC: Pantelis Antoniou <panto@antoniou-consulting.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        "Porter, Matt" <mporter@ti.com>, "Dill, Russ" <russ.dill@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: RE: [PATCH] omap2-clk: Add missing lcdc clock definition
Thread-Topic: [PATCH] omap2-clk: Add missing lcdc clock definition
Thread-Index: AQHNtvYG6t4YD4tdv0iN86NxZoH7IpfS0m0g
Date: Wed, 31 Oct 2012 05:09:31 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EB529E4@DBDE01.ent.ti.com>
References: <1351698962-3923-1-git-send-email-panto@antoniou-consulting.com>
 <20121030181837.GM11908@atomide.com>
 <alpine.DEB.2.00.1210302324530.6152@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1210302324530.6152@utopia.booyaka.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.105]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 04:56:40, Paul Walmsley wrote:
> + Vaibhav Hiremath
> 
> On Tue, 30 Oct 2012, Tony Lindgren wrote:
> 
> > * Pantelis Antoniou <panto@antoniou-consulting.com> [121030 11:04]:
> > > Looks like the lcdc clock definition got dropped.
> > > It is required for the LCD controller to work. Reintroduce.
> > 
> > This looks like a regression, can you also add the commit
> > causing it?
> 
> Looks like probably a new "feature," in that this clock didn't exist in 
> the original check-in.  Would be good to get Vaibhav's opinion on this; 
> also the common clock patches will need to be updated.
> 

Thanks Paul for looping me in, something went wrong with my l-o subscription, 
so I didn't receive these Patches. 

As far as lck clock node is concerned, we had deliberately dropped all leaf-
node clocks from the clock tree, please refer to the description mentioned 
in -
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-May/101987.html


>From LCDC driver perspective, driver is using,

fb_clk = clk_get(&device->dev, NULL);

This I feel needs to be corrected for valid name as per Spec (mostly I would 
vote for "fck") and then every platform should make sure that it returns 
valid clock-node for it.

Change in Driver would be,

fb_clk = clk_get(&device->dev, "fck");


Thanks,
Vaibhav

> 
> - Paul
> 

