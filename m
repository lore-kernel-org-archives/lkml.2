Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1JBTXJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:23:09 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:7294 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab1JBTWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:22:37 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com,
        Glauber Costa <glommer@parallels.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: [PATCH 10/10] Change CPUACCT to default n
Date: Sun,  2 Oct 2011 23:21:27 +0400
Message-Id: <1317583287-18300-11-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1317583287-18300-1-git-send-email-glommer@parallels.com>
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>
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
index c4a6e14..08adcd4 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -592,3 +592,11 @@ Why:    In 3.0, we can now autodetect internal 3G device and already have
 	interface that was used by acer-wmi driver. It will replaced by
 	information log when acer-wmi initial.
 Who:    Lee, Chun-Yi <jlee@novell.com>
+
+----------------------------
+What:	cpuacct cgroup	
+When:	3.5
+Why:	Same functionality is provided by the CGROUP_SCHED, with a lower
+	footprint.	
+Who:	Glauber Costa <glommer@parallels.com>
+
diff --git a/init/Kconfig b/init/Kconfig
index d627783..891d6c1 100644
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
1.7.6

