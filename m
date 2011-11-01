Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab1KAVVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:21:40 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:43516 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071Ab1KAVVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:21:35 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        fweisbec@gmail.com, Glauber Costa <glommer@parallels.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: [PATCH v2 14/14] Change CPUACCT to default n
Date: Tue,  1 Nov 2011 19:19:20 -0200
Message-Id: <1320182360-20043-15-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320182360-20043-1-git-send-email-glommer@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we're providing all cpuacct capability in cpu cgroup,
default CPUACCT to n. We still maintain it for compatiblity for
anyone that need an independent set of tasks to be managed by it
relatively to cpu cgroup, but encourage the use of cpucgroup for that.

Proposing schedule of deprecation for 3.5

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Balbir Singh <bsingharora@gmail.com>
---
 Documentation/feature-removal-schedule.txt |    8 ++++++++
 init/Kconfig                               |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index d5ac362..91165fe 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -609,3 +609,11 @@ When:	3.5
 Why:	The iwlagn module has been renamed iwlwifi.  The alias will be around
 	for backward compatibility for several cycles and then dropped.
 Who:	Don Fry <donald.h.fry@intel.com>
+
+----------------------------
+
+What:	cpuacct cgroup
+When:	3.5
+Why:	Same functionality is provided by the CGROUP_SCHED, with a lower
+	footprint.
+Who:	Glauber Costa <glommer@parallels.com>
diff --git a/init/Kconfig b/init/Kconfig
index 31ba0fd..d3d958b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -626,6 +626,7 @@ config PROC_PID_CPUSET
 
 config CGROUP_CPUACCT
 	bool "Simple CPU accounting cgroup subsystem"
+	default n
 	help
 	  Provides a simple Resource Controller for monitoring the
 	  total CPU consumed by the tasks in a cgroup.
-- 
1.7.6.4

