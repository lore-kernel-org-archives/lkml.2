Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab1JYRA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 13:00:59 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10441 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1JYRA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 13:00:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 25 Oct 2011 10:00:43 -0700
Date: Tue, 25 Oct 2011 20:00:38 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Joe Perches <joe@perches.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm/tegra: clk_get should not be fatal
Message-ID: <20111025170038.GT1001@tbergstrom-lnx.Nvidia.com>
References: <1319559329-324-1-git-send-email-pdeschrijver@nvidia.com>
 <1319559968.14932.5.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1319559968.14932.5.camel@Joe-Laptop>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 06:26:08PM +0200, Joe Perches wrote:
> On Tue, 2011-10-25 at 19:15 +0300, pdeschrijver@nvidia.com wrote:
> > The timer and rtc-timer clocks aren't gated by default, so there is no reason
> > to crash the system if the dummy enable call failed.
> []
> > diff --git a/arch/arm/mach-tegra/timer.c b/arch/arm/mach-tegra/timer.c
> []
> > @@ -186,16 +186,20 @@ static void __init tegra_init_timer(void)
> >  	int ret;
> >  
> >  	clk = clk_get_sys("timer", NULL);
> > -	BUG_ON(IS_ERR(clk));
> > -	clk_enable(clk);
> > +	if (IS_ERR(clk))
> > +		pr_warning("Unable to get timer clock");
> > +	else
> > +		clk_enable(clk);
> >  
> >  	/*
> >  	 * rtc registers are used by read_persistent_clock, keep the rtc clock
> >  	 * enabled
> >  	 */
> >  	clk = clk_get_sys("rtc-tegra", NULL);
> > -	BUG_ON(IS_ERR(clk));
> > -	clk_enable(clk);
> > +	if (IS_ERR(clk))
> > +		pr_warning("Unable to get rtc-tegra clock");
> > +	else
> > +		clk_enable(clk);
> 
> Are these messages are really necessary?

I think it's still useful to have them as not having a clock fw is a strange
situation. It's not fatal though, but worth a warning I would say.

> Maybe just:
> 	if (!IS_ERR(clk))
> 		clk_enable(clk)
> 
> If these are really necessary, please use
> 	pr_warn("Unable to get <foo>\n");
> pr_warn and with a terminating newline.
> 

Is pr_warn any different then pr_warning? Point taken about the newline.

Cheers,

Peter.
