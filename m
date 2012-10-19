Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab2JSAim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 20:38:42 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:44503 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2JSAik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 20:38:40 -0400
Date: Thu, 18 Oct 2012 17:38:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Is not locking task_lock in cgroup_fork() safe?
Message-ID: <20121019003835.GE13370@google.com>
References: <20121008020000.GB2575@localhost>
 <CAFTL4hzXWtzp7megsCAEuak5=_2SWmp9age-+wrpyQAU4BRZ0w@mail.gmail.com>
 <20121016193341.GD16166@google.com>
 <CAFTL4hzo_w7HTgC9ApTk113X8WdZSpV+D+VSEe=604YEJFmKsg@mail.gmail.com>
 <20121018200705.GG13370@google.com>
 <CAFTL4hy7g4e11OUOyoihrEU8hiVgZoV1=141UtUpj9a72SNs_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hy7g4e11OUOyoihrEU8hiVgZoV1=141UtUpj9a72SNs_Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

On Thu, Oct 18, 2012 at 10:53:47PM +0200, Frederic Weisbecker wrote:
> > For now, I'll revert the patches and cc stable.  Let's think about
> > improving it later.
> 
> Ok for reverting in cgroup_fork(). Is it necessary for the
> cgroup_post_fork() thing? I don't immediately see any race involved
> there.

Even if there isn't an actual race, the comment is dead wrong.  I'm
reverting the following three patches.  Let's try again later.

  7e381b0eb1 ("cgroup: Drop task_lock(parent) on cgroup_fork()")
  7e3aa30ac8 ("cgroup: Remove task_lock() from cgroup_post_fork()")
  c84cdf75cc ("cgroup: Remove unnecessary task_lock before fetching css_set on migration")

Thanks.

-- 
tejun
