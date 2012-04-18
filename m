Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab2DROA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:00:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40172 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2DROA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:00:57 -0400
Date: Wed, 18 Apr 2012 16:00:46 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Dong Aisheng <aisheng.dong@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 1/1] pinctrl: handle dummy state in core
Message-ID: <20120418140046.GU3852@pengutronix.de>
References: <1334586289-13078-1-git-send-email-b29396@freescale.com>
 <4F8C42D6.2000607@wwwdotorg.org>
 <20120417034210.GD17173@shlinux2.ap.freescale.net>
 <CACRpkdYH06_kGbSdozKPWZcOG0FvoOyHvjHwhz-xUL1pfSX9DQ@mail.gmail.com>
 <20120418122832.GP20478@pengutronix.de>
 <CACRpkdZw6iv=PjvvU4s5L8yV6813gCD7t8Vk-S66v-nXPaf+=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZw6iv=PjvvU4s5L8yV6813gCD7t8Vk-S66v-nXPaf+=Q@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:55:20 up 157 days, 21:42, 81 users,  load average: 0.90, 0.47,
 2.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 03:52:23PM +0200, Linus Walleij wrote:
> On Wed, Apr 18, 2012 at 2:28 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> 
> > Currently Dong Aisheng is working on i.MX6, we have i.MX31, i.MX35,
> > i.MX51 and i.MX53 enabled in the same defconfig. Waiting for all
> > machines turn over at once to pinctrl is illusionary. We have to make
> > drivers work with and without pinctrl. We have a bunch of bad choices:
> >
> > - create a dummy pinctrl for all boards which do not have real pinmux
> >  support
> 
> Viable compromise.
> 
> > - ignore pinctrl_request errors in drivers.
> 
> Ugh. Not good.
> 
> > - generate and return a dummy pinctrl in the core if no real pinctrl is
> >  found.
> >
> > (replace pinctrl with regulators or clocks, it's the same situation, and
> > it's not only i.MX specific)
> 
> Since we have dummy regulators, we should not break the design
> pattern creating more confusion.
> 
> Stephen can you live with dummy pinctrl handles emitted by the
> core, if explictly enabled by a Kconfig option?

I'd rather not make it a Kconfig option but a runtime option. With a
Kconfig option we can only chose in the defconfigs whether it won't
work on some boards or it will hide pinctrl errors on all other boards.

Create a pinctrl_provide_dummies() functions which boards can call when
they do not have pinctrl support.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
