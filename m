Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab0HKS55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 14:57:57 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:38322 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab0HKS54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 14:57:56 -0400
Date: Wed, 11 Aug 2010 20:57:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk, tony@atomide.com
Subject: Re: [PATCH 1/4] initial support for LogicPD's OMAP3 SOM andTORPEDO
	development kits
Message-ID: <20100811185755.GA3527@merkur.ravnborg.org>
References: <20100811175450.GA17425@merkur.ravnborg.org> <77A0A4DB5BF2A44283E5522C27234AC6021C82D5@EDPRSRV011.logicpd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77A0A4DB5BF2A44283E5522C27234AC6021C82D5@EDPRSRV011.logicpd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacob.

Quick feedback!

You should teach your mailer better manners so it is
visible what you quote and what you answer.


> 
> > +static void __init omap3logic_init_irq(void)
> > +{
> > +	omap_board_config = omap3logic_config;
> > +	omap_board_config_size = ARRAY_SIZE(omap3logic_config);
> > +	omap2_init_common_hw(mt46h32m32lf6_sdrc_params,
> > +				mt46h32m32lf6_sdrc_params);
> > +	omap_init_irq();
> > +#ifdef CONFIG_OMAP_32K_TIMER
> > +	omap2_gp_clockevent_set_gptimer(12);
> > +#endif
> 
> Fix this on the called site. There is zero reason
> to sprinkle all user of omap2_gp_clockevent_set_gptimer()
> with ifdef/endif.
> 
> Will fix

I noticed other users of omap2_gp_clockevent_set_gptimer()
does the same ifdef/endif.
You should take care of them when you have a proper way to do so.
Obviously in another patch.

	Sam
