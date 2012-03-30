Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab2C3Pm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:42:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59083 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2C3Pmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:42:50 -0400
Date: Fri, 30 Mar 2012 08:42:46 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com
Subject: Re: [PATCHSET] cgroup: cftype based file interface, take #2
Message-ID: <20120330154246.GE28934@google.com>
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
 <4F75AA1F.9020007@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F75AA1F.9020007@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Li.

On Fri, Mar 30, 2012 at 08:42:07PM +0800, Li Zefan wrote:
> > This patch replaces cgroup file interface with cftype based one which
> > allows dynamic additions and removals of cftype arrays whether the
> > target subsystem is attached or not.  This can be used to make subsys
> > rebinding via remount work properly but I intentionally avoided doing
> > that at the moment.
> 
> What's the problem with remount?

Subsys can't be changed if any non-root cgroup exists.

> and is it important enough that it should be fixed even the feature
> is marked as deprecated?

I'm not sure.  We *might* need it during multi-mount -> single-mount
transition depending on how that's implemented, so the "at the moment"
qualifier.  It probably won't be fixed but I'm not fully sure.

> > This makes cgroup population simpler for controllers and will be used
> > to allow controllers to be more dynamic.  e.g. blkio subsys has
> > sub-policies which may come and go while blkio subsys is attached and
> > it currently uses fixed set of files which stays blank if not in use.
> 
> Dynamic cgroup files was mentioned before. The scenario in mind was blkio
> control files can be added/removed automatically as devices come and ago.
> 
> So this time blkio subsystem is really going to be made more dynamic
> soon?

Patchset already posted.

  http://thread.gmane.org/gmane.linux.kernel.cgroups/1376

Thanks.

-- 
tejun
