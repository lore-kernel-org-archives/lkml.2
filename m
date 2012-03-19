Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab2CSL3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 07:29:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33473 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab2CSL3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 07:29:05 -0400
Date: Mon, 19 Mar 2012 12:28:58 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Rajendra Nayak <rnayak@ti.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Shawn Guo <shawn.guo@freescale.com>, linaro-dev@lists.linaro.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH v7 2/3] clk: introduce the common clock framework
Message-ID: <20120319112858.GX3852@pengutronix.de>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <1331878280-2758-3-git-send-email-mturquette@linaro.org>
 <4F6716DD.5090900@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6716DD.5090900@ti.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:25:13 up 127 days, 19:12, 98 users,  load average: 0.00, 0.04,
 0.24
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 04:52:05PM +0530, Rajendra Nayak wrote:
> Hi Mike,
> 
> >+/*
> >+ * calculate the new rates returning the topmost clock that has to be
> >+ * changed.
> >+ */
> >+static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
> >+{
> >+	struct clk *top = clk;
> >+	unsigned long best_parent_rate = clk->parent->rate;
> 
> Shouldn't you check for a valid parent before dereferencing it? A
> clk_set_rate() on a root clock might throw up some issues otherwise.
>

Yes, should be checked.

> >+	unsigned long new_rate;
> >+
> >+	if (!clk->ops->round_rate&&  !(clk->flags&  CLK_SET_RATE_PARENT)) {
> >+		clk->new_rate = clk->rate;
> >+		return NULL;
> 
> So does this mean a clk_set_rate() fails for a clk which does not have
> a valid .round_rate and does not have a CLK_SET_RATE_PARENT flag set?
> I was thinking this could do a..
> 		clk->new_rate = rate;
> 		top = clk;
> 		goto out;
> ..instead.

The core should make sure that either both set_rate and round_rate are
present or none of them.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
