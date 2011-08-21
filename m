Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab1HUW6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 18:58:36 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:50366 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756097Ab1HUW6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 18:58:24 -0400
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] [media] rc-core.h: Surround macro with do {} while (0)
Date: Sun, 21 Aug 2011 15:56:45 -0700
Message-Id: <83cc61d8e120e2b18fe69bc85a6dafe9174ad2be.1313966089.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1313966088.git.joe@perches.com>
References: <cover.1313966088.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macros coded with if statements should be do { if... } while (0)
so the macros can be used in other if tests.

Use ##__VA_ARGS__ for variadic macro as well.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/media/rc-core.h |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index b1f19b7..b0c494a 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -23,8 +23,11 @@
 #include <media/rc-map.h>
 
 extern int rc_core_debug;
-#define IR_dprintk(level, fmt, arg...)	if (rc_core_debug >= level) \
-	printk(KERN_DEBUG "%s: " fmt , __func__, ## arg)
+#define IR_dprintk(level, fmt, ...)				\
+do {								\
+	if (rc_core_debug >= level)				\
+		pr_debug("%s: " fmt, __func__, ##__VA_ARGS__);	\
+} while (0)
 
 enum rc_driver_type {
 	RC_DRIVER_SCANCODE = 0,	/* Driver or hardware generates a scancode */
-- 
1.7.6.405.gc1be0

