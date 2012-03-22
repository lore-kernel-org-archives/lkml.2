Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab2CVL0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 07:26:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41525 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2CVL0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 07:26:16 -0400
Date: Thu, 22 Mar 2012 12:26:13 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] clk: wm831x: Add initial WM831x clock driver
Message-ID: <20120322112613.GA3852@pengutronix.de>
References: <1332360082-25092-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1332360082-25092-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120321222622.GG29317@pengutronix.de>
 <20120322111531.GA3091@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120322111531.GA3091@opensource.wolfsonmicro.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:24:15 up 130 days, 19:11, 68 users,  load average: 0.02, 0.04,
 0.13
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 11:15:31AM +0000, Mark Brown wrote:
> On Wed, Mar 21, 2012 at 11:26:22PM +0100, Sascha Hauer wrote:
> > On Wed, Mar 21, 2012 at 08:01:22PM +0000, Mark Brown wrote:
> 
> > > +	if (!clk_register(&pdev->dev, "xtal", &wm831x_xtal_ops,
> > > +			  &clkdata->xtal_hw, NULL, 0, CLK_IS_ROOT))
> > > +		return -EINVAL;
> 
> > The clock names are unique identifiers for the clock, so clocks in
> > drivers should probably have dev_name encoded into them.
> 
> No, that's not sensible.  We shouldn't be open coding this into each
> individual driver that provides clocks, and we shouldn't have clock
> users having to guess at what scheme the driver author used to dedupe
> the clocks.  As a driver author you would assume that the reason we're
> providing the struct device to the registration function in the first
> place is so that the core has the information it needs to do that.
> 
> I did provide patches to do what you suggest in the core for one of the
> earlier versions of the API, I have to say I didn't check to see if they
> got dropped during the general lulls.

It seems they got dropped. Currently the clock framework does nothing
with the device argument. But right, it could use this argument to
generate a suitable name.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
