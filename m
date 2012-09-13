Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab2IMHvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:51:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42502 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab2IMHvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:51:01 -0400
Date: Thu, 13 Sep 2012 09:50:37 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, Alex Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
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
Message-ID: <20120913075037.GG6180@pengutronix.de>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
 <1464760.6eqxJ2IzZ2@percival>
 <1347517377.7471.23.camel@lappyti>
 <2689722.93BQTh4lSC@percival>
 <1347519249.7471.42.camel@lappyti>
 <20120913070012.GC6180@pengutronix.de>
 <1347519807.7471.45.camel@lappyti>
 <20120913072920.GA11459@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913072920.GA11459@avionic-0098.mockup.avionic-design.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:45:00 up 81 days, 22:56, 70 users,  load average: 1.11, 1.08,
 0.91
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 09:29:20AM +0200, Thierry Reding wrote:
> On Thu, Sep 13, 2012 at 10:03:27AM +0300, Tomi Valkeinen wrote:
> > On Thu, 2012-09-13 at 09:00 +0200, Sascha Hauer wrote:
> > > On Thu, Sep 13, 2012 at 09:54:09AM +0300, Tomi Valkeinen wrote:
> > > > On Thu, 2012-09-13 at 15:36 +0900, Alex Courbot wrote:
> > > > > On Thursday 13 September 2012 14:22:57 Tomi Valkeinen wrote:
> > > > >  
> > > > > > However, I fear these board specific things may be quite a bit anything,
> > > > > > so it may well be pwm, gpios and regulators are not enough for them. For
> > > > > > example, there could be an FPGA on the board which requires some
> > > > > > configuration to accomplish the task at hand. It could be rather
> > > > > > difficult to handle it with a generic power sequence.
> > > > > 
> > > > > Right. Note that this framework is supposed to be extended - I would like to 
> > > > > at least add regulator voltage setting, and maybe even support for clocks and 
> > > > > pinmux (but that might be out of place).
> > > > 
> > > > Yes, that's one concern of mine... I already can imagine someone
> > > > suggesting adding conditionals to the power sequence data. Perhaps also
> > > > direct memory read/writes so you can twiddle registers directly. And so
> > > > on. Where's the limit what it should contain? Can we soon write full
> > > > drivers with the DT data? =)
> > > 
> > > I have this concern aswell, that's why I'm sceptical about this patch
> > > set. But what are the alternatives? Adding power code to the drivers and
> > > thus adding board specific code to them is backwards.
> > 
> > As was pointed out in earlier posts in this thread, these are almost
> > always device specific, not board specific.
> > 
> > Do you have examples of board specific power sequences or such?
> 
> It is true that most (perhaps all) power sequences can be associated
> with a specific device, but if we go and implement drivers for these
> kinds of devices we will probably end up with loads of variations of
> the same scheme.
> 
> Lets take display panels as an example. One of the devices that we build
> has gone through two generations so far and both are slightly different
> in how they control the panel backlight: one has an external backlight
> controller, the other has the display controller built into the panel.
> However, from the board's perspective the control of the backlight
> doesn't change, because both devices get the same inputs (an enable pin
> and a PWM) that map to the same pins on the SoC.
> 
> This may not be a very good example because the timing isn't relevant,
> but the basic point is still valid: if we provide a driver for both
> panel devices, the code will be exactly the same. So we end up having to
> refactor to avoid code duplication and use the same driver for a number
> of backlight/panel combinations. Which in itself isn't very bad, but it
> also means that we'll probably get to see a large number of "generic"
> drivers which aren't very generic after all.
> 
> Another problem, which also applies to the case of power-sequences, is
> that often the panel and backlight are not the same device.

Maybe that is the problem that needs to be addressed? They *are* not the
same device, still they are handled in a single platform callback (or
now power sequence). Maybe the amount of combinations dastrically go
down if we really make them two devices.

Most of our panels have:

- A regulator (or gpio) for turning them on

And the backlights have:

- A regulator (or gpio) for turning them on
- A PWM for controlling brightness.

The power sequence for the above is clear: Turn on the panel the panel,
wait until it stabilized and afterwards turn on the backlight.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
