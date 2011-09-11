Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab1IKDfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 23:35:45 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49449 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab1IKDfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 23:35:44 -0400
Date: Sun, 11 Sep 2011 12:35:36 +0900
From: Tejun Heo <htejun@gmail.com>
To: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCHSET cgroup] extend threadgroup locking
Message-ID: <20110911033536.GO29319@htj.dyndns.org>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315159280-25032-1-git-send-email-htejun@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 03:01:16AM +0900, Tejun Heo wrote:
> Hello,
> 
> cgroup currently only blocks new threads from joining the target
> threadgroup during migration, and on-going migration could race
> against exec and exit leading to interesting problems - the symmetry
> between various attach methods, task exiting during method execution,
> ->exit() racing against attach methods, migrating task switching basic
> properties during exec and so on.
> 
> This patchset extends threadgroup locking such that it covers all
> operations which can alter the threadgroup - fork, exit and exec, and
> update cgroup to take advantage of it.  rwsem read ops are added to
> exit path but exec is excluded by grabbing the existing
> cred_guard_mutex from threadgroup locking helper.
> 
> This makes threadgroup locking complete and resolves cgroup issues
> stemming from the target taskset being unstable.
> 
> This patchset is on top of the current pm-freezer + "freezer: fixes &
> simplifications" patchset and contains the following four patches.
> Patch list and diffstat follow.
> 
> Thanks.
> 
>  [PATCH 1/4] cgroup: change locking order in attach_task_by_pid()
>  [PATCH 2/4] threadgroup: rename signal->threadgroup_fork_lock to
>  [PATCH 3/4] threadgroup: extend threadgroup_lock() to cover exit and
>  [PATCH 4/4] cgroup: always lock threadgroup during migration
> 
>  include/linux/init_task.h |    9 ++----
>  include/linux/sched.h     |   58 ++++++++++++++++++++++++++++---------------
>  kernel/cgroup.c           |   62 +++++++++++++++++++++-------------------------
>  kernel/exit.c             |   16 ++++++++---
>  kernel/fork.c             |    8 ++---
>  5 files changed, 88 insertions(+), 65 deletions(-)

Oops, forgot to cc Oleg on this series.

Oleg, this one definitely needs your review.  The original thread is...

  http://thread.gmane.org/gmane.linux.kernel/1187853/focus=1188347

If you want the series in mbox format, please let me know.

Thanks.

-- 
tejun
