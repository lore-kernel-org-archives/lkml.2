Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab0DVQKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:10:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:35468 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab0DVQKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:10:31 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       oleg@redhat.com, peterz@infradead.org, rusty@rustcorp.com.au,
       sivanich@sgi.com, heiko.carstens@de.ibm.com, dipankar@in.ibm.com,
       josh@freedesktop.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, arjan@linux.intel.com,
       torvalds@linux-foundation.org
Subject: [PATCHSET sched/core] cpu_stop: implement and use cpu_stop
Date: Thu, 22 Apr 2010 18:09:10 +0200
Message-Id: <1271952554-22368-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 22 Apr 2010 16:09:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

cpu_hog has been renamed to cpu_stop and moved into
kernel/stop_machine.c per Peter Zijlstra's suggestion.  This patchset
is feature-wise identical to the second take of cpuhog[L].  The only
changes are the rename, relocation and refresh against the current
sched/core.

The following API renames took place.

- hog_one_cpu()		-> stop_one_cpu()
- hog_one_cpu_nowait()	-> stop_one_cpu_nowait()
- hog_cpus()		-> stop_cpus()
- try_hog_cpus()	-> try_stop_cpus()
- *_hog() callbacks	-> *_cpu_stop()

Internal names have been renamed accordingly.  e.g. cpuhog thread
became cpu_stopper thread and so on.

This patchset contains the following four patches.

 0001-cpu_stop-implement-stop_cpu-s.patch
 0002-stop_machine-reimplement-using-cpu_stop.patch
 0003-scheduler-replace-migration_thread-with-cpu_stop.patch
 0004-scheduler-kill-paranoia-check-in-synchronize_sched_e.patch

The patches are against the current linux-2.6-tip/sched/core
(09a40af5240de02d848247ab82440ad75b31ab11) and are available in the
following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cpu_stop

I retained the original acked/reviewed-by's as the changes are mostly
cosmetic.  If you disagree, please let me know.  I'll try to push this
through sched/core again once Peter acks.

diffstat follows.

 Documentation/RCU/torture.txt |   10 
 arch/s390/kernel/time.c       |    1 
 drivers/xen/manage.c          |   14 -
 include/linux/rcutiny.h       |    2 
 include/linux/rcutree.h       |    1 
 include/linux/stop_machine.h  |   59 ++--
 kernel/cpu.c                  |    8 
 kernel/module.c               |   14 -
 kernel/rcutorture.c           |    2 
 kernel/sched.c                |  271 +++------------------
 kernel/sched_fair.c           |   42 ++-
 kernel/stop_machine.c         |  525 ++++++++++++++++++++++++++++++++----------
 12 files changed, 514 insertions(+), 435 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/962635
