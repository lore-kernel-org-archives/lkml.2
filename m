Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab2G0WnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 18:43:13 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64773 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2G0WnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 18:43:10 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 1/4] Revert "x86 idle APM: deprecate CONFIG_APM_CPU_IDLE" to prepare for actual removal
Date: Fri, 27 Jul 2012 18:42:52 -0400
Message-Id: <06ed885aac76cc68bd1ca1f32c8dcab7bcca1940.1343428708.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343428975-3897-1-git-send-email-lenb@kernel.org>
References: <1343428975-3897-1-git-send-email-lenb@kernel.org>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Remove warning that perplex users about removal of CONFIG_APM_CPU_IDLE in 2012.
This allows applying the original removal patch cleanly.

In retrospect, adding this warning was a mistake.
We should have shipped the removal patch 16 months ago.

cc: x86@kernel.org
cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/feature-removal-schedule.txt | 10 ++++++++++
 arch/x86/kernel/apm_32.c                   |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 5540615..fc505c1 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -14,6 +14,16 @@ Who:	Len Brown <len.brown@intel.com>

 ---------------------------

+What:	CONFIG_APM_CPU_IDLE, and its ability to call APM BIOS in idle
+When:	2012
+Why:	This optional sub-feature of APM is of dubious reliability,
+	and ancient APM laptops are likely better served by calling HLT.
+	Deleting CONFIG_APM_CPU_IDLE allows x86 to stop exporting
+	the pm_idle function pointer to modules.
+Who:	Len Brown <len.brown@intel.com>
+
+----------------------------
+
 What:	x86_32 "no-hlt" cmdline param
 When:	2012

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 0e4f24c..4c4ac32 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -359,6 +359,7 @@ struct apm_user {
  * idle percentage above which bios idle calls are done
  */
 #ifdef CONFIG_APM_CPU_IDLE
+#warning deprecated CONFIG_APM_CPU_IDLE will be deleted in 2012
 #define DEFAULT_IDLE_THRESHOLD	95
 #else
 #define DEFAULT_IDLE_THRESHOLD	100
@@ -902,6 +903,7 @@ static void apm_cpu_idle(void)
 	unsigned int jiffies_since_last_check = jiffies - last_jiffies;
 	unsigned int bucket;

+	WARN_ONCE(1, "deprecated apm_cpu_idle will be deleted in 2012");
 recalc:
 	if (jiffies_since_last_check > IDLE_CALC_LIMIT) {
 		use_apm_idle = 0;
--
1.7.12.rc0

Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/feature-removal-schedule.txt | 10 ----------
 arch/x86/kernel/apm_32.c                   |  2 --
 2 files changed, 12 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 56000b3..bb4f9e0 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -13,16 +13,6 @@ Who:	Jim Cromie <jim.cromie@gmail.com>, Jason Baron <jbaron@redhat.com>
 
 ---------------------------
 
-What:	CONFIG_APM_CPU_IDLE, and its ability to call APM BIOS in idle
-When:	2012
-Why:	This optional sub-feature of APM is of dubious reliability,
-	and ancient APM laptops are likely better served by calling HLT.
-	Deleting CONFIG_APM_CPU_IDLE allows x86 to stop exporting
-	the pm_idle function pointer to modules.
-Who:	Len Brown <len.brown@intel.com>
-
-----------------------------
-
 What:	x86_32 "no-hlt" cmdline param
 When:	2012
 Why:	remove a branch from idle path, simplify code used by everybody.
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 07b0c0d..3a89ca3 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -358,7 +358,6 @@ struct apm_user {
  * idle percentage above which bios idle calls are done
  */
 #ifdef CONFIG_APM_CPU_IDLE
-#warning deprecated CONFIG_APM_CPU_IDLE will be deleted in 2012
 #define DEFAULT_IDLE_THRESHOLD	95
 #else
 #define DEFAULT_IDLE_THRESHOLD	100
@@ -902,7 +901,6 @@ static void apm_cpu_idle(void)
 	unsigned int jiffies_since_last_check = jiffies - last_jiffies;
 	unsigned int bucket;
 
-	WARN_ONCE(1, "deprecated apm_cpu_idle will be deleted in 2012");
 recalc:
 	if (jiffies_since_last_check > IDLE_CALC_LIMIT) {
 		use_apm_idle = 0;
-- 
1.7.12.rc0

