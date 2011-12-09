Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab1LINBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:01:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39169 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab1LINBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 08:01:18 -0500
Date: Fri, 9 Dec 2011 14:01:09 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@freescale.com>, Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32 SoCs
Message-ID: <20111209130109.GT4585@pengutronix.de>
References: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <74CDBE0F657A3D45AFBB94109FB122FF1750B77BD8@HQMAIL01.nvidia.com>
 <20111209010147.GH7913@S2100-06.ap.freescale.net>
 <4EE18403.30604@nvidia.com>
 <20111209043220.GJ7913@S2100-06.ap.freescale.net>
 <4EE192DC.3080209@nvidia.com>
 <20111209051413.GK7913@S2100-06.ap.freescale.net>
 <20111209110807.GG27267@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111209110807.GG27267@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 12:08:07PM +0100, Sascha Hauer wrote:
> On Fri, Dec 09, 2011 at 01:14:14PM +0800, Shawn Guo wrote:
> > On Thu, Dec 08, 2011 at 09:47:24PM -0700, Stephen Warren wrote:
> > > 
> > > pin X: function = UART A TX
> > > pin Y: function = UART A RX
> > > 
> > 
> > We really do not expect per pin function mapping but per block function
> > mapping.  That said, the UART driver is going to tell pinctrl subsystem
> > "I'm UARTA, please set all my pins up for me".
> 
> I still think it should be "I'm board Y, please set all my pins up for me"
> 
> Drivers should not be bothered with pin muxing *at all*. When we add
> pinmux_request to drivers all SoCs using this driver are doomed to
> implement pinmux support regardless if they have any pinmux support in
> hardware or not.
> Where this leads we can currently see in current next branch with the
> smc91x driver where one single board has a regulator for.  Suddenly all
> other boards using this driver stopped working because they have no
> regulator provided for the driver.
It's the same problem with clks. IMHO that's OK.

> There is this CONFIG_REGULATOR_DUMMY option which will cause *all*
> regulator_request to succeed on all regulators in this binary which
> disqualifies this option for multiboard/SoC Kernels.
> A pin setup is board specific and not driver specific. There are only
An upside of making drivers pinctrl-aware is that it might solve the
hardware conflicts on development boards. And the way pinctrl works it's
still the board that sets up the connection between device and how which
pins are configured.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
