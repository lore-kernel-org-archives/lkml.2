Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab1BJKDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 05:03:35 -0500
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:2255
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755359Ab1BJKDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 05:03:33 -0500
X-SpamScore: -25
X-BigFish: VS-25(z37d5kzbb2dK1418M1432N98dN9371Pzz1202hzzz2dh2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw02.freescale.net;RD:az33egw02.freescale.net;EFVD:NLI
Date: Thu, 10 Feb 2011 18:03:19 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Ryan Mallon <ryan@bluewatersys.com>
CC: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, <linux-kernel@vger.kernel.org>,
        Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
Message-ID: <20110210100319.GB24710@b20223-02.ap.freescale.net>
References: <1297233693.242364.862698430999.1.gpush@pororo>
 <4D52F73A.4010707@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D52F73A.4010707@bluewatersys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 09:21:14AM +1300, Ryan Mallon wrote:
> On 02/09/2011 07:41 PM, Jeremy Kerr wrote:
> 
> Hi Jeremy,
> 
> Couple more comments below.
> 
> ~Ryan
> 
[...]
> > +int clk_enable(struct clk *clk)
> > +{
> > +     unsigned long flags;
> > +     int ret = 0;
> > +
> > +     spin_lock_irqsave(&clk->enable_lock, flags);
> 
>         WARN_ON(clk->prepare_count == 0); ?
> 
> > +     if (clk->enable_count == 0 && clk->ops->enable)
> > +             ret = clk->ops->enable(clk);
> 
> Does it make sense to have a clock with no enable function which still
> returns success from clk_enable? Do we have any platforms which have
> NULL clk_enable functions?
> 
> I think that for enable/disable at least we should require platforms to
> provide functions and oops if they have failed to do so. In the rare
> case that a platform doesn't need to do anything for enable/disable they
> can just supply empty functions.
It's possible to be NULL. So are set_rate/get_rate.
Ideally, if it's NULL: 
prepare/unprepare: only call parent's prepare/unprepare
enable/disable: only call parent's enable/disable
set_rate: fail
get_rate: reture parent's get_rate
set_parent: fail
get_parent: fail

Thanks
Richard
> 
> > +
> > +     if (!ret)
> > +             clk->enable_count++;
> > +     spin_unlock_irqrestore(&clk->enable_lock, flags);
> > +
> > +     return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(clk_enable);
> > +

