Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1AFWYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:24:46 -0500
Received: from kroah.org ([198.145.64.141]:55719 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab1AFWYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:24:04 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Werner Fink <werner@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/36] TTY: Add tty ioctl to figure device node of the system console.
Date: Thu,  6 Jan 2011 14:23:24 -0800
Message-Id: <1294352605-31906-35-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Werner Fink <werner@suse.de>

This has been in the SuSE kernels for a very long time.

Signed-off-by: Werner Fink <werner@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/alpha/include/asm/ioctls.h   |    1 +
 arch/mips/include/asm/ioctls.h    |    1 +
 arch/parisc/include/asm/ioctls.h  |    1 +
 arch/powerpc/include/asm/ioctls.h |    1 +
 arch/sh/include/asm/ioctls.h      |    1 +
 arch/sparc/include/asm/ioctls.h   |    1 +
 arch/xtensa/include/asm/ioctls.h  |    1 +
 drivers/tty/tty_io.c              |    5 +++++
 fs/compat_ioctl.c                 |    1 +
 include/asm-generic/ioctls.h      |    1 +
 10 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/include/asm/ioctls.h b/arch/alpha/include/asm/ioctls.h
index 59617c3..034b6cf 100644
--- a/arch/alpha/include/asm/ioctls.h
+++ b/arch/alpha/include/asm/ioctls.h
@@ -92,6 +92,7 @@
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define TIOCSERCONFIG	0x5453
diff --git a/arch/mips/include/asm/ioctls.h b/arch/mips/include/asm/ioctls.h
index d87cb04..d967b89 100644
--- a/arch/mips/include/asm/ioctls.h
+++ b/arch/mips/include/asm/ioctls.h
@@ -83,6 +83,7 @@
 #define TCSETSF2	_IOW('T', 0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
+#define TIOCGDEV	_IOR('T', 0x32, unsigned int) /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T', 0x36, int)  /* Generate signal on Pty slave */
 
 /* I hope the range from 0x5480 on is free ... */
diff --git a/arch/parisc/include/asm/ioctls.h b/arch/parisc/include/asm/ioctls.h
index 4e06144..6ba80d0 100644
--- a/arch/parisc/include/asm/ioctls.h
+++ b/arch/parisc/include/asm/ioctls.h
@@ -52,6 +52,7 @@
 #define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCGDEV	_IOR('T',0x32, int)  /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
diff --git a/arch/powerpc/include/asm/ioctls.h b/arch/powerpc/include/asm/ioctls.h
index 8519200..c7dc17c 100644
--- a/arch/powerpc/include/asm/ioctls.h
+++ b/arch/powerpc/include/asm/ioctls.h
@@ -94,6 +94,7 @@
 #define TIOCSRS485	0x542f
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define TIOCSERCONFIG	0x5453
diff --git a/arch/sh/include/asm/ioctls.h b/arch/sh/include/asm/ioctls.h
index eb6c4c6..84e85a7 100644
--- a/arch/sh/include/asm/ioctls.h
+++ b/arch/sh/include/asm/ioctls.h
@@ -85,6 +85,7 @@
 #define TCSETSF2	_IOW('T', 45, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define TIOCSERCONFIG	_IO('T', 83) /* 0x5453 */
diff --git a/arch/sparc/include/asm/ioctls.h b/arch/sparc/include/asm/ioctls.h
index 53f4ee0..ed3807b 100644
--- a/arch/sparc/include/asm/ioctls.h
+++ b/arch/sparc/include/asm/ioctls.h
@@ -19,6 +19,7 @@
 #define TCSETS2		_IOW('T', 13, struct termios2)
 #define TCSETSW2	_IOW('T', 14, struct termios2)
 #define TCSETSF2	_IOW('T', 15, struct termios2)
+#define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
 
 /* Note that all the ioctls that are not available in Linux have a 
  * double underscore on the front to: a) avoid some programs to
diff --git a/arch/xtensa/include/asm/ioctls.h b/arch/xtensa/include/asm/ioctls.h
index ab18000..ccf1800 100644
--- a/arch/xtensa/include/asm/ioctls.h
+++ b/arch/xtensa/include/asm/ioctls.h
@@ -98,6 +98,7 @@
 #define TCSETSF2	_IOW('T', 45, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define TIOCSERCONFIG	_IO('T', 83)
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index be5ab4a..d2333ab 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2618,6 +2618,11 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return put_user(tty->ldisc->ops->num, (int __user *)p);
 	case TIOCSETD:
 		return tiocsetd(tty, p);
+	case TIOCGDEV:
+	{
+		unsigned int ret = new_encode_dev(tty_devnum(real_tty));
+		return put_user(ret, (unsigned int __user *)p);
+	}
 	/*
 	 * Break handling
 	 */
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 410ed18..a1a8f0c 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -837,6 +837,7 @@ COMPATIBLE_IOCTL(TCSETSW)
 COMPATIBLE_IOCTL(TCSETSF)
 COMPATIBLE_IOCTL(TIOCLINUX)
 COMPATIBLE_IOCTL(TIOCSBRK)
+COMPATIBLE_IOCTL(TIOCGDEV)
 COMPATIBLE_IOCTL(TIOCCBRK)
 COMPATIBLE_IOCTL(TIOCGSID)
 COMPATIBLE_IOCTL(TIOCGICOUNT)
diff --git a/include/asm-generic/ioctls.h b/include/asm-generic/ioctls.h
index a321665..3f3f2d1 100644
--- a/include/asm-generic/ioctls.h
+++ b/include/asm-generic/ioctls.h
@@ -67,6 +67,7 @@
 #endif
 #define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
+#define TIOCGDEV	_IOR('T', 0x32, unsigned int) /* Get primary device node of /dev/console */
 #define TCGETX		0x5432 /* SYS5 TCGETX compatibility */
 #define TCSETX		0x5433
 #define TCSETXF		0x5434
-- 
1.7.3.2

