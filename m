Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab0KSRHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 12:07:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962Ab0KSRHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 12:07:42 -0500
Date: Fri, 19 Nov 2010 18:07:36 +0100
From: "Dr. Werner Fink" <werner@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Dr. Werner Fink" <werner@suse.de>, Greg KH <greg@kroah.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101119170736.GA4177@boole.suse.de>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"Dr. Werner Fink" <werner@suse.de>, Greg KH <greg@kroah.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
References: <20101118014848.GA7873@tango.0pointer.de>
 <20101118015310.GA30480@kroah.com>
 <20101118110020.GA13871@boole.suse.de>
 <20101118112335.434de53a@lxorguk.ukuu.org.uk>
 <20101118121256.GA19884@boole.suse.de>
 <20101118125822.16718289@lxorguk.ukuu.org.uk>
 <20101118131420.GA23872@boole.suse.de>
 <20101118144123.5417ccbd@lxorguk.ukuu.org.uk>
 <20101119132145.GA22883@boole.suse.de>
 <20101119154705.7829487a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <20101119154705.7829487a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline

On Fri, Nov 19, 2010 at 03:47:05PM +0000, Alan Cox wrote:
> > Currently the bootlogd(8) or blogd(8) parse the kernels command line
> > and if available do an ioctl TIOCGDEV (not supported by the upstream
> > kernel), then create a pty/tty pair, do an ioctl TIOCCONS to forward
> 
> So perhaps the vendors using TIOCGDEV could get off their collective
> backsides and submit it upstream ?

That I've tried 10 years before. If you think it's worth to retry
you may have a look on the attachment only for a short review

     Werner

-- 
System V style init programs - http://savannah.nongnu.org/projects/sysvinit/

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename=tiocgdev

>From 3ed084a05b7d28d65f6cc42c96696c7cb49c84a1 Mon Sep 17 00:00:00 2001
In-Reply-To: <20101119154705.7829487a@lxorguk.ukuu.org.uk>
References: <20101119154705.7829487a@lxorguk.ukuu.org.uk>
From: Werner Fink <werner@suse.de>
Date: Fri, 19 Nov 2010 17:54:44 +0100
Subject: [PATCH] Add tty ioctl to figure device node of the system console.


Signed-off-by: Werner Fink <werner@suse.de>

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
index 4e06144..0a10575 100644
--- a/arch/parisc/include/asm/ioctls.h
+++ b/arch/parisc/include/asm/ioctls.h
@@ -52,6 +52,7 @@
 #define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCGDEV	_IOW('T',0x32, int)  /* Get primary device node of /dev/console */
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
index c05c5af..055e7e9 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2618,6 +2618,12 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return put_user(tty->ldisc->ops->num, (int __user *)p);
 	case TIOCSETD:
 		return tiocsetd(tty, p);
+	case TIOCGDEV:
+	{
+		unsigned int ret = new_encode_dev(tty_devnum(real_tty));
+		return put_user(ret, (unsigned int __user *)p);
+	}
+
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
1.6.0.2


--OgqxwSJOaUobr8KG--
