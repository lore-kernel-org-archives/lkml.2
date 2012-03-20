Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030367Ab2CTQCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:02:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55306 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab2CTQCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:02:33 -0400
Date: Tue, 20 Mar 2012 09:02:28 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: lizf@cn.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rni@google.com, ctalbott@google.com
Subject: Re: [PATCH 09/10] cgroup: introduce struct cfent
Message-ID: <20120320160228.GD5684@google.com>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
 <1331940963-15756-10-git-send-email-tj@kernel.org>
 <4F688EA9.8050905@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F688EA9.8050905@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 06:05:29PM +0400, Glauber Costa wrote:
> On 03/17/2012 03:36 AM, Tejun Heo wrote:
> >+static void cgroup_clear_directory(struct dentry *dir)
> >+{
> >+	struct cgroup *cgrp = __d_cgrp(dir);
> >+
> >+	while (!list_empty(&cgrp->files))
> >+		cgroup_rm_file(cgrp, NULL);
> >+	WARN_ON_ONCE(!list_empty(&dir->d_subdirs));
> >  }
> 
> 
> I am hitting this warning here under pretty much normal conditions.
> You forgot to account for trivial directories like "."
> 
> I'll send a patch ontop of what you have.

Heh, yeah, I hit that yesterday too and was gonna look into that
today.  Is the patch coming? :)

Thanks.

-- 
tejun
