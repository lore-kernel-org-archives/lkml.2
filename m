Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2KGPii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:38:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab2KGPig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:38:36 -0500
Date: Wed, 7 Nov 2012 16:38:35 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH 3/9] cgroup: implement generic child / descendant walk
 macros
Message-ID: <20121107153835.GC4131@dhcp22.suse.cz>
References: <1351931915-1701-4-git-send-email-tj@kernel.org>
 <20121106203154.GV30069@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106203154.GV30069@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 06-11-12 12:31:54, Tejun Heo wrote:
> On Sat, Nov 03, 2012 at 01:38:29AM -0700, Tejun Heo wrote:
> > Currently, cgroup doesn't provide any generic helper for walking a
> > given cgroup's children or descendants.  This patch adds the following
> > three macros.
> > 
> > * cgroup_for_each_child() - walk immediate children of a cgroup.
> > 
> > * cgroup_for_each_descendant_pre() - visit all descendants of a cgroup
> >   in pre-order tree traversal.
> > 
> > * cgroup_for_each_descendant_post() - visit all descendants of a
> >   cgroup in post-order tree traversal.
> > 
> > All three only require the user to hold RCU read lock during
> > traversal.  Verifying that each iterated cgroup is online is the
> > responsibility of the user.  When used with proper synchronization,
> > cgroup_for_each_descendant_pre() can be used to propagate config
> > updates to descendants in reliable way.  See comments for details.
> 
> Michal, Li, how does this look to you?  Would this be okay for memcg
> too?

Yes, definitely. We are currently iterating by css->id which is, ehm,
impractical. Having a deterministic tree walk is definitely a plus.

-- 
Michal Hocko
SUSE Labs
