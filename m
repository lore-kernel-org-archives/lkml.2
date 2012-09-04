Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab2IDOVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:21:50 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:19542 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757157Ab2IDOVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:21:49 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>, davej@redhat.com,
        ben@decadent.org.uk, a.p.zijlstra@chello.nl, pjt@google.com,
        lennart@poettering.net, kay.sievers@vrfy.org, tj@kernel.org
Subject: [RFC 0/5] forced comounts for cgroups.
Date: Tue,  4 Sep 2012 18:18:15 +0400
Message-Id: <1346768300-10282-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As we have been extensively discussing, the cost and pain points for cgroups
come from many places. But at least one of those is the arbitrary nature of
hierarchies. Many people, including at least Tejun and me would like this to go
away altogether. Problem so far, is breaking compatiblity with existing setups

I am proposing here a default-n Kconfig option that will guarantee that the cpu
cgroups (for now) will be comounted. I started with them because the
cpu/cpuacct division is clearly the worst offender. Also, the default-n is here
so distributions will have time to adapt: Forcing this flag to be on without
userspace changes will just lead to cgroups failing to mount, which we don't
want.

Although I've tested it and it works, I haven't compile-tested all possible
config combinations. So this is mostly for your eyes. If this gets traction,
I'll submit it properly, along with any changes that you might require.

Thanks.

Glauber Costa (5):
  cgroup: allow some comounts to be forced.
  sched: adjust exec_clock to use it as cpu usage metric
  sched: do not call cpuacct_charge when cpu and cpuacct are comounted
  cpuacct: do not gather cpuacct statistics when not mounted
  sched: add cpusets to comounts list

 include/linux/cgroup.h |   6 ++
 init/Kconfig           |  23 ++++++++
 kernel/cgroup.c        |  29 +++++++++-
 kernel/cpuset.c        |   4 ++
 kernel/sched/core.c    | 149 +++++++++++++++++++++++++++++++++++++++++++++----
 kernel/sched/rt.c      |   1 +
 kernel/sched/sched.h   |  20 ++++++-
 7 files changed, 220 insertions(+), 12 deletions(-)

-- 
1.7.11.4

