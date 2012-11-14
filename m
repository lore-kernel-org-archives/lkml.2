Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423205Ab2KNTEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:04:13 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64845 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423130Ab2KNTEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:04:12 -0500
Date: Wed, 14 Nov 2012 11:04:07 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, glommer@parallels.com
Subject: Re: [PATCH 04/17] cgroup: create directory before linking while
 creating a new cgroup
Message-ID: <20121114190407.GI21185@mtj.dyndns.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
 <1352775704-9023-5-git-send-email-tj@kernel.org>
 <50A30E0F.7000408@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A30E0F.7000408@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Wed, Nov 14, 2012 at 11:20:47AM +0800, Li Zefan wrote:
> > It also removes the need to check whether cgroup->dentry is %NULL in
> > cgroup_path.  If a cgroup is visible, its dentry is guaranteed to be
> > visible too.
> 
> I'm afraid this isn't safe.
> 
> The cgroup is visible to a controller soon after ss->create(), and then
> the controller might call cgroup_path() while cgrp->dentry is still NULL.

Hmmm... I can't find any case where ss->create() is calling
cgroup_path().  Do you remember which one that was?

> This can happen for cpu cgroup I think, and in fact the NULL check was
> added for this reason IIRC.

Then, I think we better move the dentry assignment further up.  It's
really silly to be unable to answer "what's this new cgroup's name?"
for any callback really.  Will update accordingly.

Thanks.

-- 
tejun
