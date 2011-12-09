Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1LILIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 06:08:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48548 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab1LILIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 06:08:14 -0500
Date: Fri, 9 Dec 2011 12:08:07 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32 SoCs
Message-ID: <20111209110807.GG27267@pengutronix.de>
References: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <74CDBE0F657A3D45AFBB94109FB122FF1750B77BD8@HQMAIL01.nvidia.com>
 <20111209010147.GH7913@S2100-06.ap.freescale.net>
 <4EE18403.30604@nvidia.com>
 <20111209043220.GJ7913@S2100-06.ap.freescale.net>
 <4EE192DC.3080209@nvidia.com>
 <20111209051413.GK7913@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111209051413.GK7913@S2100-06.ap.freescale.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:24:43 up 26 days, 18:11, 40 users,  load average: 0.52, 0.59,
 0.75
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 01:14:14PM +0800, Shawn Guo wrote:
> On Thu, Dec 08, 2011 at 09:47:24PM -0700, Stephen Warren wrote:
> > 
> > pin X: function = UART A TX
> > pin Y: function = UART A RX
> > 
> 
> We really do not expect per pin function mapping but per block function
> mapping.  That said, the UART driver is going to tell pinctrl subsystem
> "I'm UARTA, please set all my pins up for me".

I still think it should be "I'm board Y, please set all my pins up for me"

Drivers should not be bothered with pin muxing *at all*. When we add
pinmux_request to drivers all SoCs using this driver are doomed to
implement pinmux support regardless if they have any pinmux support in
hardware or not.
Where this leads we can currently see in current next branch with the
smc91x driver where one single board has a regulator for.  Suddenly all
other boards using this driver stopped working because they have no
regulator provided for the driver.
There is this CONFIG_REGULATOR_DUMMY option which will cause *all*
regulator_request to succeed on all regulators in this binary which
disqualifies this option for multiboard/SoC Kernels.

A pin setup is board specific and not driver specific. There are only
some corner cases where a driver has to do something with the pin setup
like for example on i.MX6 where the drive strength setting has to be
changed with different card speeds.

There is also no value in being able to say which pins are allocated
by which driver. All we really want is being able to abstract the
pinmux in some common way and being able to detect conflicts.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
