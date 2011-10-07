Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab1JGRkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 13:40:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42351 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753716Ab1JGRkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 13:40:40 -0400
Message-ID: <1318009239.1644.38.camel@Joe-Laptop>
Subject: Re: [PATCH v3] omap: dmtimer: convert printk to pr_err
From: Joe Perches <joe@perches.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: =?ISO-8859-1?Q?V=EDctor?= Manuel =?ISO-8859-1?Q?J=E1quez?=
	 Leal <vjaquez@igalia.com>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Timo Teras <timo.teras@solidboot.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 07 Oct 2011 10:40:39 -0700
In-Reply-To: <20111007092243.GC27281@n2100.arm.linux.org.uk>
References: <20111006201827.GT6324@atomide.com>
	 <1317977417-17874-1-git-send-email-vjaquez@igalia.com>
	 <20111007092243.GC27281@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 10:22 +0100, Russell King - ARM Linux wrote:
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

Hi Russell

I'm not promoting this patch, just commenting.

At some point in the next couple of years, I want
to convert all of, or as many as possible of, the
remaining printk uses to pr_<level>.

This would allow finer grained control over the
prefixing of KBUILD_MODNAME and __func__, and
could possibly make the kernel image smaller.

Today, arch/arm has ~3:1 ratio of printk to pr_<level>.
grep shows 1427 printks, 468 pr_<level>, 405 pr_debug's.

> If so, please don't make these changes - we have on many occasions been
> blamed for size of diffstat, churn, needless change, and this patch is
> exactly that.

True.

These trivial changes could wait until arch/arm settles
down a bit more.

> By all means fix printk's without KERN_ constants,

There's still more than 250 of those in arch/arm.
Even more with the uses of secondary things like:
#define PRINTK(x...) (foo && printk(x))

> possibly converting
> them to pr_*, but don't go around replacing printk(KERN_* with pr_*(
> without ensuring that there's a real benefit to the change.

Style consistency patches do need to be governed by
acceptable churn rate.


