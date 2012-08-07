Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368Ab2HGGgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 02:36:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39371 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2HGGgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 02:36:07 -0400
Date: Tue, 7 Aug 2012 08:35:58 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Matt Sealey <matt@genesi-usa.com>,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 4/9] ASoC: imx: Don't use {en,dis}able_fiq() calls
Message-ID: <20120807063558.GE1451@pengutronix.de>
References: <20120805230238.GA1663@lizard>
 <1344207819-3415-4-git-send-email-anton.vorontsov@linaro.org>
 <CAKGA1bkiHj=zMJXSzoGp3fpLS3POnFXSV5y7sYYFAikqoUT9tQ@mail.gmail.com>
 <20120806154951.GQ16861@opensource.wolfsonmicro.com>
 <CAKGA1b=_AOub_pEJJGBTb6Y7wLZaSYKQjFTyMVFSr_=9VX4wpg@mail.gmail.com>
 <20120806193734.GA16199@opensource.wolfsonmicro.com>
 <20120806201609.GX25644@pengutronix.de>
 <CAKGA1bmMqyL4gyLYcanEH=R=HuBjRCNRLjUEWCj8wmpi3HuL0g@mail.gmail.com>
 <20120806214121.GA26698@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120806214121.GA26698@opensource.wolfsonmicro.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:29:03 up 44 days, 21:40, 31 users,  load average: 0.02, 0.07,
 0.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 10:41:22PM +0100, Mark Brown wrote:
> On Mon, Aug 06, 2012 at 03:39:50PM -0500, Matt Sealey wrote:
> > On Mon, Aug 6, 2012 at 3:16 PM, Robert Schwebel
> 
> > > That's not true; we still run MX25, MX27, MX35, MX28 on mainline in
> > > active projects.
> 
> > I think Shawn Guo (FSL/Linaro) would also disagree, since he's just
> > posted a large amount of MXS patches to fix up the board for device
> > trees, and Arnd is pulling them.
> 
> MXS != i.MX.
> 
> > As far as I know, the FIQ usage is quite valid for the processor it
> > needs to run on (MX21/27/28, right?) in the modes it runs in (AC97 on
> > these processors, and maybe MX35 too), and I'm just trying to figure
> > out what the steps are for
> 
> Oh, ick.  What is the problem that means people want to use the FIQ on
> these processors?  There's been i.MX2x audio DMA since forever, it had
> DMA in mainline before any of the later i.MXs due to them having SDMA.
> The original mainline i.MX audio support was done on i.MX27 and didn't
> have any issue here, this is the fist I've heard of a problem.

Originally the FIQ support was only used because there hasn't been SDMA
support available at that time.
Nowadays the FIQ support is necessary only for AC97. The AC97 support in
the SSI unit is buggy: It does not allow you to select the slots you
want to receive. At least the wm9712 codec always sends (apart from the
stereo data) data in slot (I think it is) 12. You find this data mixed
in your audio stream. The FIQ driver skips this data to get a valid
audio stream.

One other way to solve this would be to use dma here and to filter out
the data afterwards.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
