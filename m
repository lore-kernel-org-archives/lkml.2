Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab3AHLPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:15:23 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53009 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab3AHLPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:15:20 -0500
Date: Tue, 8 Jan 2013 12:14:49 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/5] capemgr: Beaglebone DT overlay based cape manager
Message-ID: <20130108111449.GN1906@pengutronix.de>
References: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com>
 <93BF5C62-ADE8-4EFC-9175-C2D7E43300E3@antoniou-consulting.com>
 <20130107210551.GL14149@atomide.com>
 <201301072135.05166.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301072135.05166.arnd@arndb.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:26:18 up 199 days, 37 min, 47 users,  load average: 1.13, 1.01,
 2.27
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 09:35:04PM +0000, Arnd Bergmann wrote:
> (Adding Sascha Hauer, Linus Walleij, Lee Jones to Cc)
> 
> On Monday 07 January 2013, Tony Lindgren wrote:
> > > 
> > > At the end of the line, some kind of hardware glue is going to be needed.
> > > 
> > > I just feel that drawing from a sample size of 1 (maybe 2 if I get to throw
> > > in the beagleboard), it is a bit premature to think about making it overly
> > > general, besides the part that are obviously part of the infrastructure 
> > > (like the DT overlay stuff).
> > > 
> > > What I'm getting at, is that we need some user experience about this, before
> > > going away and creating structure out of possible misconception about the uses. 
> > 
> > IMHO stuff like this will be needed by many SoCs. Some examples of similar
> > things for omaps that have eventually become generic frameworks have been
> > the clock framework, USB OTG support, runtime PM, pinmux framework and
> > so on.
> > 
> > So I suggest a minimal generic API from the start as that will make things
> > a lot easier in the long run.
> 
> I agree. The ux500 platform already has the concept of "user interface boards",
> which currently is not well integrated into devicetree. I believe Sascha
> mentioned that Pengutronix had been shipping some other systems with add-on
> boards and generating device tree binaries from source for each combination.

What we have is usually CPU modules which can have different base
boards. Usually they are not detectable by software. Right now we
normally use a baseboard dts which includes a board dtd which then
includes the SoC dtsi. This works quite well on dtc level.

For us overlay dts become interesting when it comes to all the little
variants of the boards, like for example different displays, different
touchscreens,...

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
