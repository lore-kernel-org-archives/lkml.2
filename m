Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab1BJKrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 05:47:01 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57214 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1BJKq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 05:46:59 -0500
Date: Thu, 10 Feb 2011 11:46:39 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
Message-ID: <20110210104639.GZ27982@pengutronix.de>
References: <1297233693.242364.862698430999.1.gpush@pororo>
 <4D52F73A.4010707@bluewatersys.com>
 <20110210100319.GB24710@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110210100319.GB24710@b20223-02.ap.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 10, 2011 at 06:03:19PM +0800, Richard Zhao wrote:
> On Thu, Feb 10, 2011 at 09:21:14AM +1300, Ryan Mallon wrote:
> > On 02/09/2011 07:41 PM, Jeremy Kerr wrote:
> > 
> > Hi Jeremy,
> > 
> > Couple more comments below.
> > 
> > ~Ryan
> > 
> [...]
> > > +int clk_enable(struct clk *clk)
> > > +{
> > > +     unsigned long flags;
> > > +     int ret = 0;
> > > +
> > > +     spin_lock_irqsave(&clk->enable_lock, flags);
> > 
> >         WARN_ON(clk->prepare_count == 0); ?
> > 
> > > +     if (clk->enable_count == 0 && clk->ops->enable)
> > > +             ret = clk->ops->enable(clk);
> > 
> > Does it make sense to have a clock with no enable function which still
> > returns success from clk_enable? Do we have any platforms which have
> > NULL clk_enable functions?
> > 
> > I think that for enable/disable at least we should require platforms to
> > provide functions and oops if they have failed to do so. In the rare
> > case that a platform doesn't need to do anything for enable/disable they
> > can just supply empty functions.
> It's possible to be NULL. So are set_rate/get_rate.
> Ideally, if it's NULL: 
> prepare/unprepare: only call parent's prepare/unprepare
> enable/disable: only call parent's enable/disable
> set_rate: fail
> get_rate: reture parent's get_rate
> set_parent: fail
> get_parent: fail
I wouldn't hard-code the parents into the generic functions.  But I
suggest to provide generic callbacks to do this, e.g.

clk_get_rate_from_parent(struct clk *c)
{
	struct clk *parent = clk_get_parent(c);

	return clk_get_rate(parent);
}

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
