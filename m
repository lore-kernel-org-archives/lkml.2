Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1HZIFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 04:05:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57374 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab1HZIFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 04:05:12 -0400
Message-ID: <4E5753D3.9080500@cn.fujitsu.com>
Date: Fri, 26 Aug 2011 16:05:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: rjw@sisk.pl, paul@paulmenage.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        fweisbec@gmail.com, matthltc@us.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCHSET] cgroup: introduce cgroup_taskset and consolidate subsys
 methods, take#2
References: <1314312192-26885-1-git-send-email-tj@kernel.org>
In-Reply-To: <1314312192-26885-1-git-send-email-tj@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-26 16:04:05,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-26 16:04:10,
	Serialize complete at 2011-08-26 16:04:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> This is the second take of cgroup_taskset patchset.  This patchset
> introduces cgroup_taskset along with some accessors and iterator,
> updates methods to use it, consolidates usages and drops superflous
> methods.  For more info, please read the head message and discussions
> from the last take[L].
> 
> Changes from the last take[L] are mostly minor.
> 
> * Acked-by's added
> * patch contamination fixed
> * local variable renamed
> * documentation updated
> 
> It contains the following six patches.
> 
>  0001-cgroup-subsys-attach_task-should-be-called-after-mig.patch
>  0002-cgroup-improve-old-cgroup-handling-in-cgroup_attach_.patch
>  0003-cgroup-introduce-cgroup_taskset-and-use-it-in-subsys.patch
>  0004-cgroup-don-t-use-subsys-can_attach_task-or-attach_ta.patch
>  0005-cgroup-cpuset-don-t-use-ss-pre_attach.patch
>  0006-cgroup-kill-subsys-can_attach_task-pre_attach-and-at.patch

This is really nice.

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

> 
> and is based on the current linux-pm/pm-freezer (7b5b95b3f5 "freezer:
> remove should_send_signal() and update frozen()"), and available in
> the following git tree.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git freezer
> 
> Any ideas on how to route these patches?  If we float these in -mm,
> further freezer patches would have to be in -mm too which in turn will
> force job control patches depending on them to -mm too.  It would be
> really nice if we can find a stable git branch to host these.  Routing
> through pm-freezer might not be such a bad idea either, I think.
> 

It's fine for me to route those patches through pm-freezer, since this
work is initiated and needed for the work on freezer.

> Thank you.
> 
>  Documentation/cgroups/cgroups.txt |   51 +++------
>  block/blk-cgroup.c                |   45 +++++---
>  include/linux/cgroup.h            |   31 ++++-
>  kernel/cgroup.c                   |  200 ++++++++++++++++++++++++--------------
>  kernel/cgroup_freezer.c           |   16 ---
>  kernel/cpuset.c                   |  105 +++++++++----------
>  kernel/events/core.c              |   13 +-
>  kernel/sched.c                    |   31 +++--
>  mm/memcontrol.c                   |   16 +--
>  security/device_cgroup.c          |    7 -
>  10 files changed, 294 insertions(+), 221 deletions(-)
