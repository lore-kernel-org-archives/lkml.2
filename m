Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab2E3Jv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 05:51:57 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:3000 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab2E3Jvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 05:51:53 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Paul Turner <pjt@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
        handai.szj@gmail.com, Andrew.Phillips@lmax.com,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH v3 0/6] per cgroup /proc/stat statistics
Date: Wed, 30 May 2012 13:48:31 +0400
Message-Id: <1338371317-5980-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This is a rework of my v2 series taking into account Paul
Turner's comments. All the series is the same except for
the patch that collets nr_switches that is now completely reworked.

It is out of schedule(), relegated to a scheduler hook. Only difference
from Paul's suggestion is that I added a new one, instead of messing with
put_prev_task + pick_next_task pairs. In the patchset that adds it,
I'll try to argue for my solution.

Hope this is acceptable, and please let me know of any other concerns.

v2:
* completely reworked nr_switches gathering
* separated per-se sleep_start to be more clear about it

Glauber Costa (6):
  measure exec_clock for rt sched entities
  account guest time per-cgroup as well.
  expose fine-grained per-cpu data for cpuacct stats
  add a new scheduler hook for context switch
  Also record sleep start for a task group
  expose per-taskgroup schedstats in cgroup

 include/linux/sched.h |    1 +
 kernel/sched/core.c   |  166 +++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched/fair.c   |   42 ++++++++++++-
 kernel/sched/rt.c     |   20 ++++++
 kernel/sched/sched.h  |    6 ++
 5 files changed, 228 insertions(+), 7 deletions(-)

-- 
1.7.10.2

