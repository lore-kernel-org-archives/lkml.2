Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab2I0VLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 17:11:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39222 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab2I0VL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 17:11:28 -0400
Message-Id: <20120927211121.732319261@openvz.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Sep 2012 01:10:34 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, hpa@zytor.com, gregkh@linuxfoundation.org,
        xemul@parallels.com, jslaby@suse.cz,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 2/3] tty, ioctls -- Add new ioctl definitions for tty flags fetching
References: <20120927211032.576475929@openvz.org>
Content-Disposition: inline; filename=tty-add-new-ioctls
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines new ioctl codes TIOCGPKT, TIOCGPTLCK,
TIOCGEXCL for fetching pty's packet mode and locking state,
and exclusive mode of tty.

[ No real handlers for the codes though, this will be
  addressed in another patch for easier review and
  bisectability ]

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Jiri Slaby <jslaby@suse.cz>
---
 arch/alpha/include/asm/ioctls.h   |    3 +++
 arch/mips/include/asm/ioctls.h    |    3 +++
 arch/parisc/include/asm/ioctls.h  |    3 +++
 arch/powerpc/include/asm/ioctls.h |    3 +++
 arch/sh/include/asm/ioctls.h      |    3 +++
 arch/sparc/include/asm/ioctls.h   |    3 +++
 arch/xtensa/include/asm/ioctls.h  |    3 +++
 fs/compat_ioctl.c                 |    3 +++
 include/asm-generic/ioctls.h      |    3 +++
 9 files changed, 27 insertions(+)

Index: tty.git/arch/alpha/include/asm/ioctls.h
===================================================================
--- tty.git.orig/arch/alpha/include/asm/ioctls.h
+++ tty.git/arch/alpha/include/asm/ioctls.h
@@ -95,6 +95,9 @@
 #define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 #define TIOCVHANGUP	0x5437
+#define TIOCGPKT	_IOR('T', 0x38, int) /* Get packet mode state */
+#define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
+#define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
 
 #define TIOCSERCONFIG	0x5453
 #define TIOCSERGWILD	0x5454
Index: tty.git/arch/mips/include/asm/ioctls.h
===================================================================
--- tty.git.orig/arch/mips/include/asm/ioctls.h
+++ tty.git/arch/mips/include/asm/ioctls.h
@@ -86,6 +86,9 @@
 #define TIOCGDEV	_IOR('T', 0x32, unsigned int) /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T', 0x36, int)  /* Generate signal on Pty slave */
 #define TIOCVHANGUP	0x5437
+#define TIOCGPKT	_IOR('T', 0x38, int) /* Get packet mode state */
+#define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
+#define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
 
 /* I hope the range from 0x5480 on is free ... */
 #define TIOCSCTTY	0x5480		/* become controlling tty */
Index: tty.git/arch/parisc/include/asm/ioctls.h
===================================================================
--- tty.git.orig/arch/parisc/include/asm/ioctls.h
+++ tty.git/arch/parisc/include/asm/ioctls.h
@@ -55,6 +55,9 @@
 #define TIOCGDEV	_IOR('T',0x32, int)  /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 #define TIOCVHANGUP	0x5437
+#define TIOCGPKT	_IOR('T', 0x38, int) /* Get packet mode state */
+#define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
+#define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
 
 #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
 #define FIOCLEX		0x5451
Index: tty.git/arch/powerpc/include/asm/ioctls.h
===================================================================
--- tty.git.orig/arch/powerpc/include/asm/ioctls.h
+++ tty.git/arch/powerpc/include/asm/ioctls.h
@@ -97,6 +97,9 @@
 #define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 #define TIOCVHANGUP	0x5437
+#define TIOCGPKT	_IOR('T', 0x38, int) /* Get packet mode state */
+#define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
+#define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
 
 #define TIOCSERCONFIG	0x5453
 #define TIOCSERGWILD	0x5454
Index: tty.git/arch/sh/include/asm/ioctls.h
===================================================================
--- tty.git.orig/arch/sh/include/asm/ioctls.h
+++ tty.git/arch/sh/include/asm/ioctls.h
@@ -88,6 +88,9 @@
 #define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 #define TIOCVHANGUP	_IO('T', 0x37)
+#define TIOCGPKT	_IOR('T', 0x38, int) /* Get packet mode state */
+#define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
+#define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
 
 #define TIOCSERCONFIG	_IO('T', 83) /* 0x5453 */
 #define TIOCSERGWILD	_IOR('T', 84,  int) /* 0x5454 */
Index: tty.git/arch/sparc/include/asm/ioctls.h
===================================================================
--- tty.git.orig/arch/sparc/include/asm/ioctls.h
+++ tty.git/arch/sparc/include/asm/ioctls.h
@@ -21,6 +21,9 @@
 #define TCSETSF2	_IOW('T', 15, struct termios2)
 #define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
 #define TIOCVHANGUP	_IO('T', 0x37)
+#define TIOCGPKT	_IOR('T', 0x38, int) /* Get packet mode state */
+#define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
+#define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
 
 /* Note that all the ioctls that are not available in Linux have a 
  * double underscore on the front to: a) avoid some programs to
Index: tty.git/arch/xtensa/include/asm/ioctls.h
===================================================================
--- tty.git.orig/arch/xtensa/include/asm/ioctls.h
+++ tty.git/arch/xtensa/include/asm/ioctls.h
@@ -101,6 +101,9 @@
 #define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 #define TIOCVHANGUP	_IO('T', 0x37)
+#define TIOCGPKT	_IOR('T', 0x38, int) /* Get packet mode state */
+#define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
+#define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
 
 #define TIOCSERCONFIG	_IO('T', 83)
 #define TIOCSERGWILD	_IOR('T', 84,  int)
Index: tty.git/fs/compat_ioctl.c
===================================================================
--- tty.git.orig/fs/compat_ioctl.c
+++ tty.git/fs/compat_ioctl.c
@@ -842,6 +842,9 @@ COMPATIBLE_IOCTL(TIOCGDEV)
 COMPATIBLE_IOCTL(TIOCCBRK)
 COMPATIBLE_IOCTL(TIOCGSID)
 COMPATIBLE_IOCTL(TIOCGICOUNT)
+COMPATIBLE_IOCTL(TIOCGPKT)
+COMPATIBLE_IOCTL(TIOCGPTLCK)
+COMPATIBLE_IOCTL(TIOCGEXCL)
 /* Little t */
 COMPATIBLE_IOCTL(TIOCGETD)
 COMPATIBLE_IOCTL(TIOCSETD)
Index: tty.git/include/asm-generic/ioctls.h
===================================================================
--- tty.git.orig/include/asm-generic/ioctls.h
+++ tty.git/include/asm-generic/ioctls.h
@@ -74,6 +74,9 @@
 #define TCSETXW		0x5435
 #define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
 #define TIOCVHANGUP	0x5437
+#define TIOCGPKT	_IOR('T', 0x38, int) /* Get packet mode state */
+#define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
+#define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
 
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451

