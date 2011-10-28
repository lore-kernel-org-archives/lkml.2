Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663Ab1J1WsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 18:48:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51863 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab1J1WsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 18:48:08 -0400
Date: Sat, 29 Oct 2011 00:47:57 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>, Tony Lindgren <tony@atomide.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-sh@vger.kernel.org,
        linux-omap@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] regulator: Provide dummy supply support
Message-ID: <20111028224757.GG23421@pengutronix.de>
References: <1319833618-25190-1-git-send-email-s.hauer@pengutronix.de>
 <1319833618-25190-2-git-send-email-s.hauer@pengutronix.de>
 <20111028215931.GA30366@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111028215931.GA30366@opensource.wolfsonmicro.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 00:35:06 up 9 days,  5:10, 11 users,  load average: 1.43, 1.59, 1.86
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 11:59:31PM +0200, Mark Brown wrote:
> On Fri, Oct 28, 2011 at 10:26:58PM +0200, Sascha Hauer wrote:
> 
> >  drivers/regulator/Makefile        |    2 +-
> >  drivers/regulator/dummy-supply.c  |   88 +++++++++++++++++++++++++++++++++++++
> 
> We already have a dummy regulator driver and a fixed voltage regulator
> driver, we shouldn't be adding a third implementation of the same thing.
> Just use the fixed voltage regulator for this.

I explained in my mail why I think that the current implementation of
the dummy regulator is not suitable for things apart from debugging.

My main concern with the fixed regulator is that it needs quite much
boilerplate code just to say that we have no regulator at all for a
given device. That could also be handled with a helper function which
registers a fixed regulator and only takes the regulator_consumer_supply
as an argument. Would that be ok for you?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
