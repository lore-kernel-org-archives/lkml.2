Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab1GUF5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 01:57:20 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61840 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1GUF5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 01:57:19 -0400
Date: Thu, 21 Jul 2011 07:57:13 +0200
From: Tejun Heo <tj@kernel.org>
To: Ben Hutchings <bhutchings@solarflare.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: don't use flush_scheduled_work() in IRQ affinity
 notifiers
Message-ID: <20110721055713.GQ3455@htj.dyndns.org>
References: <20110615142917.GY8141@htj.dyndns.org>
 <1308266886.2925.27.camel@bwh-desktop>
 <20110617094547.GF2611@htj.dyndns.org>
 <1310662160.3098.1.camel@bwh-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310662160.3098.1.camel@bwh-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 05:49:20PM +0100, Ben Hutchings wrote:
> On Fri, 2011-06-17 at 11:45 +0200, Tejun Heo wrote:
> > Hello,
> > 
> > On Fri, Jun 17, 2011 at 12:28:06AM +0100, Ben Hutchings wrote:
> > > This facility is enabled on all configurations with NET && SMP &&
> > > GENERIC_HARDIRQS, but at the moment is only useful for some net drivers
> > > (currently only one).  So I don't think it should be creating a task at
> > > boot time.  Does alloc_workqueue() still create any tasks immediately?
> > 
> > Nope, no need to worry about it.  The only added overhead is the
> > memory occupied by workqueue itself (which includes small percpu area
> > but one systemwide one isn't gonna hurt anyone and we've been
> > decreasing the number of workqueues significantly).  It just serves as
> > a flush domain.
> 
> Sorry I didn't reply to this earlier.
> 
> Given what you've said, I see no problem with this change.  So you can
> add:
> 
> Acked-by: Ben Hutchings <bhutchings@solarflare.com>

Thomas, I suppose this should be routed through tip:irq/core?  Or
shall I push it through wq tree?

Thank you.

-- 
tejun
