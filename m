Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab1BQRlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:41:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53343 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1BQRlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:41:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=JVJWGKcrQ6nRK1ef7V8rpvrym7dfKDvguzfCAwQeCZhnd8f434UHCJwexOBKgzt7Yt
         bm7g0oFdPDB/v+owMAncZeF8uibgNSlzxgciiH5d0U+trk1Wxlqmpskd3QKDpkxD6BfE
         nxyD5hmEyQUM0Sj00ZXuvcvJ1XEYs/yIQxbwg=
Subject: [PATCH] tty: add TIOCVHANGUP to allow clean tty shutdown of all
 ttys
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Feb 2011 18:39:28 +0100
Message-ID: <1297964368.2165.1.camel@yio>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

tty: add TIOCVHANGUP to allow clean tty shutdown of all ttys

This is useful for system management software so that it can kick
off things like gettys and everything that's started from a tty,
before we reuse it from/for something else or shut it down.

Without this ioctl it would have to temporarily become the owner of
the tty, then call vhangup() and then give it up again.

Cc: Lennart Poettering <lennart@poettering.net>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

 arch/alpha/include/asm/ioctls.h   |    1 +
 arch/mips/include/asm/ioctls.h    |    1 +
 arch/parisc/include/asm/ioctls.h  |    1 +
 arch/powerpc/include/asm/ioctls.h |    1 +
 arch/sh/include/asm/ioctls.h      |    1 +
 arch/sparc/include/asm/ioctls.h   |    1 +
 arch/xtensa/include/asm/ioctls.h  |    1 +
 drivers/tty/tty_io.c              |    5 +++++
 include/asm-generic/ioctls.h      |    1 +
 9 files changed, 13 insertions(+)

diff --git a/arch/alpha/include/asm/ioctls.h b/arch/alpha/include/asm/ioctls.h
index 034b6cf..80e1cee 100644
--- a/arch/alpha/include/asm/ioctls.h
+++ b/arch/alpha/include/asm/ioctls.h
@@ -94,6 +94,7 @@
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 #define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
+#define TIOCVHANGUP	0x5437
 
 #define TIOCSERCONFIG	0x5453
 #define TIOCSERGWILD	0x5454
diff --git a/arch/mips/include/asm/ioctls.h b/arch/mips/include/asm/ioctls.h
index d967b89..92403c3 100644
--- a/arch/mips/include/asm/ioctls.h
+++ b/arch/mips/include/asm/ioctls.h
@@ -85,6 +85,7 @@
 #define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
 #define TIOCGDEV	_IOR('T', 0x32, unsigned int) /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T', 0x36, int)  /* Generate signal on Pty slave */
+#define TIOCVHANGUP	0x5437
 
 /* I hope the range from 0x5480 on is free ... */
 #define TIOCSCTTY	0x5480		/* become controlling tty */
diff --git a/arch/parisc/include/asm/ioctls.h b/arch/parisc/include/asm/ioctls.h
index 6ba80d0..054ec06 100644
--- a/arch/parisc/include/asm/ioctls.h
+++ b/arch/parisc/include/asm/ioctls.h
@@ -54,6 +54,7 @@
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 #define TIOCGDEV	_IOR('T',0x32, int)  /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
+#define TIOCVHANGUP	0x5437
 
 #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
 #define FIOCLEX		0x5451
diff --git a/arch/powerpc/include/asm/ioctls.h b/arch/powerpc/include/asm/ioctls.h
index c7dc17c..e9b7887 100644
--- a/arch/powerpc/include/asm/ioctls.h
+++ b/arch/powerpc/include/asm/ioctls.h
@@ -96,6 +96,7 @@
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 #define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
+#define TIOCVHANGUP	0x5437
 
 #define TIOCSERCONFIG	0x5453
 #define TIOCSERGWILD	0x5454
diff --git a/arch/sh/include/asm/ioctls.h b/arch/sh/include/asm/ioctls.h
index 84e85a7..a6769f3 100644
--- a/arch/sh/include/asm/ioctls.h
+++ b/arch/sh/include/asm/ioctls.h
@@ -87,6 +87,7 @@
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 #define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
+#define TIOCVHANGUP	_IO('T', 0x37)
 
 #define TIOCSERCONFIG	_IO('T', 83) /* 0x5453 */
 #define TIOCSERGWILD	_IOR('T', 84,  int) /* 0x5454 */
diff --git a/arch/sparc/include/asm/ioctls.h b/arch/sparc/include/asm/ioctls.h
index ed3807b..28d0c8b 100644
--- a/arch/sparc/include/asm/ioctls.h
+++ b/arch/sparc/include/asm/ioctls.h
@@ -20,6 +20,7 @@
 #define TCSETSW2	_IOW('T', 14, struct termios2)
 #define TCSETSF2	_IOW('T', 15, struct termios2)
 #define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
+#define TIOCVHANGUP	_IO('T', 0x37)
 
 /* Note that all the ioctls that are not available in Linux have a 
  * double underscore on the front to: a) avoid some programs to
diff --git a/arch/xtensa/include/asm/ioctls.h b/arch/xtensa/include/asm/ioctls.h
index ccf1800..fd1d136 100644
--- a/arch/xtensa/include/asm/ioctls.h
+++ b/arch/xtensa/include/asm/ioctls.h
@@ -100,6 +100,7 @@
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 #define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
 #define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
+#define TIOCVHANGUP	_IO('T', 0x37)
 
 #define TIOCSERCONFIG	_IO('T', 83)
 #define TIOCSERGWILD	_IOR('T', 84,  int)
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 0065da4..f8be893 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2627,6 +2627,11 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return put_user(tty->ldisc->ops->num, (int __user *)p);
 	case TIOCSETD:
 		return tiocsetd(tty, p);
+	case TIOCVHANGUP:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		tty_vhangup(tty);
+		return 0;
 	case TIOCGDEV:
 	{
 		unsigned int ret = new_encode_dev(tty_devnum(real_tty));
diff --git a/include/asm-generic/ioctls.h b/include/asm-generic/ioctls.h
index 3f3f2d1..199975f 100644
--- a/include/asm-generic/ioctls.h
+++ b/include/asm-generic/ioctls.h
@@ -73,6 +73,7 @@
 #define TCSETXF		0x5434
 #define TCSETXW		0x5435
 #define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
+#define TIOCVHANGUP	0x5437
 
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451


