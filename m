Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab0LMMm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:42:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43943 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab0LMMmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:42:55 -0500
Date: Mon, 13 Dec 2010 13:42:54 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] clk: Generic support for fixed-rate clocks
Message-ID: <20101213124254.GI6017@pengutronix.de>
References: <1291774094.269634.503532219345.0.gpush@pororo> <1291774094.270492.31002734529.2.gpush@pororo> <20101213121413.GA29833@pengutronix.de> <201012132035.41371.jeremy.kerr@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012132035.41371.jeremy.kerr@canonical.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:42:19 up 163 days,  3:53, 33 users,  load average: 0.63, 0.35,
	0.55
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 08:35:37PM +0800, Jeremy Kerr wrote:
> Hi Sascha,
> 
> > > +extern struct clk_ops clk_fixed_ops;
> > > +
> > > +#define INIT_CLK_FIXED(name, r) { \
> > > +	.clk = INIT_CLK(name.clk, clk_fixed_ops), \
> > > +	.rate = (r) \
> > > +}
> > 
> > Is there any other valid usecase for this other than
> > 
> > struct clk_fixed bla = INIT_CLK_FIXED(bla, rate);
> > 
> > Otherwise I suggest to convert the macro to:
> > 
> > #define INIT_CLK_FIXED(name, r) \
> > 	struct clk_fixed name = { \
> > 		.clk = INIT_CLK(name.clk, clk_fixed_ops), \
> > 		.rate = (r) \
> > 	}
> > 
> > This way we do not have to specify the same name twice (and it has
> > to be exactly the same name, otherwise it won't compile).
> 
> For the system-wide INIT_CLK* macros, I've intentionally made them initalisers 
> rather than declarators, so that we can use them in other declarators (ie, the 
> usage of INIT_CLK() above). This would be relevant if someone is using 
> clk_fixed in their struct - probably not likely, but good to be consistent.
> 
> But yes, it would be good to avoid having to specify the name twice - how 
> about adding a:
> 
> #define DEFINE_CLK_FIXED(name, r) \
> 	struct clk_fixed name = INIT_CLK_FIXED(name, r)
> 
> - just like DEFINE_MUTEX and MUTEX_INITIALIZER.

Jup, sounds good.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
