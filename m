Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab0JFSHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:07:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56958 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759560Ab0JFSGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:06:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/8] arm: make asm/ioctls.h mostly generic
Date: Wed,  6 Oct 2010 20:06:16 +0200
Message-Id: <1286388380-20646-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286388380-20646-1-git-send-email-arnd@arndb.de>
References: <1286388380-20646-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:9NvojWQ+PhmogLlN0I5JL5qRbQSLT6xndp+CgmaMZpX
 VC+1ND6SnMuRzXq9PFqHIVOzJz6fQxnN5Y2q5oT8Y0YOosPvXT
 aYAeDEeu7bqagZoKXBAPPB73hwXzV1LfGwb4mZxgl4ms4fSswQ
 O6LI9D7rm3zQ+xLTJqpSrtrdugMc0sNxLe1hmItk7goUgPh6lc
 c35mlHgIdW+0ktHEWtQbA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the arm version of asm/ioctls.h almost
identical to the asm-generic version, the only
difference being the definition of FIOQSIZE.

The only user-visible change is the addition of
the TCGETX/TCSETX/TCSETXF/TCSETXW ioctl family,
which was not defined on ARM previously.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/ioctls.h |   39 ++++++++++++++++++++++++++-------------
 1 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/arm/include/asm/ioctls.h b/arch/arm/include/asm/ioctls.h
index 0b30894..0040d08 100644
--- a/arch/arm/include/asm/ioctls.h
+++ b/arch/arm/include/asm/ioctls.h
@@ -1,7 +1,10 @@
 #ifndef __ASM_ARM_IOCTLS_H
 #define __ASM_ARM_IOCTLS_H
 
-#include <asm/ioctl.h>
+/* ARM uses a different value from the asm-generic definition for this */
+#define FIOQSIZE	0x545E
+
+#include <linux/ioctl.h>
 
 /* 0x54 is just a magic number to make these relatively unique ('T') */
 
@@ -46,18 +49,21 @@
 #define TIOCSBRK	0x5427  /* BSD compatibility */
 #define TIOCCBRK	0x5428  /* BSD compatibility */
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
-#define TCGETS2		_IOR('T',0x2A, struct termios2)
-#define TCSETS2		_IOW('T',0x2B, struct termios2)
-#define TCSETSW2	_IOW('T',0x2C, struct termios2)
-#define TCSETSF2	_IOW('T',0x2D, struct termios2)
-#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
-#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
-#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
-
-#define TIOCGRS485      0x542E
-#define TIOCSRS485      0x542F
+#define TCGETS2		_IOR('T', 0x2A, struct termios2)
+#define TCSETS2		_IOW('T', 0x2B, struct termios2)
+#define TCSETSW2	_IOW('T', 0x2C, struct termios2)
+#define TCSETSF2	_IOW('T', 0x2D, struct termios2)
+#define TIOCGRS485	0x542E
+#define TIOCSRS485	0x542F
+#define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
+#define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
+#define TCGETX		0x5432 /* SYS5 TCGETX compatibility */
+#define TCSETX		0x5433
+#define TCSETXF		0x5434
+#define TCSETXW		0x5435
+#define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
 
-#define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
+#define FIONCLEX	0x5450
 #define FIOCLEX		0x5451
 #define FIOASYNC	0x5452
 #define TIOCSERCONFIG	0x5453
@@ -72,7 +78,14 @@
 
 #define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
 #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
-#define FIOQSIZE	0x545E
+
+/*
+ * Some arches already define FIOQSIZE due to a historical
+ * conflict with a Hayes modem-specific ioctl value.
+ */
+#ifndef FIOQSIZE
+# define FIOQSIZE	0x5460
+#endif
 
 /* Used for packet mode */
 #define TIOCPKT_DATA		 0
-- 
1.7.1

