Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab2KSQ3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 11:29:04 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57845 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab2KSQ3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 11:29:01 -0500
Date: Mon, 19 Nov 2012 08:28:55 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, glommer@parallels.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 01/17] cgroup: remove incorrect dget/dput() pair in
 cgroup_create_dir()
Message-ID: <20121119162855.GD15971@htj.dyndns.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
 <1352775704-9023-2-git-send-email-tj@kernel.org>
 <50A9E8E4.4050004@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A9E8E4.4050004@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 04:08:04PM +0800, Li Zefan wrote:
> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > index 0f8fa6a..d0803f0 100644
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -2684,9 +2684,7 @@ static int cgroup_create_dir(struct cgroup *cgrp, struct dentry *dentry,
> >  		dentry->d_fsdata = cgrp;
> >  		inc_nlink(parent->d_inode);
> >  		rcu_assign_pointer(cgrp->dentry, dentry);
> > -		dget(dentry);
> >  	}
> > -	dput(dentry);
> >  
> 
> The code has been there since cgroup was merged into mainline!

I know.  Sometimes it's scary how many latent bugs we have in the
kernel and how long many of them have been around.  At other times,
it's comforting.  I mean, there's a pretty good chance that other
people don't notice my screw ups, right?  :P

-- 
tejun
