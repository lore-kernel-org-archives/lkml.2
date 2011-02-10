Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab1BJMqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:46:18 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:36845 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1BJMqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:46:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oNouZjCQbFUL/YWlG9JS+QMiM8UiK+ybMWbw9mvwXrjS8IQKUutjZ2GarlKj6VijoA
         nV+ZITDGFdAH4ikykWXCSdS5c8lcvkZCe6Y1eYkZjhObU1XOLaBrI1uSEmsmd4URpNiI
         SdpGPa1/Ni9DgQ6uMk1H0+exVpJqyWf5Z5keA=
Date: Thu, 10 Feb 2011 20:45:43 +0800
From: Richard Zhao <linuxzsc@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Richard Zhao <richard.zhao@freescale.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
Message-ID: <20110210124543.GA3316@richard-laptop>
References: <1297233693.242364.862698430999.1.gpush@pororo>
 <4D52F73A.4010707@bluewatersys.com>
 <20110210100319.GB24710@b20223-02.ap.freescale.net>
 <4D53B9AC.8020609@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D53B9AC.8020609@bluewatersys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 11:10:52PM +1300, Ryan Mallon wrote:
> On 10/02/11 23:03, Richard Zhao wrote:
> >On Thu, Feb 10, 2011 at 09:21:14AM +1300, Ryan Mallon wrote:
> >>On 02/09/2011 07:41 PM, Jeremy Kerr wrote:
> >>
> >>Hi Jeremy,
> >>
> >>Couple more comments below.
> >>
> >>~Ryan
> >>
> >[...]
> >>>+int clk_enable(struct clk *clk)
> >>>+{
> >>>+     unsigned long flags;
> >>>+     int ret = 0;
> >>>+
> >>>+     spin_lock_irqsave(&clk->enable_lock, flags);
> >>         WARN_ON(clk->prepare_count == 0); ?
> >>
> >>>+     if (clk->enable_count == 0&&  clk->ops->enable)
> >>>+             ret = clk->ops->enable(clk);
> >>Does it make sense to have a clock with no enable function which still
> >>returns success from clk_enable? Do we have any platforms which have
> >>NULL clk_enable functions?
> >>
> >>I think that for enable/disable at least we should require platforms to
> >>provide functions and oops if they have failed to do so. In the rare
> >>case that a platform doesn't need to do anything for enable/disable they
> >>can just supply empty functions.
> >It's possible to be NULL. So are set_rate/get_rate.
> >Ideally, if it's NULL:
> >prepare/unprepare: only call parent's prepare/unprepare
> >enable/disable: only call parent's enable/disable
> 
> No, the whole point of the generic framework is that _all_ clock
> users must call prepare/enable and disable/unprepare. Drivers, etc
> should not rely on underlying knowledge of a platform. This is why,
> for instance, clk_enable will warn if prepare count is zero.
> 
> However, I can see that a clock may be fully enabled by its prepare
> function and so the enable function is a no-op. User must still call
> both prepare and enable though. Perhaps this is what you meant?
I mean prepare/unprepare, enable/disable and get_rate ops null can be handled
in the common clock code. But it needs parent clock pointer.

Thanks
Richard
> 
> ~Ryan
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
