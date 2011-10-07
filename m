Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841Ab1JGKrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:47:03 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:39844 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab1JGKrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:47:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap0EAJXXjk5bdWOb/2dsb2JhbABEqUCBUwEBBScLASMXDBALGC4UJQMhiBO4BYZRYQScTohq
X-IronPort-AV: E=Sophos;i="4.68,501,1312149600"; 
   d="scan'208";a="421844923"
Date: Fri, 7 Oct 2011 12:46:56 +0200
From: =?iso-8859-1?Q?V=EDctor_M=2E_J=E1quez_L=2E?= <vjaquez@igalia.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Timo Teras <timo.teras@solidboot.com>
Subject: Re: [PATCH v3] omap: dmtimer: convert printk to pr_err
Message-ID: <20111007104656.GB20440@lit.local.igalia.com>
References: <20111006201827.GT6324@atomide.com>
 <1317977417-17874-1-git-send-email-vjaquez@igalia.com>
 <20111007092243.GC27281@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111007092243.GC27281@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 10:22:43AM +0100, Russell King - ARM Linux wrote:
> On Fri, Oct 07, 2011 at 10:50:16AM +0200, Víctor Manuel Jáquez Leal wrote:
> > Convert a printk(KERN_ERR) message in the driver to pr_err().
> ...
> > @@ -111,7 +111,7 @@ static void omap_dm_timer_wait_for_reset(struct omap_dm_timer *timer)
> >  	while (!(__raw_readl(timer->sys_stat) & 1)) {
> >  		c++;
> >  		if (c > 100000) {
> > -			printk(KERN_ERR "Timer failed to reset\n");
> > +			pr_err("Timer failed to reset\n");
> 
> What is the reason behind this change?  It looks like it's to use the
> latest and greatest function.
> 
> If so, please don't make these changes - we have on many occasions been
> blamed for size of diffstat, churn, needless change, and this patch is
> exactly that.
> 
> By all means fix printk's without KERN_ constants, possibly converting
> them to pr_*, but don't go around replacing printk(KERN_* with pr_*(
> without ensuring that there's a real benefit to the change.
> 

Thanks a lot Russell, and sorry for the noise. I'm still learning how to
collaborate in the kernel.

vmjl
