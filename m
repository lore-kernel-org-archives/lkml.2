Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab2ICIZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:25:25 -0400
Received: from [213.199.154.139] ([213.199.154.139]:6340 "EHLO
	db3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755585Ab2ICIZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:25:21 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1202h1082kzzz2dh2a8h668h839h944hd25hf0ah107ah1220h1155h)
Date: Mon, 3 Sep 2012 16:02:00 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Zhao Richard-B20223 <B20223@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
Subject: Re: [PATCH v4 1/7] mfd: add syscon driver based on regmap
Message-ID: <20120903080159.GA1740@shlinux2.ap.freescale.net>
References: <1346237818-9498-1-git-send-email-b29396@freescale.com>
 <1346237818-9498-2-git-send-email-b29396@freescale.com>
 <20120831012626.GA7726@r65073-Latitude-D630>
 <20120903023102.GA11891@shlinux2.ap.freescale.net>
 <20120903030858.GF2362@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120903030858.GF2362@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 11:09:01AM +0800, Shawn Guo wrote:
> On Mon, Sep 03, 2012 at 10:31:03AM +0800, Dong Aisheng wrote:
> > > 
> > > I think of_node_put should be moved out from here and put into
> > > syscon_node_to_regmap and syscon_regmap_lookup_by_compatible.
> > > 
> > I guess no, if you want to move of_node_put into syscon_regmap_lookup_by_phandle,
> > then syscon_regmap_lookup_by_phandle has the same issue.
> 
> I guess not.  syscon_regmap_lookup_by_phandle itself calls of_parse_phandle,
> and that's where the refcount gets incremented, so syscon_regmap_lookup_by_phandle
> should be responsible for calling of_node_put to get the refcount decremented.
> 
Yes, the of_node_put will be done in syscon_node_to_regmap which is called by
syscon_regmap_lookup_by_phandle,
The reason why we do it is as i said in my last reply.

I think one known issue is that syscon_node_to_regmap may not be suitable to
be used by the driver who still wants to use the regmap node after calling the
syscon_node_to_regmap.
I still do not find such using case but i'm not sure whether it may exist.

Probably the safe way currently to do is just as you said:
Not put the node in syscon_node_to_regmap and let user decide.
Ok, i will update it.

Regards
Dong Aisheng

