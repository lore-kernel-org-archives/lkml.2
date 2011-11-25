Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab1KYBeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 20:34:22 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:33316 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab1KYBeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 20:34:21 -0500
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: lizf@cn.fujitsu.com, daniel.lezcano@free.fr, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, pjt@google.com, cgroups@vger.kernel.org,
        devel@openvz.org
Subject: [PATCH 0/4] cpuacct cleanup
Date: Thu, 24 Nov 2011 23:33:22 -0200
Message-Id: <1322184806-20421-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Leaving aside all the hierarchy walk discussion, I tried to come up
with a series that concentrates only the basic points of it all.
I think we benefit from having it independently of the rest of the work:
in general (comments on the specifics welcome) cpuacct is made more naturally
integrated with the scheduler, and the statistics it collects are now exactly
the same as the system-wide ones for the root cgroup case. I think quite similar
can be done with cpuusage by associating the root cgroup with the main runqueues,
but this here is just me scratching my own itches - we can do it later.

Please let me know if this is acceptable.

Glauber Costa (4):
  Change cpustat fields to an array.
  Reuse cgroup's parent pointer
  Move part of cpuacct code
  cpuacct.stat: re-use scheduler statistics for the root cgroup

 arch/s390/appldata/appldata_os.c       |   16 +-
 arch/x86/include/asm/i387.h            |    2 +-
 drivers/cpufreq/cpufreq_conservative.c |   38 ++---
 drivers/cpufreq/cpufreq_ondemand.c     |   38 ++---
 drivers/macintosh/rack-meter.c         |    8 +-
 fs/proc/stat.c                         |   63 ++++----
 fs/proc/uptime.c                       |    4 +-
 include/linux/kernel_stat.h            |   36 +++--
 kernel/sched.c                         |  270 ++++++++++++++++++--------------
 9 files changed, 252 insertions(+), 223 deletions(-)

-- 
1.7.6.4

