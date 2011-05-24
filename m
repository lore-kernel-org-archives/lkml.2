Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab1EXIip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 04:38:45 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:47259 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428Ab1EXIin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 04:38:43 -0400
From: Florian Fainelli <ffainelli@freebox.fr>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH] TTY: export NR_LDISC and N_* line discipline numbers to user-space
Date: Tue, 24 May 2011 10:43:03 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-server; KDE/4.6.2; x86_64; ; )
Organization: Freebox
Cc: lkml <linux-kernel@vger.kernel.org>, Maxime Bizon <mbizon@freebox.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105241043.03347.ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <ffainelli@freebox.fr>

Since commit (4564f9e5: consolidate line discipline number definitions)
the patch moved all line discipline number from a per-architecture termios.h
to a shared one: tty.h. However, prior to this consolidation work, the
line discipline numbers were outside of an ifdef __KERNEL__/endif block
so these numbers used to be exported to user-space.

Since such numbers are kernel ABI anyway, and tty.h is already included
for user- space header processing, just move these relevant defines
outside of the ifdef __KERNEL__/endif block in include/linux/tty.h.

CC: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
---
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 9f469c7..272dc9a 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -5,24 +5,6 @@
  * 'tty.h' defines some structures used by tty_io.c and some defines.
  */
 
-#ifdef __KERNEL__
-#include <linux/fs.h>
-#include <linux/major.h>
-#include <linux/termios.h>
-#include <linux/workqueue.h>
-#include <linux/tty_driver.h>
-#include <linux/tty_ldisc.h>
-#include <linux/mutex.h>
-
-#include <asm/system.h>
-
-
-/*
- * (Note: the *_driver.minor_start values 1, 64, 128, 192 are
- * hardcoded at present.)
- */
-#define NR_UNIX98_PTY_DEFAULT	4096      /* Default maximum for Unix98 ptys */
-#define NR_UNIX98_PTY_MAX	(1 << MINORBITS) /* Absolute limit */
 #define NR_LDISCS		30
 
 /* line disciplines */
@@ -51,6 +33,25 @@
 #define N_GSM0710	21	/* GSM 0710 Mux */
 #define N_TI_WL		22	/* for TI's WL BT, FM, GPS combo chips */
 
+#ifdef __KERNEL__
+#include <linux/fs.h>
+#include <linux/major.h>
+#include <linux/termios.h>
+#include <linux/workqueue.h>
+#include <linux/tty_driver.h>
+#include <linux/tty_ldisc.h>
+#include <linux/mutex.h>
+
+#include <asm/system.h>
+
+
+/*
+ * (Note: the *_driver.minor_start values 1, 64, 128, 192 are
+ * hardcoded at present.)
+ */
+#define NR_UNIX98_PTY_DEFAULT	4096      /* Default maximum for Unix98 ptys */
+#define NR_UNIX98_PTY_MAX	(1 << MINORBITS) /* Absolute limit */
+
 /*
  * This character is the same as _POSIX_VDISABLE: it cannot be used as
  * a c_cc[] character, but indicates that a particular special character
-- 
1.7.4.1

