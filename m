Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab0LFFoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 00:44:32 -0500
Received: from mail.perches.com ([173.55.12.10]:2293 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab0LFFoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 00:44:30 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Matt Mackall <mpm@selenic.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-embedded@vger.kernel.org
Subject: [PATCH 6/7] include/linux/printk.h: Organize printk_ratelimited macros
Date: Sun,  5 Dec 2010 21:44:20 -0800
Message-Id: <bcdc3e94c6e0a5b892160a66df254df92b62b2df.1291611193.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1291611190.git.joe@perches.com>
References: <cover.1291611190.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use no_printk for !CONFIG_PRINTK printk_ratelimited.
Whitespace cleanup.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/printk.h |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index a705a91..b4be1b1 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -233,7 +233,8 @@ extern void dump_stack(void) __cold;
  * no local ratelimit_state used in the !PRINTK case
  */
 #ifdef CONFIG_PRINTK
-#define printk_ratelimited(fmt, ...)  ({				\
+#define printk_ratelimited(fmt, ...)					\
+({									\
 	static DEFINE_RATELIMIT_STATE(_rs,				\
 				      DEFAULT_RATELIMIT_INTERVAL,	\
 				      DEFAULT_RATELIMIT_BURST);		\
@@ -242,36 +243,34 @@ extern void dump_stack(void) __cold;
 		printk(fmt, ##__VA_ARGS__);				\
 })
 #else
-/* No effect, but we still get type checking even in the !PRINTK case: */
-#define printk_ratelimited printk
+#define printk_ratelimited(fmt, ...)					\
+	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
-#define pr_emerg_ratelimited(fmt, ...) \
+#define pr_emerg_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_alert_ratelimited(fmt, ...) \
+#define pr_alert_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_crit_ratelimited(fmt, ...) \
+#define pr_crit_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_err_ratelimited(fmt, ...) \
+#define pr_err_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warning_ratelimited(fmt, ...) \
+#define pr_warn_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warn_ratelimited pr_warning_ratelimited
-#define pr_notice_ratelimited(fmt, ...) \
+#define pr_notice_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_info_ratelimited(fmt, ...) \
+#define pr_info_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 /* no pr_cont_ratelimited, don't do that... */
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
-#define pr_debug_ratelimited(fmt, ...) \
+#define pr_debug_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
 #define pr_debug_ratelimited(fmt, ...) \
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
-
 enum {
 	DUMP_PREFIX_NONE,
 	DUMP_PREFIX_ADDRESS,
-- 
1.7.3.2.245.g03276.dirty

