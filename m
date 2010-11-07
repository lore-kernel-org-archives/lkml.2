Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab0KGNRE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 08:17:04 -0500
Received: from nm6-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.234]:43158 "HELO
	nm6-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752471Ab0KGNRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 08:17:02 -0500
X-Yahoo-Newman-Id: 988078.14080.bm@omp1015.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=DKIM-Signature:Message-ID:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Cc:Subject;
  b=uH+4/hUtXoO3G6+o53fmklklZfL7wzwIAvYTfAooiqlQkA64+Tanvjf1HY4XnDIrEmQu8V0jhZ7RbQVWXoHIjKYwVtFNSnlXCmjspF2sEiV624rvPchfUA8wK9b/PjDSBlIE0e+AL15bkZ+WWahO/XZ0lksEcrvXcfcNHDF0P4Q=  ;
Message-ID: <927142.41127.qm@smtp141.mail.ukl.yahoo.com>
X-Yahoo-SMTP: zgdcvJ6swBBcTOk5fgveL37ak9AQxYCP7GdO
X-YMail-OSG: D9je0qYVM1l2bocq5dTBmvWUw.prIMw3_JBMZFRpKdtYAvk
 4ZDoMb9OOgX6gxjv_D1J3z7yWk4Y5j0n0ayfFlBVZhF.TgAdudpkjwKLdOQK
 CfOxO9YPLFyeVFrQYJOzigc5QzSKKIT0.WV3RwJiK3c10z_Ne2agff5hEn6B
 BfWiYNzRBXJOmIvv6WJoWqC9Mz7zvVb62WZihVZu1vO1k4AEQ4mvCUSLNGxc
 vvsEKvJJylOjfwY9twFzkKDLbUCBYaCJq5CIjsL3hto.pjXUgbOL2AH4Jz0o
 oW.OlkiIvqO49ZP2QcBgOFHkpbkjr8NEU1J4-
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 07 Nov 2010 14:10:47 +0100
From: Lionel Debroux <lionel_debroux@yahoo.fr>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] hibernation: constify platform_hibernation_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch against mainline.

---

Subject: [PATCH] hibernation: constify platform_hibernation_ops

Derived from the grsecurity patch.

Signed-off-by: Lionel Debroux <lionel_debroux@yahoo.fr>
---
 drivers/acpi/sleep.c    |    4 ++--
 include/linux/suspend.h |   24 ++++++++++++------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 721d93b..5149c9b 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -498,7 +498,7 @@ static void acpi_pm_thaw(void)
 	acpi_enable_all_runtime_gpes();
 }
 
-static struct platform_hibernation_ops acpi_hibernation_ops = {
+static const struct platform_hibernation_ops acpi_hibernation_ops = {
 	.begin = acpi_hibernation_begin,
 	.end = acpi_pm_end,
 	.pre_snapshot = acpi_pm_prepare,
@@ -541,7 +541,7 @@ static int acpi_hibernation_begin_old(void)
  * The following callbacks are used if the pre-ACPI 2.0 suspend ordering has
  * been requested.
  */
-static struct platform_hibernation_ops acpi_hibernation_ops_old = {
+static const struct platform_hibernation_ops acpi_hibernation_ops_old = {
 	.begin = acpi_hibernation_begin_old,
 	.end = acpi_pm_end,
 	.pre_snapshot = acpi_pm_pre_suspend,
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 2669751..37857e3 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -217,16 +217,16 @@ extern void mark_free_pages(struct zone *zone);
  *	platforms which require special recovery actions in that situation.
  */
 struct platform_hibernation_ops {
-	int (*begin)(void);
-	void (*end)(void);
-	int (*pre_snapshot)(void);
-	void (*finish)(void);
-	int (*prepare)(void);
-	int (*enter)(void);
-	void (*leave)(void);
-	int (*pre_restore)(void);
-	void (*restore_cleanup)(void);
-	void (*recover)(void);
+	int (* const begin)(void);
+	void (* const end)(void);
+	int (* const pre_snapshot)(void);
+	void (* const finish)(void);
+	int (* const prepare)(void);
+	int (* const enter)(void);
+	void (* const leave)(void);
+	int (* const pre_restore)(void);
+	void (* const restore_cleanup)(void);
+	void (* const recover)(void);
 };
 
 #ifdef CONFIG_HIBERNATION
@@ -245,7 +245,7 @@ extern void swsusp_set_page_free(struct page *);
 extern void swsusp_unset_page_free(struct page *);
 extern unsigned long get_safe_page(gfp_t gfp_mask);
 
-extern void hibernation_set_ops(struct platform_hibernation_ops *ops);
+extern void hibernation_set_ops(const struct platform_hibernation_ops *ops);
 extern int hibernate(void);
 extern bool system_entering_hibernation(void);
 #else /* CONFIG_HIBERNATION */
@@ -253,7 +253,7 @@ static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
 static inline void swsusp_unset_page_free(struct page *p) {}
 
-static inline void hibernation_set_ops(struct platform_hibernation_ops *ops) {}
+static inline void hibernation_set_ops(const struct platform_hibernation_ops *ops) {}
 static inline int hibernate(void) { return -ENOSYS; }
 static inline bool system_entering_hibernation(void) { return false; }
 #endif /* CONFIG_HIBERNATION */
-- 
1.7.3.2.161.g3089c


