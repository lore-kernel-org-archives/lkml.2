Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab3ABQaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 11:30:15 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:61353 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab3ABQaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 11:30:13 -0500
Date: Wed, 2 Jan 2013 11:30:10 -0500
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 23/24] cfq-iosched: collect stats from dead cfqgs
Message-ID: <20130102163010.GC11220@mtj.dyndns.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-24-git-send-email-tj@kernel.org>
 <20130102162415.GA4306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130102162415.GA4306@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Vivek.

On Wed, Jan 02, 2013 at 11:24:15AM -0500, Vivek Goyal wrote:
> On Fri, Dec 28, 2012 at 12:35:45PM -0800, Tejun Heo wrote:
> > To support hierarchical stats, it's necessary to remember stats from
> > dead children.  Add cfqg->dead_stats and make a dying cfqg transfer
> > its stats to the parent's dead-stats.
> 
> Hi Tejun,
> 
> Why not directly transfer stats to cfqg->stats. IOW, what's the advantage
> of maintaining dead_stats separately.

Backward compatibility?  The existing stat cgroupfs files expect to
see non-recursive stats.

> > +	cfqg_stats_merge(&parent->dead_stats, &cfqg->stats);
> > +	cfqg_stats_merge(&parent->dead_stats, &cfqg->dead_stats);
> > +	cfqg_stats_reset(&cfqg->stats);
> > +	cfqg_stats_reset(&cfqg->dead_stats);
> 
> Anyway group will be marked offline and later freed. So resetting stats
> might not be required.

Yeah, it isn't strictly necessary.  I tried to transfer the residual
IOs between offline and release first so the resetting.  Kinda like
them there tho.

> In fact if we have a realiable way of resetting status then online/offline
> infrastructure might not be required? I think per cpu stats will be a
> problem though and that's why we probably require logic to online/offline
> the group?

Hmmm?  What do you mean?

Thanks.

-- 
tejun
