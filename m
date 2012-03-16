Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946423Ab2CPXsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:48:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43355 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946336Ab2CPXrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:47:46 -0400
Date: Sat, 17 Mar 2012 00:47:06 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Paul Walmsley <paul@pwsan.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
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
Message-ID: <20120316234706.GJ3852@pengutronix.de>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <CAP245DXV5oE+-y+PQCcSM016h-J+UgTi1efmdrcyeQge4k1Cfw@mail.gmail.com>
 <201203161218.05125.arnd.bergmann@linaro.org>
 <201203162057.58706.arnd@arndb.de>
 <alpine.DEB.2.00.1203161509470.4395@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1203161509470.4395@utopia.booyaka.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 23:44:30 up 125 days,  6:31, 26 users,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Fri, Mar 16, 2012 at 04:21:17PM -0600, Paul Walmsley wrote:
> Hi
> 
> On Fri, 16 Mar 2012, Arnd Bergmann wrote:
> 
> 
> If the common clock code is to go upstream now, it should be marked as 
> experimental.

No, please don't do this. This effectively marks the architectures using
the generic clock framework experimental. We can mark drivers as 'you
have been warned', but marking an architecture as experimental is the
wrong sign for both its users and people willing to adopt the framework.
Also we get this:

warning: (ARCH_MX1 && MACH_MX21 && ARCH_MX25 && MACH_MX27) selects COMMON_CLK which has unmet direct dependencies (EXPERIMENTAL)

(and no, I don't want to support to clock frameworks in parallel)

> This is because we know the API is not well-defined, and 
> that both the API and the underlying mechanics will almost certainly need 
> to change for non-trivial uses of the rate changing code (e.g., DVFS with 
> external I/O devices).

Please leave DVFS out of the game. DVFS will use the clock framework for
the F part and the regulator framework for the V part, but the clock
framework should not get extended with DVFS features. The notifiers we
currently have in the clock framework should give enough information
for DVFS implementations. Even if they don't and we have to change
something here this will have no influence on the architectures
implementing their clock tree with the common clock framework.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
