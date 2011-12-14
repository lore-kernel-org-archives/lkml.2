Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab1LNLhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 06:37:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33926 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903Ab1LNLhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:37:35 -0500
Date: Wed, 14 Dec 2011 12:37:28 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Ryan Mallon <rmallon@gmail.com>,
        Bill Gatliff <bgat@billgatliff.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
Message-ID: <20111214113728.GG27267@pengutronix.de>
References: <201106301441.24493.arnd@arndb.de>
 <4E11994B.7070103@gmail.com>
 <20110704124318.GI6069@pengutronix.de>
 <201107041607.10265.arnd@arndb.de>
 <20111207085339.GA7970@avionic-0098.mockup.avionic-design.de>
 <20111207090734.GN27267@pengutronix.de>
 <20111214100338.GA18348@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214100338.GA18348@avionic-0098.mockup.avionic-design.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:34:58 up 31 days, 19:22, 51 users,  load average: 7.34, 3.70,
 2.12
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 11:03:38AM +0100, Thierry Reding wrote:
> * Sascha Hauer wrote:
> > I have a branch which adds a basic PWM framework. It doesn't change the
> > pwm API at all, but only adds support for registering multiple PWM
> > drivers. All in Kernel drivers are converted to this new framework, but
> > except the i.MX driver all of them are untested. I'm quite confident
> > that the drivers itself work, but there will probably be some Kconfig
> > related issues which I wasn't able to sort out. The corresponding
> > Maintainers should probably have a look over it. Feel free to post
> > the patches if you are prepared to work on the comments you receive.
> > Otherwise I'll see if I find some time maybe next week.
> [...]
> 
> I've looked at this in more detail and one thing that irritates me is that
> the current driver API requires a driver to register a pwm_chip structure for
> each PWM it can control. Wouldn't it be easier in such cases to just specify
> how many PWMs a chip wants to register, much like gpiolib does it?

It may be more suitable for some devices like for example the mxs driver
or the at91 driver which Bill has in his tree. However, the idea of this
series was to move the drivers over with the least possible breakage.
Once the drivers are consolidated in a single directory with a single
framework it will be easier to modify.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
