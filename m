Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab2IMHSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:18:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36001 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab2IMHSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:18:46 -0400
Date: Thu, 13 Sep 2012 09:18:29 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Alex Courbot <acourbot@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v6 1/4] Runtime Interpreted Power Sequences
Message-ID: <20120913071829.GE6180@pengutronix.de>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
 <1464760.6eqxJ2IzZ2@percival>
 <1347517377.7471.23.camel@lappyti>
 <2689722.93BQTh4lSC@percival>
 <1347519249.7471.42.camel@lappyti>
 <20120913070012.GC6180@pengutronix.de>
 <1347519807.7471.45.camel@lappyti>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347519807.7471.45.camel@lappyti>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:13:06 up 81 days, 22:24, 62 users,  load average: 0.59, 0.77,
 0.66
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 10:03:27AM +0300, Tomi Valkeinen wrote:
> On Thu, 2012-09-13 at 09:00 +0200, Sascha Hauer wrote:
> > On Thu, Sep 13, 2012 at 09:54:09AM +0300, Tomi Valkeinen wrote:
> > > On Thu, 2012-09-13 at 15:36 +0900, Alex Courbot wrote:
> > > > On Thursday 13 September 2012 14:22:57 Tomi Valkeinen wrote:
> > > >  
> > > > > However, I fear these board specific things may be quite a bit anything,
> > > > > so it may well be pwm, gpios and regulators are not enough for them. For
> > > > > example, there could be an FPGA on the board which requires some
> > > > > configuration to accomplish the task at hand. It could be rather
> > > > > difficult to handle it with a generic power sequence.
> > > > 
> > > > Right. Note that this framework is supposed to be extended - I would like to 
> > > > at least add regulator voltage setting, and maybe even support for clocks and 
> > > > pinmux (but that might be out of place).
> > > 
> > > Yes, that's one concern of mine... I already can imagine someone
> > > suggesting adding conditionals to the power sequence data. Perhaps also
> > > direct memory read/writes so you can twiddle registers directly.

These memory writes can be avoided when these registers are abstracted
as a regular gpio/regulator/pwm driver.

> > > And so
> > > on. Where's the limit what it should contain? Can we soon write full
> > > drivers with the DT data? =)
> > 
> > I have this concern aswell, that's why I'm sceptical about this patch
> > set. But what are the alternatives? Adding power code to the drivers and
> > thus adding board specific code to them is backwards.
> 
> As was pointed out in earlier posts in this thread, these are almost
> always device specific, not board specific.
> 
> Do you have examples of board specific power sequences or such?

Sure, tons of. One board needs a gpio to be set high to enable backlight,
the next one to low, a regulator has to be enabled, and to avoid
flickering a certain timing has to be ensured. This is all highly board
specific.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
