Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab2JaREi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:04:38 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:35209 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2JaREg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:04:36 -0400
Date: Wed, 31 Oct 2012 10:04:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] cgroup: use cgroup_lock_live_group(parent) in
 cgroup_create()
Message-ID: <20121031170431.GF2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-4-git-send-email-tj@kernel.org>
 <20121031155514.GD22809@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031155514.GD22809@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Michal.

On Wed, Oct 31, 2012 at 04:55:14PM +0100, Michal Hocko wrote:
> > +	/*
> > +	 * Only live parents can have children.  Note that the liveliness
> > +	 * check isn't strictly necessary because cgroup_mkdir() and
> > +	 * cgroup_rmdir() are fully synchronized by i_mutex; however, do it
> > +	 * anyway so that locking is contained inside cgroup proper and we
> > +	 * don't get nasty surprises if we ever grow another caller.
> > +	 */
> > +	if (!cgroup_lock_live_group(parent)) {
> > +		err = -ENODEV;
> > +		goto err_free;
> > +	}
> > +
> 
> I think this should be moved up before we try to allocate any memory.
> Or is your motivation to keep cgroup_lock held for shorter time?
> I could agree with that but a small comment would be helpful.

Then I have to change the error out path more and I'm not sure I wanna
call deactivate_super() under cgroup_mutex.  It's just simpler this
way.

Thanks.

-- 
tejun
