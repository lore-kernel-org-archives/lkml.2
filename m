Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab2KHRPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:15:39 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37769 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab2KHRPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:15:37 -0500
Date: Thu, 8 Nov 2012 09:15:32 -0800
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH 3/9] cgroup: implement generic child / descendant walk
 macros
Message-ID: <20121108171532.GI12973@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-4-git-send-email-tj@kernel.org>
 <20121108095013.GA31821@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108095013.GA31821@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Michal.

On Thu, Nov 08, 2012 at 10:50:13AM +0100, Michal Hocko wrote:
> On Sat 03-11-12 01:38:29, Tejun Heo wrote:
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
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> I will convert mem_cgroup_iter to use this rather than css_get_next
> after this gets into the next tree so that it can fly via Andrew.
> 
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> 
> Just a minor knit. You are talking about a config propagation while I
> would consider state propagation more clear and less confusing. Config
> is usually stable enough so that post_create is not necessary for
> syncing (e.g. memcg.swappiness). It is a state which must be consistent
> throughout the hierarchy which matters here.

Did s/config/state/g

Thanks.

-- 
tejun
