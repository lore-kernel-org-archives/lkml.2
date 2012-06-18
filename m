Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2FRC0I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 22:26:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56347 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753363Ab2FRCZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 22:25:28 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/5] printk: Add eliminated_printk macro
Date: Sun, 17 Jun 2012 19:25:08 -0700
Message-Id: <ec5015aa86e465f7b797b1fa023bd6e3b2a847be.1339985627.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1339985626.git.joe@perches.com>
References: <cover.1339985626.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no_printk keeps gcc side-effects.
Add a mechanism to eliminate the side-effects.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/printk.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 1bec2f7..84aa910 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -88,6 +88,16 @@ int no_printk(const char *fmt, ...)
 	return 0;
 }
 
+/*
+ * Dummy printk for disabled printks maintaining
+ * gcc's format checking and eliminating side-effects
+ */
+#define eliminated_printk(fmt, ...)		\
+do {						\
+	if (0)					\
+		printk(fmt, ##__VA_ARGS__);	\
+} while (0)
+
 extern asmlinkage __printf(1, 2)
 void early_printk(const char *fmt, ...);
 
-- 
1.7.8.111.gad25c.dirty

