Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab1JATYJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:24:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57259 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680Ab1JATW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:22:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Dave Martin <dave.martin@linaro.org>
Subject: [PATCH 04/11] ARM: allow building alignment.c without PROC_FS
Date: Sat,  1 Oct 2011 21:21:53 +0200
Message-Id: <1317496920-7764-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317496920-7764-1-git-send-email-arnd@arndb.de>
References: <1317496920-7764-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:iqGJFi9mxFbmc6l+tRGbGCidbrtXnowBvh2PgRUCpo3
 wtPFsuGo+eKAzLE+ew8f1iW/TRKrX/CXwHUtgkOVtXKHc4XKKs
 ole5XpiB294rAlV6MFe0zM4iZYrqnKa8U1svJiZtLpZ9iiZrgu
 pVRyB7XcRN0Xu1s8EZ2r5VPDXCQmEE6zYMN8gRAhHvDbTe6KkB
 856fLUU1kMh7thrbbePrjZVxvPEvToU6Qefa4ZiBUDjMlwpmHk
 3KKBhmoshMynkTC7FrfeDCv6Zv+g3t++QGfYwwOzl6T/1vLkHx
 aTYEIRcsecqJ6IccdYc23dbqIWmXGGcHcTFA/3ycjj72wGMCr1
 ja3s763ges91GJ0WCF6In/F4tcqDDQIqKyOqsOhej
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two functions cpu_is_v6_unaligned and safe_usermode
are only defined when CONFIG_PROC_FS is enabled, but
are used outside of the #ifdef.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Martin <dave.martin@linaro.org>
---
 arch/arm/mm/alignment.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index cfbcf8b..c335c76 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -86,16 +86,6 @@ core_param(alignment, ai_usermode, int, 0600);
 #define UM_FIXUP	(1 << 1)
 #define UM_SIGNAL	(1 << 2)
 
-#ifdef CONFIG_PROC_FS
-static const char *usermode_action[] = {
-	"ignored",
-	"warn",
-	"fixup",
-	"fixup+warn",
-	"signal",
-	"signal+warn"
-};
-
 /* Return true if and only if the ARMv6 unaligned access model is in use. */
 static bool cpu_is_v6_unaligned(void)
 {
@@ -123,6 +113,16 @@ static int safe_usermode(int new_usermode, bool warn)
 	return new_usermode;
 }
 
+#ifdef CONFIG_PROC_FS
+static const char *usermode_action[] = {
+	"ignored",
+	"warn",
+	"fixup",
+	"fixup+warn",
+	"signal",
+	"signal+warn"
+};
+
 static int alignment_proc_show(struct seq_file *m, void *v)
 {
 	seq_printf(m, "User:\t\t%lu\n", ai_user);
-- 
1.7.5.4

