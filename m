Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab2FRC0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 22:26:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47556 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753440Ab2FRCZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 22:25:48 -0400
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] usb: Convert dbg to pr_eliminated and pr_debug
Date: Sun, 17 Jun 2012 19:25:10 -0700
Message-Id: <25071de4def201f947780d6937b9732ccac3b3f0.1339985627.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1339985626.git.joe@perches.com>
References: <cover.1339985626.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the dbg macro to use pr_eliminated when not
DEBUG and pr_debug with DEBUG so dynamic_debug can
be used.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/usb.h |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/usb.h b/include/linux/usb.h
index f717fbd..56b88b8 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1714,14 +1714,12 @@ extern void usb_register_notify(struct notifier_block *nb);
 extern void usb_unregister_notify(struct notifier_block *nb);
 
 #ifdef DEBUG
-#define dbg(format, arg...)						\
-	printk(KERN_DEBUG "%s: " format "\n", __FILE__, ##arg)
+#define dbg(format, ...)						\
+	pr_debug("%s: " format "\n", __FILE__, ##__VA_ARGS__)
 #else
-#define dbg(format, arg...)						\
-do {									\
-	if (0)								\
-		printk(KERN_DEBUG "%s: " format "\n", __FILE__, ##arg); \
-} while (0)
+#define dbg(format, ...)						\
+	printk_eliminated(KERN_DEBUG "%s: " format "\n",		\
+			  __FILE__, ##__VA_ARGS)
 #endif
 
 /* debugfs stuff */
-- 
1.7.8.111.gad25c.dirty

