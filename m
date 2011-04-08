Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1DHLt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 07:49:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:55648 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab1DHLtZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 07:49:25 -0400
Subject: Re: Subject: [PATCH] sched: fixed erroneous all_pinned logic.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vladimir Davydov <VDavydov@parallels.com>
Cc: Ken Chen <kenchen@google.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <870910A1-62AF-412F-A989-1FA57B715E35@parallels.com>
References: <20110408002420.3F3A912217F@elm.corp.google.com>
	 <870910A1-62AF-412F-A989-1FA57B715E35@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 08 Apr 2011 13:49:17 +0200
Message-ID: <1302263357.9086.138.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 14:57 +0400, Vladimir Davydov wrote:
> 
> On Apr 8, 2011, at 4:24 AM, Ken Chen wrote:
> 
> > @@ -2302,6 +2292,9 @@ static int move_tasks(
> > #endif
> >       } while (load_moved && max_load_move > total_load_moved);
> > 
> > +     if (total_load_moved)
> > +             *all_pinned = 0;
> > +
> >       return total_load_moved > 0;
> > }
> > 
> > @@ -3300,7 +3293,7 @@ static int load_balance(
> >                       struct sched_domain *sd, enum cpu_idle_type idle,
> >                       int *balance)
> > {
> > -     int ld_moved, all_pinned = 0, active_balance = 0;
> > +     int ld_moved, all_pinned = 1, active_balance = 0;
> >       struct sched_group *group;
> >       unsigned long imbalance;
> >       struct rq *busiest;
> 
> As far as I understand, this patch sets the all_pinned flag if and
> only if we fail to move any tasks during the load balance. However,
> the migration can fail because e.g. all tasks are cache hot on their
> cpus (can_migrate_task() returns 0 in this case), and in this case we
> shouldn't treat all tasks as cpu bound, should we?-- 

Hmm, you've got a good point there... (that'll teach me to read email in
date order).

Ken would it work to only push the all_pinned = 1 higher and not also
the all_pinned = 0?
