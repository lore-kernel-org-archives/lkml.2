Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab2KGQbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:31:51 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:47698 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab2KGQbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:31:49 -0500
Date: Wed, 7 Nov 2012 08:31:44 -0800
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH 9/9] cgroup_freezer: implement proper hierarchy support
Message-ID: <20121107163144.GB2660@mtj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-10-git-send-email-tj@kernel.org>
 <20121107110024.GA4143@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107110024.GA4143@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Wed, Nov 07, 2012 at 12:00:57PM +0100, Michal Hocko wrote:
> > +	 * Update all its descendants in pre-order traversal.  Each
> > +	 * descendant will try to inherit its parent's FREEZING state as
> > +	 * CGROUP_FREEZING_PARENT.
> > +	 */
> > +	rcu_read_lock();
> > +	cgroup_for_each_descendant_pre(pos, freezer->css.cgroup) {
> > +		struct freezer *pos_f = cgroup_freezer(pos);
> > +		struct freezer *parent = parent_freezer(freezer);
> 
> This doesn't seem right. Why are we interested in freezer->parent here
> at all? We should either care about freezer->state & CGROUP_FREEZING or
> parent = parent_freezer(pos_f), right?

Yeap, that should have been parent_freezer(pos_f).  Argh...

Thanks.

-- 
tejun
