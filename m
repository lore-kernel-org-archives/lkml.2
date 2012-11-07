Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab2KGRB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 12:01:29 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49081 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2KGRB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 12:01:27 -0500
Date: Wed, 7 Nov 2012 09:01:18 -0800
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH 3/9] cgroup: implement generic child / descendant walk
 macros
Message-ID: <20121107170118.GD2660@mtj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-4-git-send-email-tj@kernel.org>
 <20121107165457.GD4131@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107165457.GD4131@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Wed, Nov 07, 2012 at 05:54:57PM +0100, Michal Hocko wrote:
> > +struct cgroup *cgroup_next_descendant_pre(struct cgroup *pos,
> > +					  struct cgroup *cgroup)
> > +{
> > +	struct cgroup *next;
> > +
> > +	WARN_ON_ONCE(!rcu_read_lock_held());
> > +
> > +	/* if first iteration, pretend we just visited @cgroup */
> > +	if (!pos) {
> > +		if (list_empty(&cgroup->children))
> > +			return NULL;
> > +		pos = cgroup;
> > +	}
> 
> Is there any specific reason why the root of the tree is excluded?
> This is bit impractical because you have to special case the root
> in the code.

Yeah, thought about including it but decided against it for two
reasons.

* To be consistent with cgroup_for_each_children() - it's a bit weird
  for descendants to include self when children don't.

* Iteration root is likely to require different treatment anyway.
  e.g. for cgroup_freezer, the root is updated to the specified config
  while all the descendants inherit config from its immediate parent.
  They are different.

Thanks.

-- 
tejun
