Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab0KIUsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:48:41 -0500
Received: from nm5.bullet.mail.ukl.yahoo.com ([217.146.182.226]:34904 "HELO
	nm5.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754970Ab0KIUsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:48:39 -0500
X-Yahoo-Newman-Id: 336771.88715.bm@omp1002.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=DKIM-Signature:Message-ID:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Cc:Subject;
  b=Qk4UO0yYKTKf5p/+vE9w/X6O271ooVUyFx7q7MRmrq+amMIVP10uASpqX6rVU1RpK+wgcif+7uWLgFs1T5w7i/XGiBGCYL73ZMw7Ap1tQX63uGQ8geO8eJGg/7WzIRCAx4LP3t/CuyNI7eYTN2TrJ1bS2+pfpYKVuERCnuzz6VQ=  ;
Message-ID: <285897.77932.qm@smtp128.mail.ukl.yahoo.com>
X-Yahoo-SMTP: zgdcvJ6swBBcTOk5fgveL37ak9AQxYCP7GdO
X-YMail-OSG: tE6OlssVM1m.gUowzGKNTSpr6KLySnMRY.yylnuw9vOXI9_
 vMXkLjdIVmuJca1xDWrMd7Q9lHSWPMsjsXXQMVO7KjByfRu434FjjOuOMr4P
 jKllR0KHfQPlhxu3__vN.vWr_MQUCPNjtSQrMa4G32knSL2CHztoZy.ads7Z
 aFEfJUboDIfBCX6RstNrAsYKDH6jnJDgxB3X2kJ4gTxY.Ztowxk4G6mIhhte
 vWey0VAwVfhqzqaRPhgvWcC3dJlXkTdpEYUUkH7HxhaZ7NhRjZKp7B3sRkMt
 Qqq4Mcwgtumq0iAASMQwsjTzpbrIqZzTd5m8-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 09 Nov 2010 21:48:49 +0100
From: Lionel Debroux <lionel_debroux@yahoo.fr>
To: kernel-janitors@vger.kernel.org
Cc: Kees Cook <kees.cook@canonical.com>, Emese Revfy <re.emese@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3 v2] hibernation: constify platform_hibernation_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch against mainline.

Changes since v1: added one hunk; no longer adding "const" qualifier to
pointers in platform_hibernation_ops after seeing
b4144e4f6e3b448d322095ca08af393682a69e33.
---

Subject: [PATCH 3/3] hibernation: constify platform_hibernation_ops

Derived from the grsecurity patch.

Signed-off-by: Lionel Debroux <lionel_debroux@yahoo.fr>
---
 drivers/acpi/sleep.c     |    4 ++--
 include/linux/suspend.h  |    4 ++--
 kernel/power/hibernate.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index acfa8c3..ba1caf7 100644
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
index bb98383..f45f3cc 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
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
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 657272e..491b81a 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -51,14 +51,14 @@ enum {
 
 static int hibernation_mode = HIBERNATION_SHUTDOWN;
 
-static struct platform_hibernation_ops *hibernation_ops;
+static const struct platform_hibernation_ops *hibernation_ops;
 
 /**
  * hibernation_set_ops - set the global hibernate operations
  * @ops: the hibernation operations to use in subsequent hibernation transitions
  */
 
-void hibernation_set_ops(struct platform_hibernation_ops *ops)
+void hibernation_set_ops(const struct platform_hibernation_ops *ops)
 {
 	if (ops && !(ops->begin && ops->end &&  ops->pre_snapshot
 	    && ops->prepare && ops->finish && ops->enter && ops->pre_restore
-- 
1.7.3.2.161.g3089c

