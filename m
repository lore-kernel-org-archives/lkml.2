Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab0EaS6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 14:58:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:34880 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756921Ab0EaS6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 14:58:13 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, paulus@samba.org, acme@redhat.com
Subject: [PATCHSET sched/core] sched: prepare for cmwq, take#2
Date: Mon, 31 May 2010 20:56:35 +0200
Message-Id: <1275332199-28082-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 18:56:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the second take of repare-for-cmwq patchset.  Changes from the
first take[L] are

* consult-online-mask-instead-of-active-in-select_fallback_rq and
  implement-__set_cpus_allowed replaced by updates to when cpu_active
  and cpuset configuration are updated as suggested by Peter.

* Patch description updated in 0004 as suggested by Peter.

 0001-sched-define-and-use-CPU_PRI_-enums-for-cpu-notifier.patch
 0002-sched-adjust-when-cpu_active-and-cpuset-configuratio.patch
 0003-sched-refactor-try_to_wake_up.patch
 0004-sched-add-hooks-for-workqueue.patch

This patchset is available in the following git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git sched-wq

and contains the following changes.

 include/linux/cpu.h        |   25 ++++++
 include/linux/perf_event.h |    2 
 include/linux/sched.h      |    1 
 kernel/cpu.c               |    6 -
 kernel/cpuset.c            |   46 +++++++-----
 kernel/fork.c              |    2 
 kernel/sched.c             |  169 ++++++++++++++++++++++++++++++++++-----------
 kernel/workqueue_sched.h   |   16 ++++
 8 files changed, 203 insertions(+), 64 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/984967
