Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965140Ab1JFQ0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 12:26:19 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:34009 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935856Ab1JFQ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 12:26:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwEAH/VjU5bdWOb/2dsb2JhbABDqTiBUwEBBTIBIyMQCxguFCUDIYgTuC2HLAScTYhp
X-IronPort-AV: E=Sophos;i="4.68,496,1312149600"; 
   d="scan'208";a="898017144"
Date: Thu, 6 Oct 2011 18:26:14 +0200
From: =?iso-8859-1?Q?V=EDctor_M=2E_J=E1quez_L=2E?= <vjaquez@igalia.com>
To: Joe Perches <joe@perches.com>
Cc: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Timo Teras <timo.teras@solidboot.com>,
        Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] omap: dmtimer: convert printk to pr_*
Message-ID: <20111006162614.GH30222@lit.local.igalia.com>
References: <1317898106-1891-1-git-send-email-vjaquez@igalia.com>
 <1317914379.10495.5.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1317914379.10495.5.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 08:19:39AM -0700, Joe Perches wrote:
> On Thu, 2011-10-06 at 12:48 +0200, Víctor Manuel Jáquez Leal wrote:
> > Convert all the printk(<level>) messages in the driver to pr_<level>().
> []
> > diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
> []
> > @@ -397,8 +397,7 @@ struct omap_dm_timer *omap_dm_timer_request_specific(int id)
> >  	spin_lock_irqsave(&dm_timer_lock, flags);
> >  	if (id <= 0 || id > dm_timer_count || dm_timers[id-1].reserved) {
> >  		spin_unlock_irqrestore(&dm_timer_lock, flags);
> > -		printk("BUG: warning at %s:%d/%s(): unable to get timer %d\n",
> > -		       __FILE__, __LINE__, __func__, id);
> > +		pr_warning("unable to get timer %d\n", id);
> 
> For new conversions, please use pr_warn not pr_warning.
> It's shorter and similar to other dev_warn/netdev_warn
> uses.
> 
> >  		dump_stack();
> 
> To emit a message then dump stack, please use
> 	WARN(1, fmt, ...)
> 

Thanks a lot!

I'll do that and then resend.

vmjl
