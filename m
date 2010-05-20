Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab0ETSmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:42:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25419 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab0ETSmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:42:38 -0400
From: Mike Chan <mike@android.com>
Cc: menage@google.com, balbir@in.ibm.com, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org, trenn@suse.de,
       khilman@deeprootsystems.com, linux-omap@vger.kernel.org,
       Mike Chan <mike@android.com>
Subject: [PATCH v2 0/3] Enable CPU frequency and power tracking in cpuacct cgroup
Date: Thu, 20 May 2010 11:42:21 -0700
Message-Id: <1274380944-20947-1-git-send-email-mike@android.com>
X-Mailer: git-send-email 1.7.0.1
X-System-Of-Record: true
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
Rebased off of Thomas Renninger's patch for cgroups_cpuacct refactoring,
which is based off of linus's tree. Thomas it might be easier to merge our
patches if you take these patches and put them in a series ontop of your
original patches (presuming there are no objections to your patch).

This patch series introduces cpu frequency and power tracking for cpuacct
cgroups. A similar patch set was discussed a while back and it was concluded
that due to varying architectures (ppc, x86 with overboot) you cannot account
for frequencies and their power consumption generically in sched.c, thus we
have platform specific hooks the cpuacct can call into (if available).

This patch series is not 3 instead of 4. I have left out the power
implementation for OMAP due to implementation conflicts in linux-next.

Mike Chan (3):
  scheduler: cpuacct: Enable platform hooks to track cpuusage for CPU
    frequencies
  scheduler: cpuacct: Enable platform callbacks for cpuacct power
    tracking
  omap: cpu: Implement callbacks for cpu frequency tracking in cpuacct

 Documentation/cgroups/cpuacct.txt |    7 ++++
 arch/arm/plat-omap/cpu-omap.c     |   67 +++++++++++++++++++++++++++++++++++-
 include/linux/cpuacct.h           |   43 +++++++++++++++++++++++
 kernel/cgroup_cpuaccount.c        |   69 +++++++++++++++++++++++++++++++++++++
 4 files changed, 185 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/cpuacct.h

 Signed-off-by: Mike Chan <mike@android.com>
