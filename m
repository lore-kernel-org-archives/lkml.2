Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935144Ab1JEQ40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:56:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:52172 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934948Ab1JEQzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:55:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,492,1312182000"; 
   d="scan'208";a="23558378"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
        "Tony Luck" <tony.luck@intel.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <lenb@kernel.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 8/8] kernel/cpu.c: Define bsp_hotpluggable variable
Date: Wed,  5 Oct 2011 09:39:19 -0700
Message-Id: <1317832759-10223-9-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

This gloable variable controls BSP (aka CPU0) hotplug. If set, BSP is
hotpluggable. By default, it's 0. On X86, kernel option bsp_hotpluggable sets
the variable as 1.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 include/linux/cpu.h |    2 ++
 kernel/cpu.c        |    5 +++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index b1a635a..1b0b1ad 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -172,6 +172,8 @@ extern void put_online_cpus(void);
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
 int cpu_down(unsigned int cpu);
 
+extern int bsp_hotpluggable;
+
 #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
 extern void cpu_hotplug_driver_lock(void);
 extern void cpu_hotplug_driver_unlock(void);
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 12b7458..65d1a13 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -43,6 +43,11 @@ static int cpu_hotplug_disabled;
 
 #ifdef CONFIG_HOTPLUG_CPU
 
+/*
+ * If set, BSP (aka CPU0) can be onlined/offlined. By default, it's not set.
+ */
+int bsp_hotpluggable;
+
 static struct {
 	struct task_struct *active_writer;
 	struct mutex lock; /* Synchronizes accesses to refcount, */
-- 
1.6.0.3

