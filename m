Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422799Ab2JYDqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 23:46:13 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56888 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422763Ab2JYDqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 23:46:08 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Subject: [PATCH V2 14/23] printk: Rename LOG_ALIGN to PRINTK_LOG_ALIGN
Date: Wed, 24 Oct 2012 20:43:49 -0700
Message-Id: <6ea449624401ac7e6d468f1773f5ce363c83ba61.1351135989.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351135988.git.joe@perches.com>
References: <cover.1351135988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the #define more specific to the printk subsystem.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/printk.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 0134b2e..bc0b4ed 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -239,12 +239,12 @@ u32 printk_log_clear_idx;
 
 /* record buffer */
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
-#define LOG_ALIGN 4
+#define PRINTK_LOG_ALIGN 4
 #else
-#define LOG_ALIGN __alignof__(struct printk_log)
+#define PRINTK_LOG_ALIGN __alignof__(struct printk_log)
 #endif
 #define __PRINTK_LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
-char __printk_log_buf[__PRINTK_LOG_BUF_LEN] __aligned(LOG_ALIGN);
+char __printk_log_buf[__PRINTK_LOG_BUF_LEN] __aligned(PRINTK_LOG_ALIGN);
 char *printk_log_buf = __printk_log_buf;
 u32 printk_log_buf_len = __PRINTK_LOG_BUF_LEN;
 
@@ -306,7 +306,7 @@ void printk_log_store(int facility, int level,
 
 	/* number of '\0' padding bytes to next message */
 	size = sizeof(struct printk_log) + text_len + dict_len;
-	pad_len = (-size) & (LOG_ALIGN - 1);
+	pad_len = (-size) & (PRINTK_LOG_ALIGN - 1);
 	size += pad_len;
 
 	while (printk_log_first_seq < printk_log_next_seq) {
-- 
1.7.8.112.g3fd21

