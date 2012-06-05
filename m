Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761670Ab2FEJsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:48:14 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36108 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761617Ab2FEJsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:48:10 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>
Subject: [PATCH 8/8] printk: Remove the now unnecessary "C" annotation for KERN_CONT
Date: Tue,  5 Jun 2012 02:46:37 -0700
Message-Id: <7b880f2fd3cf7b55cf1dcf91eda584de3235f99a.1338889067.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1338889066.git.joe@perches.com>
References: <cover.1338889066.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all KERN_<LEVEL> uses are prefixed with ASCII SOH,
there is no need for a KERN_CONT.  Keep it backward compatible
by adding #define KERN_CONT ""

Reduces kernel image size a thousand bytes.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kern_levels.h |    2 +-
 include/linux/printk.h      |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/include/linux/kern_levels.h b/include/linux/kern_levels.h
index 8c719a9..866caaa 100644
--- a/include/linux/kern_levels.h
+++ b/include/linux/kern_levels.h
@@ -20,6 +20,6 @@
  * line that had no enclosing \n). Only to be used by core/arch code
  * during early bootup (a continued line is not SMP-safe otherwise).
  */
-#define KERN_CONT	KERN_SOH "c"
+#define KERN_CONT	""
 
 #endif
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 93a231f..9afc01e 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -13,7 +13,6 @@ static inline int printk_get_level(const char *buffer)
 		switch (buffer[1]) {
 		case '0' ... '7':
 		case 'd':	/* KERN_DEFAULT */
-		case 'c':	/* KERN_CONT */
 			return buffer[1];
 		}
 	}
@@ -26,7 +25,6 @@ static inline const char *printk_skip_level(const char *buffer)
 		switch (buffer[1]) {
 		case '0' ... '7':
 		case 'd':	/* KERN_DEFAULT */
-		case 'c':	/* KERN_CONT */
 			return buffer + 2;
 		}
 	}
-- 
1.7.8.111.gad25c.dirty

