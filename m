Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab2FRC0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 22:26:17 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46926 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753379Ab2FRCZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 22:25:39 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/5] printk: Convert pr_devel to use eliminated_printk
Date: Sun, 17 Jun 2012 19:25:09 -0700
Message-Id: <a22f461f1886506915755cf40a808583f38147cb.1339985627.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1339985626.git.joe@perches.com>
References: <cover.1339985626.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure there are no side effects to pr_devel uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/printk.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 84aa910..628054f 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -207,7 +207,7 @@ extern void dump_stack(void) __cold;
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
 #define pr_devel(fmt, ...) \
-	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+	eliminated_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
-- 
1.7.8.111.gad25c.dirty

