Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab1JXIvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 04:51:36 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:15841
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753751Ab1JXIve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 04:51:34 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz9371K1432N98dKzz1202hzzz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
Date: Mon, 24 Oct 2011 17:02:29 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Rajendra Nayak <rnayak@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <patches@linaro.org>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <lrg@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111024090228.GA1755@S2100-06.ap.freescale.net>
References: <4E9EB61C.1040207@ti.com>
 <20111019144215.GA32007@S2100-06.ap.freescale.net>
 <4E9FAF42.5060200@ti.com>
 <20111020061408.GE32007@S2100-06.ap.freescale.net>
 <4EA00F7C.1080005@ti.com>
 <20111021082309.GA337@S2100-06.ap.freescale.net>
 <4EA13053.7080306@ti.com>
 <20111021115809.GB337@S2100-06.ap.freescale.net>
 <4EA4FF6B.2080906@ti.com>
 <20111024081706.GC8708@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111024081706.GC8708@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 10:17:06AM +0200, Grant Likely wrote:
> On Mon, Oct 24, 2011 at 11:32:19AM +0530, Rajendra Nayak wrote:
> > On Friday 21 October 2011 05:28 PM, Shawn Guo wrote:
> > >On Fri, Oct 21, 2011 at 02:11:55PM +0530, Rajendra Nayak wrote:
> > >[...]
> > >>>+       /* find device_node and attach it */
> > >>>+       rdev->dev.of_node = of_find_node_by_name(NULL, regulator_desc->name);
> > >>
> > >>so would this do a complete dt search for every regulator?
> > >
> > >Yes, with the first param being NULL, tthe entire device tree will be
> > >searched.
> > >
> > >>we would also need the driver names and dt names to match for this to
> > >>work, right?
> > >>
> > >Driver name does not matter.  The key for this search to work is having
> > >regulator's name (regulator_desc->name) match device tree node's name,
> > >case ignored.
> > 
> > Mark, whats your take on this? I am somehow not quite sure if we should
> > have this limitation put in to match DT node names with whats in the
> > driver structs (regulator_desc).
> 
> This looks wrong to me.  Matching based on node /name/, particularly
> when searching the entire tree, will cause problems.
> 
Okay, it's wrong then since so many people say it's wrong :)  I guess
a quick fix would be adding one property in device tree node for
matching some unique field in regulator_desc, id, maybe?  Mark, any
suggestion?

-- 
Regards,
Shawn

