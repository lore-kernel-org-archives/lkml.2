Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1GKKII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 06:08:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49159 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab1GKKIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 06:08:07 -0400
Date: Mon, 11 Jul 2011 12:07:59 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant@secretlab.ca>, linux-sh@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/6] clk: Initial feedback for off-SoC slow bus clocks
Message-ID: <20110711100759.GG26347@pengutronix.de>
References: <20110711025344.GA27497@opensource.wolfsonmicro.com>
 <20110711093124.GA3239@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711093124.GA3239@n2100.arm.linux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:02:20 up 19 days, 15:49, 54 users,  load average: 1.52, 4.30,
 4.20
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 10:31:24AM +0100, Russell King - ARM Linux wrote:
> On Mon, Jul 11, 2011 at 11:53:44AM +0900, Mark Brown wrote:
> > The biggest issue I ran into was that as the clocks are all registered
> > by name with the API if you've got two instances of the same off-SoC
> > device in the system you'll not be able to disambiguate between the
> > clocks it provides.
> 
> Sigh.  That sounds like yet more trash.  Obviously whoever thought
> up that doesn't actually understand clks.

Nope. In the patches Jeremy posted clocks have a name, but this name
is not meant to be used with clk_get. clk_get is still implemented
in clkdev, so the matching between clocks and devices is independent
of the clock name.

In earlier versions of Jeremys patches the clock name was only present
when debugfs was compiled in and I think it can be changed back to this.

That said the debugfs support (which is not present in Jeremys latest
series) would break if two clocks with the same name have the same
parent, because the clock core would try to create to debugfs entries
with the same name.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
