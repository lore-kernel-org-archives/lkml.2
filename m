Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab0ESBac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:30:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8276 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab0ESBab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:30:31 -0400
From: Mike Chan <mike@android.com>
Cc: khilman@deeprootsystems.com, menage@google.com, balbir@in.ibm.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Mike Chan <mike@android.com>
Subject: [PATCH 0/4] Enable cpu frequency and power tracking for cpuacct cgroup
Date: Tue, 18 May 2010 18:30:16 -0700
Message-Id: <1274232620-23003-1-git-send-email-mike@android.com>
X-Mailer: git-send-email 1.7.0.1
X-System-Of-Record: true
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rebased onto  linux-next.

This patch series introduces cpu frequency and power tracking for cpuacct
cgroups. A similar patch set was discussed a while back and it was concluded
that due to varying architectures (ppc, x86 with overboot) you cannot account
for frequencies and their power consumption generically in sched.c, thus we
have platform specific hooks the cpuacct can call into (if available).

I've implemented all the necessary hooks for OMAP architecture as an example.
For the OMAP folks, I?m not sure what the state of the OPP API in mainline,
as most of my original work was based off of the omap-pm branch.


Mike Chan (4):
  scheduler: cpuacct: Enable platform hooks to track cpuusage for CPU
    frequencies
  omap: cpu: Implement callbacks for cpu frequency tracking in cpuacct
  scheduler: cpuacct: Enable platform callbacks for cpuacct power
    tracking
  omap: cpu: Power tracking support for cgroup cpuacct

 Documentation/cgroups/cpuacct.txt         |    7 ++
 arch/arm/plat-omap/cpu-omap.c             |   87 ++++++++++++++++++++++++++++-
 arch/arm/plat-omap/include/plat/omap-pm.h |    1 +
 include/linux/cpuacct.h                   |   43 ++++++++++++++
 kernel/sched.c                            |   69 +++++++++++++++++++++++
 5 files changed, 206 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/cpuacct.h

Signed-off-by: Mike Chan <mike@android.com>
