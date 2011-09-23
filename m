Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1IWWW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:22:56 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:35614 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab1IWWWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:22:55 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com
Subject: [RFD 0/9] per-cgroup /proc/stat statistics
Date: Fri, 23 Sep 2011 19:20:23 -0300
Message-Id: <1316816432-9237-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since I've sent already a RFC about it, I am sending now a RFD.
If you eager for meaning, this can then be a "Request for Doctors",
since Peter is likely to have a heart attack now.

So here's the deal:

* My main goal here was to demonstrate that we can avoid double accounting
  in a lot of places. So what I did was getting rid of the original and first
  kstat mechanism, and use only cgroups accounting for that. Since the parent
  is always updated, the original stats are the one for the root cgroup.
* I believe that all those cpu cgroups are confusing and should be unified. Not
  that we can simply get rid of it, but my goal here is to provide all the
  information they do, in cpu cgroup. If the set of tasks needed for accounting
  is not independent of the ones in cpu cgroup, we can avoid double accounting
  for that. I default cpuacct to n, but leave it to people that wants to use it
  alone. 
* Well, I'm also doing what I was doing originally: Providing a per-cgroup version
  of the /proc/stat file.


Glauber Costa (9):
  Change cpustat fields to an array.
  Move /proc/stat logic inside sched.c
  Display /proc/stat information per cgroup
  Make total_forks per-cgroup
  per-cgroup boot time
  Report steal time for cgroup
  provide a version of cpuacct statistics inside cpu cgroup
  provide a version of cpuusage statistics inside cpu cgroup
  Change CPUACCT to default n

 fs/proc/stat.c              |  117 +---------
 fs/proc/uptime.c            |    2 +-
 include/linux/kernel_stat.h |   48 +++--
 include/linux/sched.h       |    5 +
 init/Kconfig                |    1 +
 kernel/fork.c               |    9 +-
 kernel/sched.c              |  595 +++++++++++++++++++++++++++++++++++--------
 kernel/sched_fair.c         |    2 +-
 kernel/sched_rt.c           |    2 +-
 9 files changed, 530 insertions(+), 251 deletions(-)

-- 
1.7.6

