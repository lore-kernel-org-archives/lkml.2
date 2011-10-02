Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1JBTW1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:22:27 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:37826 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab1JBTWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:22:20 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com
Subject: [PATCH 00/10] Per-cgroup /proc/stat information
Date: Sun,  2 Oct 2011 23:21:17 +0400
Message-Id: <1317583287-18300-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

So after two rounds of initial comments, this is my first
real shot at it. I am trying to address all previous comments,
but if one of them is left out, just let me know.

Now, cpustat is just an array of u64s. I am also proposing
we deprecate CPUACCT based on the current work. But that is
totally open to discussion. cpuacct guys, please chime in.

Hope you enjoy

Glauber Costa (10):
  trivial: initialize root cgroup's sibling list
  Change cpustat fields to an array.
  Move /proc/stat logic inside sched.c
  Display /proc/stat information per cgroup
  Make total_forks per-cgroup
  per-cgroup boot time
  Report steal time for cgroup
  provide a version of cpuacct statistics inside cpu cgroup
  provide a version of cpuusage statistics inside cpu cgroup
  Change CPUACCT to default n

 Documentation/feature-removal-schedule.txt |    8 +
 fs/proc/stat.c                             |  117 +------
 fs/proc/uptime.c                           |    2 +-
 include/linux/kernel_stat.h                |   50 ++-
 include/linux/sched.h                      |    5 +
 init/Kconfig                               |    1 +
 kernel/fork.c                              |    7 +-
 kernel/sched.c                             |  603 ++++++++++++++++++++++------
 kernel/sched_fair.c                        |    2 +-
 kernel/sched_rt.c                          |    2 +-
 10 files changed, 538 insertions(+), 259 deletions(-)

-- 
1.7.6

