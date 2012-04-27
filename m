Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab2D0HkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 03:40:16 -0400
Received: from 7.mo4.mail-out.ovh.net ([178.33.253.54]:35854 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752029Ab2D0HkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 03:40:14 -0400
Date: Fri, 27 Apr 2012 09:11:04 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Dong Aisheng <b29396@freescale.com>, b20223@freescale.com,
        linus.walleij@stericsson.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        kernel@pengutronix.de, cjb@laptop.org, s.hauer@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH v3 2/4] pinctrl: pinctrl-imx: add imx pinctrl core
 driver
Message-ID: <20120427071104.GS9142@game.jcrosoft.org>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <1335451227-27709-2-git-send-email-b29396@freescale.com>
 <20120426144446.GN9142@game.jcrosoft.org>
 <20120426151536.GO9142@game.jcrosoft.org>
 <20120427054842.GJ2234@S2101-09.ap.freescale.net>
 <20120427062816.GQ9142@game.jcrosoft.org>
 <20120427072503.GP2234@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427072503.GP2234@S2101-09.ap.freescale.net>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 5425148703228406742
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeggedrtdekucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeggedrtdekucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:25 Fri 27 Apr     , Shawn Guo wrote:
> On Fri, Apr 27, 2012 at 08:28:16AM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > On 13:48 Fri 27 Apr     , Shawn Guo wrote:
> > > On Thu, Apr 26, 2012 at 05:15:36PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > > > We have on Imx mxc at91 and other SoC controler hich you configure per pin
> > > > 
> > > > which means one pin have multiple function and the same function is on
> > > > multiple pins
> > > > 
> > > > so the groups are just a list of possible pins
> > > > 
> > > > Instead of re-inventing bindings we do need to come with a common binding whre
> > > > it's possible
> > > > 
> > > > So instead I proppose (send in the v2) to use common way to describe the group
> > > > 
> > > Let's see how many nodes we will have in device tree.  For imx6q
> > > example, there are 332 pins and each pin has up to 8 function selects.
> > > We will end up with having 332 x 8 = 2656 sub nodes under node
> > > "functions".  Device tree simply cannot afford such a bloating.
> > device tree can offord it
> > 
> No.  Device tree maintainers has told that.  Looking into the clock DT
> binding discussion, you will find that Grant does not like to have
> even 100~200 nodes to represent an entire clock tree in the DT.
> 
> With your proposal (actually this has been proposed long time before),
> to represent the pins for a 24bit display, it easily consumes 28 nodes
> on mach-mxs, while my binding only needs one node.  So in short, the
> proposal has been discussed and it's not a sensible one.
except duplicate bindings instead having common one make no sense either

so imx, at91 and ST (STB SoC and other does have the same type of pin IP

to not come with a common bindig means we are doint the same crap as before

with switch to DT

Best Regards,
J.
