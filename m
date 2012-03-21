Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab2CUJLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:11:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35902 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab2CUJLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:11:09 -0400
Date: Wed, 21 Mar 2012 10:10:37 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Paul Walmsley <paul@pwsan.com>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
Message-ID: <20120321091037.GQ3852@pengutronix.de>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <CAP245DXV5oE+-y+PQCcSM016h-J+UgTi1efmdrcyeQge4k1Cfw@mail.gmail.com>
 <201203161218.05125.arnd.bergmann@linaro.org>
 <201203162057.58706.arnd@arndb.de>
 <alpine.DEB.2.00.1203161509470.4395@utopia.booyaka.com>
 <20120316234706.GJ3852@pengutronix.de>
 <alpine.DEB.2.00.1203201611330.22974@utopia.booyaka.com>
 <alpine.LFD.2.02.1203202233340.24151@xanadu.home>
 <4F694A6A.4050706@codeaurora.org>
 <alpine.DEB.2.00.1203210130520.30543@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1203210130520.30543@utopia.booyaka.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:01:00 up 129 days, 16:48, 61 users,  load average: 3.94, 1.04,
 0.44
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 01:44:01AM -0600, Paul Walmsley wrote:
> Hello Saravana,
> 
> Certainly a Kconfig help text change seems trivial enough.  But even the 
> resistance to CONFIG_EXPERIMENTAL has been quite surprising to me, given 
> that every single defconfig in arch/arm/defconfig sets it:
> 
> $ find arch/arm/configs -type f  | wc -l
> 122
> $ fgrep -r CONFIG_EXPERIMENTAL=y arch/arm/configs | wc -l
> 122
> $
> 
> (that includes iMX, by the way...)
> 
> Certainly, neither Kconfig change is going to prevent us on OMAP from 
> figuring out what else is needed to convert our platform to the common 
> clock code.  And given the level of enthusiasm on the lists, I don't think 
> it's going to prevent many of the other ARM platforms from experimenting 
> with the conversion, either.
> 
> So it would be interesting to know more about why you (or anyone else) 
> perceive that the Kconfig changes would be harmful.

Mainly because COMMON_CLK is an invisible option which has to be
selected by architectures. So with the Kconfig change we either have to:

config ARCH_MXC
	depends on EXPERIMENTAL

or:

config ARCH_MXC
	select EXPERIMENTAL
	select COMMON_CLK

Neither of both seems very appealing to me.

You can add a warning to the Kconfig help text if you like, I
have no problem with that. As you said it will prevent noone
from using it anyway.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
