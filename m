Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab0FOSNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:13:49 -0400
Received: from lirone.symas.net ([64.71.152.235]:46551 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab0FOSNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:13:48 -0400
Message-ID: <4C17C2D4.8070205@symas.com>
Date: Tue, 15 Jun 2010 11:13:40 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.3a5pre) Gecko/20100607 Firefox 3.6
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] tty: Add arch-specific EXTPROC definitions
References: <4C120D8A.8050207@symas.com> <87631pq2aj.fsf@basil.nowhere.org> <4C121B4C.2000702@symas.com> <4C12E4B7.4020900@symas.com> <4C17C190.1020000@symas.com> <4C17C233.2080106@symas.com>
In-Reply-To: <4C17C233.2080106@symas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the TIOCSIG, TIOCPKT_IOCTL, and EXTPROC definitions to the arch-specific 
headers.

Signed-off-by: Howard Chu <hyc@symas.com>
---
  arch/alpha/include/asm/ioctls.h     |    2 ++
  arch/alpha/include/asm/termbits.h   |    1 +
  arch/arm/include/asm/ioctls.h       |    2 ++
  arch/arm/include/asm/termbits.h     |    1 +
  arch/avr32/include/asm/ioctls.h     |    2 ++
  arch/avr32/include/asm/termbits.h   |    1 +
  arch/cris/include/asm/ioctls.h      |    2 ++
  arch/cris/include/asm/termbits.h    |    1 +
  arch/frv/include/asm/ioctls.h       |    2 ++
  arch/frv/include/asm/termbits.h     |    1 +
  arch/h8300/include/asm/ioctls.h     |    2 ++
  arch/h8300/include/asm/termbits.h   |    1 +
  arch/ia64/include/asm/ioctls.h      |    2 ++
  arch/ia64/include/asm/termbits.h    |    1 +
  arch/m32r/include/asm/ioctls.h      |    2 ++
  arch/m32r/include/asm/termbits.h    |    1 +
  arch/m68k/include/asm/ioctls.h      |    2 ++
  arch/m68k/include/asm/termbits.h    |    1 +
  arch/mips/include/asm/ioctls.h      |    3 ++-
  arch/mips/include/asm/termbits.h    |    1 +
  arch/mn10300/include/asm/ioctls.h   |    2 ++
  arch/mn10300/include/asm/termbits.h |    1 +
  arch/parisc/include/asm/ioctls.h    |    2 ++
  arch/parisc/include/asm/termbits.h  |    1 +
  arch/powerpc/include/asm/ioctls.h   |    2 ++
  arch/powerpc/include/asm/termbits.h |    1 +
  arch/s390/include/asm/ioctls.h      |    2 ++
  arch/sh/include/asm/ioctls.h        |    2 ++
  arch/sparc/include/asm/ioctls.h     |    2 ++
  arch/sparc/include/asm/termbits.h   |    1 +
  arch/xtensa/include/asm/ioctls.h    |    2 ++
  arch/xtensa/include/asm/termbits.h  |    1 +
  32 files changed, 49 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/include/asm/ioctls.h b/arch/alpha/include/asm/ioctls.h
index 67bb9f6..8af5ee5 100644
--- a/arch/alpha/include/asm/ioctls.h
+++ b/arch/alpha/include/asm/ioctls.h
@@ -80,6 +80,7 @@
  # define TIOCPKT_START		 8
  # define TIOCPKT_NOSTOP		16
  # define TIOCPKT_DOSTOP		32
+# define TIOCPKT_IOCTL		64


  #define TIOCNOTTY	0x5422
@@ -91,6 +92,7 @@
  #define TIOCGSID	0x5429  /* Return the session ID of FD */
  #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux 
device) */
  #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */

  #define TIOCSERCONFIG	0x5453
  #define TIOCSERGWILD	0x5454
diff --git a/arch/alpha/include/asm/termbits.h b/arch/alpha/include/asm/termbits.h
index ad854a4..879dd35 100644
--- a/arch/alpha/include/asm/termbits.h
+++ b/arch/alpha/include/asm/termbits.h
@@ -180,6 +180,7 @@ struct ktermios {
  #define FLUSHO	0x00800000
  #define PENDIN	0x20000000
  #define IEXTEN	0x00000400
+#define EXTPROC	0x10000000

  /* Values for the ACTION argument to `tcflow'.  */
  #define	TCOOFF		0
diff --git a/arch/arm/include/asm/ioctls.h b/arch/arm/include/asm/ioctls.h
index a91d8a1..e5e22cf 100644
--- a/arch/arm/include/asm/ioctls.h
+++ b/arch/arm/include/asm/ioctls.h
@@ -52,6 +52,7 @@
  #define TCSETSF2	_IOW('T',0x2D, struct termios2)
  #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux 
device) */
  #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */

  #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
  #define FIOCLEX		0x5451
@@ -78,6 +79,7 @@
  #define TIOCPKT_START		 8
  #define TIOCPKT_NOSTOP		16
  #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64

  #define TIOCSER_TEMT	0x01	/* Transmitter physically empty */

diff --git a/arch/arm/include/asm/termbits.h b/arch/arm/include/asm/termbits.h
index f784d11..704135d 100644
--- a/arch/arm/include/asm/termbits.h
+++ b/arch/arm/include/asm/termbits.h
@@ -177,6 +177,7 @@ struct ktermios {
  #define FLUSHO	0010000
  #define PENDIN	0040000
  #define IEXTEN	0100000
+#define EXTPROC	0200000

  /* tcflow() and TCXONC use these */
  #define	TCOOFF		0
diff --git a/arch/avr32/include/asm/ioctls.h b/arch/avr32/include/asm/ioctls.h
index 0cf2c0a..f947622 100644
--- a/arch/avr32/include/asm/ioctls.h
+++ b/arch/avr32/include/asm/ioctls.h
@@ -53,6 +53,7 @@
  #define TCSETSF2	_IOW('T',0x2D, struct termios2)
  #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux 
device) */
  #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */

  #define FIONCLEX	0x5450
  #define FIOCLEX		0x5451
@@ -81,6 +82,7 @@
  #define TIOCPKT_START		 8
  #define TIOCPKT_NOSTOP		16
  #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64

  #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */

diff --git a/arch/avr32/include/asm/termbits.h b/arch/avr32/include/asm/termbits.h
index db2daab..366adc5 100644
--- a/arch/avr32/include/asm/termbits.h
+++ b/arch/avr32/include/asm/termbits.h
@@ -175,6 +175,7 @@ struct ktermios {
  #define FLUSHO	0010000
  #define PENDIN	0040000
  #define IEXTEN	0100000
+#define EXTPROC	0200000

  /* tcflow() and TCXONC use these */
  #define	TCOOFF		0
diff --git a/arch/cris/include/asm/ioctls.h b/arch/cris/include/asm/ioctls.h
index 35bbc18..2569665 100644
--- a/arch/cris/include/asm/ioctls.h
+++ b/arch/cris/include/asm/ioctls.h
@@ -54,6 +54,7 @@
  #define TCSETSF2	_IOW('T',0x2D, struct termios2)
  #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux 
device) */
  #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */

  #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
  #define FIOCLEX		0x5451
@@ -86,6 +87,7 @@
  #define TIOCPKT_START		 8
  #define TIOCPKT_NOSTOP		16
  #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64

  #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */

diff --git a/arch/cris/include/asm/termbits.h b/arch/cris/include/asm/termbits.h
index 66e1a74..1c43bc8 100644
--- a/arch/cris/include/asm/termbits.h
+++ b/arch/cris/include/asm/termbits.h
@@ -214,6 +214,7 @@ struct ktermios {
  #define FLUSHO	0010000
  #define PENDIN	0040000
  #define IEXTEN	0100000
+#define EXTPROC	0200000

  /* tcflow() and TCXONC use these */
  #define	TCOOFF		0
diff --git a/arch/frv/include/asm/ioctls.h b/arch/frv/include/asm/ioctls.h
index d0c30e3..a993e37 100644
--- a/arch/frv/include/asm/ioctls.h
+++ b/arch/frv/include/asm/ioctls.h
@@ -53,6 +53,7 @@
  #define TCSETSF2	_IOW('T',0x2D, struct termios2)
  #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux 
device) */
  #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */

  #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
  #define FIOCLEX		0x5451
@@ -79,6 +80,7 @@
  #define TIOCPKT_START		 8
  #define TIOCPKT_NOSTOP		16
  #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64

  #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */

diff --git a/arch/frv/include/asm/termbits.h b/arch/frv/include/asm/termbits.h
index 5568492..7722e19 100644
--- a/arch/frv/include/asm/termbits.h
+++ b/arch/frv/include/asm/termbits.h
@@ -180,6 +180,7 @@ struct ktermios {
  #define FLUSHO	0010000
  #define PENDIN	0040000
  #define IEXTEN	0100000
+#define EXTPROC	0200000


  /* tcflow() and TCXONC use these */
diff --git a/arch/h8300/include/asm/ioctls.h b/arch/h8300/include/asm/ioctls.h
index 98a53d0..b6b249f 100644
--- a/arch/h8300/include/asm/ioctls.h
+++ b/arch/h8300/include/asm/ioctls.h
@@ -53,6 +53,7 @@
  #define TCSETSF2	_IOW('T',0x2D, struct termios2)
  #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux 
device) */
  #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */

  #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
  #define FIOCLEX		0x5451
@@ -79,6 +80,7 @@
  #define TIOCPKT_START		 8
  #define TIOCPKT_NOSTOP		16
  #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64

  #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */

diff --git a/arch/h8300/include/asm/termbits.h b/arch/h8300/include/asm/termbits.h
index 31eca81..3287a62 100644
--- a/arch/h8300/include/asm/termbits.h
+++ b/arch/h8300/include/asm/termbits.h
@@ -179,6 +179,7 @@ struct ktermios {
  #define FLUSHO	0010000
  #define PENDIN	0040000
  #define IEXTEN	0100000
+#define EXTPROC	0200000


  /* tcflow() and TCXONC use these */
diff --git a/arch/ia64/include/asm/ioctls.h b/arch/ia64/include/asm/ioctls.h
index f41b636..a11af01 100644
--- a/arch/ia64/include/asm/ioctls.h
+++ b/arch/ia64/include/asm/ioctls.h
@@ -59,6 +59,7 @@
  #define TCSETSF2	_IOW('T',0x2D, struct termios2)
  #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux 
device) */
  #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */

  #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
  #define FIOCLEX		0x5451
@@ -87,6 +88,7 @@
  #define TIOCPKT_START		 8
  #define TIOCPKT_NOSTOP		16
  #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64

  #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */

diff --git a/arch/ia64/include/asm/termbits.h b/arch/ia64/include/asm/termbits.h
index 9f162e0..c009b94 100644
--- a/arch/ia64/include/asm/termbits.h
+++ b/arch/ia64/include/asm/termbits.h
@@ -187,6 +187,7 @@ struct ktermios {
  #define FLUSHO	0010000
  #define PENDIN	0040000
  #define IEXTEN	0100000
+#define EXTPROC	0200000

  /* tcflow() and TCXONC use these */
  #define	TCOOFF		0
diff --git a/arch/m32r/include/asm/ioctls.h b/arch/m32r/include/asm/ioctls.h
index b9f54bb..366db76 100644
--- a/arch/m32r/include/asm/ioctls.h
+++ b/arch/m32r/include/asm/ioctls.h
@@ -53,6 +53,7 @@
  #define TCSETSF2	_IOW('T',0x2D, struct termios2)
  #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux 
device) */
  #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */

  #define FIONCLEX	0x5450
  #define FIOCLEX		0x5451
@@ -81,6 +82,7 @@
  #define TIOCPKT_START		 8
  #define TIOCPKT_NOSTOP		16
  #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64

  #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */

diff --git a/arch/m32r/include/asm/termbits.h b/arch/m32r/include/asm/termbits.h
index bc10400..957a3c6 100644
--- a/arch/m32r/include/asm/termbits.h
+++ b/arch/m32r/include/asm/termbits.h
@@ -179,6 +179,7 @@ struct ktermios {
  #define FLUSHO	0010000
  #define PENDIN	0040000
  #define IEXTEN	0100000
+#define EXTPROC	0200000

  /* tcflow() and TCXONC use these */
  #define	TCOOFF		0
diff --git a/arch/m68k/include/asm/ioctls.h b/arch/m68k/include/asm/ioctls.h
index b8d2f4b..91a57d6 100644
--- a/arch/m68k/include/asm/ioctls.h
+++ b/arch/m68k/include/asm/ioctls.h
@@ -52,6 +52,7 @@
  #define TCSETSF2	_IOW('T',0x2D, struct termios2)
  #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux 
device) */
  #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */

  #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
  #define FIOCLEX		0x5451
@@ -78,6 +79,7 @@
  #define TIOCPKT_START		 8
  #define TIOCPKT_NOSTOP		16
  #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64

  #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */

diff --git a/arch/m68k/include/asm/termbits.h b/arch/m68k/include/asm/termbits.h
index 8c14170..aea1e37 100644
--- a/arch/m68k/include/asm/termbits.h
+++ b/arch/m68k/include/asm/termbits.h
@@ -179,6 +179,7 @@ struct ktermios {
  #define FLUSHO	0010000
  #define PENDIN	0040000
  #define IEXTEN	0100000
+#define EXTPROC	0200000


  /* tcflow() and TCXONC use these */
diff --git a/arch/mips/include/asm/ioctls.h b/arch/mips/include/asm/ioctls.h
index 3f04a99..767d196 100644
--- a/arch/mips/include/asm/ioctls.h
+++ b/arch/mips/include/asm/ioctls.h
@@ -41,7 +41,7 @@
  #define	 TIOCPKT_START		0x08	/* start output */
  #define	 TIOCPKT_NOSTOP		0x10	/* no more ^S, ^Q */
  #define	 TIOCPKT_DOSTOP		0x20	/* now do ^S ^Q */
-/* #define  TIOCPKT_IOCTL		0x40	state change of pty driver */
+#define  TIOCPKT_IOCTL		0x40	/* state change of pty driver */
  #define TIOCSWINSZ	_IOW('t', 103, struct winsize)	/* set window size */
  #define TIOCGWINSZ	_IOR('t', 104, struct winsize)	/* get window size */
  #define TIOCNOTTY	0x5471		/* void tty association */
@@ -83,6 +83,7 @@
  #define TCSETSF2	_IOW('T', 0x2D, struct termios2)
  #define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number (of pty-mux 
device) */
  #define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T', 0x36, int)  /* Generate signal on Pty slave */

  /* I hope the range from 0x5480 on is free ... */
  #define TIOCSCTTY	0x5480		/* become controlling tty */
diff --git a/arch/mips/include/asm/termbits.h b/arch/mips/include/asm/termbits.h
index c83c684..76630b3 100644
--- a/arch/mips/include/asm/termbits.h
+++ b/arch/mips/include/asm/termbits.h
@@ -203,6 +203,7 @@ struct ktermios {
  #define PENDIN	0040000		/* Retype pending input (state).  */
  #define TOSTOP	0100000		/* Send SIGTTOU for background output.  */
  #define ITOSTOP	TOSTOP
+#define EXTPROC	0200000		/* External processing on pty */

  /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
  #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
diff --git a/arch/mn10300/include/asm/ioctls.h b/arch/mn10300/include/asm/ioctls.h
index dcbfb45..c149fe1 100644
--- a/arch/mn10300/include/asm/ioctls.h
+++ b/arch/mn10300/include/asm/ioctls.h
@@ -54,6 +54,7 @@
  #define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number
  						       * (of pty-mux device) */
  #define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T', 0x36, int)  /* Generate signal on Pty slave */

  #define FIONCLEX	0x5450
  #define FIOCLEX		0x5451
@@ -82,6 +83,7 @@
  #define TIOCPKT_START		 8
  #define TIOCPKT_NOSTOP		16
  #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64

  #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */

diff --git a/arch/mn10300/include/asm/termbits.h 
b/arch/mn10300/include/asm/termbits.h
index eb2b0dc..130d424 100644
--- a/arch/mn10300/include/asm/termbits.h
+++ b/arch/mn10300/include/asm/termbits.h
@@ -180,6 +180,7 @@ struct ktermios {
  #define FLUSHO	0010000
  #define PENDIN	0040000
  #define IEXTEN	0100000
+#define EXTPROC	0200000

  /* tcflow() and TCXONC use these */
  #define	TCOOFF		0
diff --git a/arch/parisc/include/asm/ioctls.h b/arch/parisc/include/asm/ioctls.h
index 6747fad..bf73dbb 100644
--- a/arch/parisc/include/asm/ioctls.h
+++ b/arch/parisc/include/asm/ioctls.h
@@ -52,6 +52,7 @@
  #define TCSETSF2	_IOW('T',0x2D, struct termios2)
  #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux 
device) */
  #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */

  #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
  #define FIOCLEX		0x5451
@@ -84,6 +85,7 @@
  #define TIOCPKT_START		 8
  #define TIOCPKT_NOSTOP		16
  #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64

  #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */

diff --git a/arch/parisc/include/asm/termbits.h 
b/arch/parisc/include/asm/termbits.h
index d8bbc73..d1ab921 100644
--- a/arch/parisc/include/asm/termbits.h
+++ b/arch/parisc/include/asm/termbits.h
@@ -180,6 +180,7 @@ struct ktermios {
  #define FLUSHO  0010000
  #define PENDIN  0040000
  #define IEXTEN  0100000
+#define EXTPROC	0200000

  /* tcflow() and TCXONC use these */
  #define	TCOOFF		0
diff --git a/arch/powerpc/include/asm/ioctls.h b/arch/powerpc/include/asm/ioctls.h
index 1842186..8519200 100644
--- a/arch/powerpc/include/asm/ioctls.h
+++ b/arch/powerpc/include/asm/ioctls.h
@@ -80,6 +80,7 @@
  # define TIOCPKT_START		 8
  # define TIOCPKT_NOSTOP		16
  # define TIOCPKT_DOSTOP		32
+# define TIOCPKT_IOCTL		64


  #define TIOCNOTTY	0x5422
@@ -93,6 +94,7 @@
  #define TIOCSRS485	0x542f
  #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux 
device) */
  #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */

  #define TIOCSERCONFIG	0x5453
  #define TIOCSERGWILD	0x5454
diff --git a/arch/powerpc/include/asm/termbits.h 
b/arch/powerpc/include/asm/termbits.h
index 6698188..549d700 100644
--- a/arch/powerpc/include/asm/termbits.h
+++ b/arch/powerpc/include/asm/termbits.h
@@ -189,6 +189,7 @@ struct ktermios {
  #define FLUSHO	0x00800000
  #define PENDIN	0x20000000
  #define IEXTEN	0x00000400
+#define EXTPROC	0x10000000

  /* Values for the ACTION argument to `tcflow'.  */
  #define	TCOOFF		0
diff --git a/arch/s390/include/asm/ioctls.h b/arch/s390/include/asm/ioctls.h
index 40e481b..2f3d873 100644
--- a/arch/s390/include/asm/ioctls.h
+++ b/arch/s390/include/asm/ioctls.h
@@ -60,6 +60,7 @@
  #define TCSETSF2	_IOW('T',0x2D, struct termios2)
  #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux 
device) */
  #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */

  #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
  #define FIOCLEX		0x5451
@@ -86,6 +87,7 @@
  #define TIOCPKT_START		 8
  #define TIOCPKT_NOSTOP		16
  #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64

  #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */

diff --git a/arch/sh/include/asm/ioctls.h b/arch/sh/include/asm/ioctls.h
index c212c37..eb6c4c6 100644
--- a/arch/sh/include/asm/ioctls.h
+++ b/arch/sh/include/asm/ioctls.h
@@ -69,6 +69,7 @@
  # define TIOCPKT_START		 8
  # define TIOCPKT_NOSTOP		16
  # define TIOCPKT_DOSTOP		32
+# define TIOCPKT_IOCTL		64


  #define TIOCNOTTY	_IO('T', 34) /* 0x5422 */
@@ -84,6 +85,7 @@
  #define TCSETSF2	_IOW('T', 45, struct termios2)
  #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux 
device) */
  #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */

  #define TIOCSERCONFIG	_IO('T', 83) /* 0x5453 */
  #define TIOCSERGWILD	_IOR('T', 84,  int) /* 0x5454 */
diff --git a/arch/sparc/include/asm/ioctls.h b/arch/sparc/include/asm/ioctls.h
index 1fe6855..53f4ee0 100644
--- a/arch/sparc/include/asm/ioctls.h
+++ b/arch/sparc/include/asm/ioctls.h
@@ -80,6 +80,7 @@
  /* Get minor device of a pty master's FD -- Solaris equiv is ISPTM */
  #define TIOCGPTN	_IOR('t', 134, unsigned int) /* Get Pty Number */
  #define TIOCSPTLCK	_IOW('t', 135, int) /* Lock/unlock PTY */
+#define TIOCSIG		_IOW('t', 136, int) /* Generate signal on Pty slave */

  /* Little f */
  #define FIOCLEX		_IO('f', 1)
@@ -132,5 +133,6 @@
  #define TIOCPKT_START		 8
  #define TIOCPKT_NOSTOP		16
  #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64

  #endif /* !(_ASM_SPARC_IOCTLS_H) */
diff --git a/arch/sparc/include/asm/termbits.h b/arch/sparc/include/asm/termbits.h
index d72dfed..23b10ff 100644
--- a/arch/sparc/include/asm/termbits.h
+++ b/arch/sparc/include/asm/termbits.h
@@ -225,6 +225,7 @@ struct ktermios {
  #define FLUSHO	0x00002000
  #define PENDIN	0x00004000
  #define IEXTEN	0x00008000
+#define EXTPROC	0x00010000

  /* modem lines */
  #define TIOCM_LE	0x001
diff --git a/arch/xtensa/include/asm/ioctls.h b/arch/xtensa/include/asm/ioctls.h
index 0ffa942..ab18000 100644
--- a/arch/xtensa/include/asm/ioctls.h
+++ b/arch/xtensa/include/asm/ioctls.h
@@ -81,6 +81,7 @@
  # define TIOCPKT_START		 8
  # define TIOCPKT_NOSTOP		16
  # define TIOCPKT_DOSTOP		32
+# define TIOCPKT_IOCTL		64


  #define TIOCNOTTY	_IO('T', 34)
@@ -97,6 +98,7 @@
  #define TCSETSF2	_IOW('T', 45, struct termios2)
  #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux 
device) */
  #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */

  #define TIOCSERCONFIG	_IO('T', 83)
  #define TIOCSERGWILD	_IOR('T', 84,  int)
diff --git a/arch/xtensa/include/asm/termbits.h 
b/arch/xtensa/include/asm/termbits.h
index 85aa6a3..0d6c871 100644
--- a/arch/xtensa/include/asm/termbits.h
+++ b/arch/xtensa/include/asm/termbits.h
@@ -196,6 +196,7 @@ struct ktermios {
  #define FLUSHO	0010000
  #define PENDIN	0040000
  #define IEXTEN	0100000
+#define EXTPROC	0200000

  /* tcflow() and TCXONC use these */

-- 1.7.0.4

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
