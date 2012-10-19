Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2JSA6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 20:58:08 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47830 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab2JSA6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 20:58:05 -0400
Date: Thu, 18 Oct 2012 17:58:01 -0700
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Is not locking task_lock in cgroup_fork() safe?
Message-ID: <20121019005801.GF13370@google.com>
References: <20121008020000.GB2575@localhost>
 <CAFTL4hzXWtzp7megsCAEuak5=_2SWmp9age-+wrpyQAU4BRZ0w@mail.gmail.com>
 <20121016193341.GD16166@google.com>
 <CAFTL4hzo_w7HTgC9ApTk113X8WdZSpV+D+VSEe=604YEJFmKsg@mail.gmail.com>
 <20121018200705.GG13370@google.com>
 <CAFTL4hy7g4e11OUOyoihrEU8hiVgZoV1=141UtUpj9a72SNs_Q@mail.gmail.com>
 <20121019003835.GE13370@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019003835.GE13370@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Thu, Oct 18, 2012 at 05:38:35PM -0700, Tejun Heo wrote:
> Even if there isn't an actual race, the comment is dead wrong.  I'm
> reverting the following three patches.  Let's try again later.
> 
>   7e381b0eb1 ("cgroup: Drop task_lock(parent) on cgroup_fork()")
>   7e3aa30ac8 ("cgroup: Remove task_lock() from cgroup_post_fork()")

So, after some more looking, I think the following is correct and
doesn't need to be reverted.  It's depending on threadgroup locking
from migration path to synchronize against exit path which is always
performed.

>   c84cdf75cc ("cgroup: Remove unnecessary task_lock before fetching css_set on migration")

Frederic, were you trying to say that the above commit is correct?
Li, do you agree?

Thanks.

-- 
tejun
