Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1GUTbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:31:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:50318 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab1GUTbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:31:07 -0400
Date: Thu, 21 Jul 2011 19:30:50 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@gmail.com>
Message-ID: <tip-f53173e47dee5f7514d264796bec58d43ed0f67f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, tglx@linutronix.de, gorcunov@gmail.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, tglx@linutronix.de, gorcunov@gmail.com,
        mingo@elte.hu
In-Reply-To: <20110721160625.GX7492@sun>
References: <20110721160625.GX7492@sun>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, perf: P4 PMU - Fix typos in comments and style cleanup
Git-Commit-ID: f53173e47dee5f7514d264796bec58d43ed0f67f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 19:30:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f53173e47dee5f7514d264796bec58d43ed0f67f
Gitweb:     http://git.kernel.org/tip/f53173e47dee5f7514d264796bec58d43ed0f67f
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Thu, 21 Jul 2011 20:06:25 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 20:41:54 +0200

x86, perf: P4 PMU - Fix typos in comments and style cleanup

This patch:

 - fixes typos in comments and clarifies the text
 - renames obscure p4_event_alias::original and ::alter members to
   ::original and ::alternative as appropriate
 - drops parenthesis from the return of p4_get_alias_event()

No functional changes.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Link: http://lkml.kernel.org/r/20110721160625.GX7492@sun
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/perf_event_p4.h |    2 +-
 arch/x86/kernel/cpu/perf_event_p4.c  |   66 +++++++++++++++------------------
 2 files changed, 31 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index 4d86c86..4f7e67e 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -133,7 +133,7 @@
 
 /*
  * In case of event aliasing we need to preserve some
- * caller bits otherwise the mapping won't be complete.
+ * caller bits, otherwise the mapping won't be complete.
  */
 #define P4_CONFIG_EVENT_ALIAS_MASK			  \
 	(p4_config_pack_escr(P4_CONFIG_MASK_ESCR)	| \
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 8b7a0c3..7809d2b 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -571,35 +571,34 @@ static __initconst const u64 p4_hw_cache_event_ids
 };
 
 /*
- * Because of Netburst being quite restricted in now
- * many same events can run simultaneously, we use
- * event aliases, ie different events which have the
- * same functionallity but use non-intersected resources
- * (ESCR/CCCR/couter registers). This allow us to run
- * two or more semi-same events together. It is done
- * transparently to a user space.
+ * Because of Netburst being quite restricted in how many
+ * identical events may run simultaneously, we introduce event aliases,
+ * ie the different events which have the same functionality but
+ * utilize non-intersected resources (ESCR/CCCR/counter registers).
  *
- * Never set any cusom internal bits such as P4_CONFIG_HT,
- * P4_CONFIG_ALIASABLE or bits for P4_PEBS_METRIC, they are
- * either up-to-dated automatically either not appliable
- * at all.
+ * This allow us to relax restrictions a bit and run two or more
+ * identical events together.
  *
- * And be really carefull choosing aliases!
+ * Never set any custom internal bits such as P4_CONFIG_HT,
+ * P4_CONFIG_ALIASABLE or bits for P4_PEBS_METRIC, they are
+ * either up to date automatically or not applicable at all.
  */
 struct p4_event_alias {
-	u64 orig;
-	u64 alter;
+	u64 original;
+	u64 alternative;
 } p4_event_aliases[] = {
 	{
 		/*
-		 * Non-halted cycles can be substituted with
-		 * non-sleeping cycles (see Intel SDM Vol3b for
-		 * details).
+		 * Non-halted cycles can be substituted with non-sleeping cycles (see
+		 * Intel SDM Vol3b for details). We need this alias to be able
+		 * to run nmi-watchdog and 'perf top' (or any other user space tool
+		 * which is interested in running PERF_COUNT_HW_CPU_CYCLES)
+		 * simultaneously.
 		 */
-	.orig	=
+	.original	=
 		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_GLOBAL_POWER_EVENTS)		|
 				    P4_ESCR_EMASK_BIT(P4_EVENT_GLOBAL_POWER_EVENTS, RUNNING)),
-	.alter	=
+	.alternative	=
 		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_EXECUTION_EVENT)		|
 				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS0)|
 				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS1)|
@@ -620,25 +619,21 @@ static u64 p4_get_alias_event(u64 config)
 	int i;
 
 	/*
-	 * Probably we're lucky and don't have to do
-	 * matching over all config bits.
+	 * Only event with special mark is allowed,
+	 * we're to be sure it didn't come as malformed
+	 * RAW event.
 	 */
 	if (!(config & P4_CONFIG_ALIASABLE))
 		return 0;
 
 	config_match = config & P4_CONFIG_EVENT_ALIAS_MASK;
 
-	/*
-	 * If an event was previously swapped to the alter config
-	 * we should swap it back otherwise contnention on registers
-	 * will return back.
-	 */
 	for (i = 0; i < ARRAY_SIZE(p4_event_aliases); i++) {
-		if (config_match == p4_event_aliases[i].orig) {
-			config_match = p4_event_aliases[i].alter;
+		if (config_match == p4_event_aliases[i].original) {
+			config_match = p4_event_aliases[i].alternative;
 			break;
-		} else if (config_match == p4_event_aliases[i].alter) {
-			config_match = p4_event_aliases[i].orig;
+		} else if (config_match == p4_event_aliases[i].alternative) {
+			config_match = p4_event_aliases[i].original;
 			break;
 		}
 	}
@@ -646,8 +641,7 @@ static u64 p4_get_alias_event(u64 config)
 	if (i >= ARRAY_SIZE(p4_event_aliases))
 		return 0;
 
-	return config_match |
-		(config & P4_CONFIG_EVENT_ALIAS_IMMUTABLE_BITS);
+	return config_match | (config & P4_CONFIG_EVENT_ALIAS_IMMUTABLE_BITS);
 }
 
 static u64 p4_general_events[PERF_COUNT_HW_MAX] = {
@@ -1229,9 +1223,9 @@ static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign
 
 again:
 		/*
-		 * Aliases are swappable so we may hit circular
-		 * lock if both original config and alias need
-		 * resources (MSR registers) which already busy.
+		 * It's possible to hit a circular lock
+		 * between original and alternative events
+		 * if both are scheduled already.
 		 */
 		if (pass > 2)
 			goto done;
@@ -1251,7 +1245,7 @@ again:
 		cntr_idx = p4_next_cntr(thread, used_mask, bind);
 		if (cntr_idx == -1 || test_bit(escr_idx, escr_mask)) {
 			/*
-			 * Probably an event alias is still available.
+			 * Check whether an event alias is still available.
 			 */
 			config_alias = p4_get_alias_event(hwc->config);
 			if (!config_alias)
