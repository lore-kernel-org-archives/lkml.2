Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab1LOQek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:34:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38120 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab1LOQej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:34:39 -0500
Date: Thu, 15 Dec 2011 17:34:31 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
Message-ID: <20111215163431.GV27267@pengutronix.de>
References: <CACRpkdbN26q1_d4tPkJp4f4_KdvoEEk9uCCRyOfEU97DOWAnEw@mail.gmail.com>
 <7FE21149F4667147B645348EC60578850564C5@039-SN2MPN1-013.039d.mgd.msft.net>
 <20111215093319.GO27267@pengutronix.de>
 <20111215112140.GA10522@S2101-09.ap.freescale.net>
 <7FE21149F4667147B645348EC60578850567C3@039-SN2MPN1-013.039d.mgd.msft.net>
 <20111215115300.GB10522@S2101-09.ap.freescale.net>
 <20111215115428.GQ27267@pengutronix.de>
 <20111215121752.GD10522@S2101-09.ap.freescale.net>
 <20111215132336.GR27267@pengutronix.de>
 <20111215140024.GA2963@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215140024.GA2963@S2100-06.ap.freescale.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:33:11 up 33 days, 20 min, 52 users,  load average: 1.41, 2.96,
 4.66
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 10:00:25PM +0800, Shawn Guo wrote:
> On Thu, Dec 15, 2011 at 02:23:36PM +0100, Sascha Hauer wrote:
> > On Thu, Dec 15, 2011 at 08:17:54PM +0800, Shawn Guo wrote:
> > > On Thu, Dec 15, 2011 at 12:54:28PM +0100, Sascha Hauer wrote:
> > > > On Thu, Dec 15, 2011 at 07:53:05PM +0800, Shawn Guo wrote:
> > > > > On Thu, Dec 15, 2011 at 07:28:18PM +0800, Dong Aisheng-B29396 wrote:
> > > > > > > -----Original Message-----
> > > > > > > 
> > > > > > My understanding is that pinmux_get will return an error if no proper pinmux
> > > > > > Found without dummy pinmux. That's a real error.
> > > > > > But with dummy pinmux, if no proper pinmux found, the pinctrl core may check
> > > > > > If dummy pinmux is supported, if supported, it will fakely success with returning
> > > > > > a dummy pinmux. Then real error is hiden.
> > > > > > This is due to for supporting one single image, the dummy pinmux may also be enabled
> > > > > > For platforms like mx6q with real pinmux.
> > > > > > 
> > > > > Got your point.  So your concern is about the fake success when dummy
> > > > > pinmux comes to play rather than 'fake error'.  I'm not concerned about
> > > > > that case much, since we will know the failure with a simple debug/info
> > > > > message in the pinmux core, saying 'I do not find any available pinmux,
> > > > > and I'm falling into the dummy pinmux'.  When you see this message
> > > > > imx6q, you know something goes wrong.
> > > > 
> > > > So i.MX3/5 people must know that it's safe to ignore this message
> > > > whereas i.MX6 people must know there's something wrong Adding messages
> > > > saying "there might or might not be something wrong" is not good.
> > > > People will frequently ask on the mailing list about these messages.
> > > > 
> > > Usually, people checking the serial output and asking question on list
> > > are developers not users.  It's not too hard for developers to figure
> > > out such message.  Or we can making it a debug message, and when some
> > > driver is not working, turn on debug option, you know where it goes
> > > wrong.
> > 
> > So we as developers have to figure out ourselves what can go wrong and
> > the users, well who cares about users?
> > 
> It's really the type of problem that can be discovered and fixed in
> the development phase, isn't it?
> 
> BTW, I did not mean to leave imx3 and imx5 there forever, but mean,
> with the dummy pinmux support, we do not have to strictly migrate imx3,
> imx5 and imx6 all at the same time.

I'm afraid your plans for i.MX3/5 clash with Freescale's i.MX7
release...

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
