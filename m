Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab0HWKqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 06:46:25 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53497 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589Ab0HWKqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 06:46:22 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Robert Richter <robert.richter@amd.com>, Will Deacon <will.deacon@arm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/3] sh: Accessor functions for the sh_pmu state
Date: Mon, 23 Aug 2010 11:46:19 +0100
Message-Id: <1282560381-7700-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.2.2.162.g5cba1
In-Reply-To: <1282560381-7700-1-git-send-email-matt@console-pimps.org>
References: <1282560381-7700-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce some accessor functions for getting at the name and number of
counters of the current sh_pmu instance.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 arch/sh/include/asm/perf_event.h |    2 ++
 arch/sh/kernel/perf_event.c      |   13 +++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/sh/include/asm/perf_event.h b/arch/sh/include/asm/perf_event.h
index 3d0c9f3..5b7fa84 100644
--- a/arch/sh/include/asm/perf_event.h
+++ b/arch/sh/include/asm/perf_event.h
@@ -25,6 +25,8 @@ struct sh_pmu {
 extern int register_sh_pmu(struct sh_pmu *);
 extern int reserve_pmc_hardware(void);
 extern void release_pmc_hardware(void);
+extern int sh_pmu_num_events(void);
+extern const char *sh_pmu_name(void);
 
 static inline void set_perf_event_pending(void)
 {
diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 7a3dc35..086f788 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -60,6 +60,19 @@ static inline int sh_pmu_initialized(void)
 }
 
 /*
+ * Return the number of events for the current sh_pmu.
+ */
+int sh_pmu_num_events(void)
+{
+	return sh_pmu->num_events;
+}
+
+const char *sh_pmu_name(void)
+{
+	return sh_pmu->name;
+}
+
+/*
  * Release the PMU if this is the last perf_event.
  */
 static void hw_perf_event_destroy(struct perf_event *event)
-- 
1.7.2.1

