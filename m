Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab0HTVT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 17:19:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:39313 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab0HTVSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 17:18:34 -0400
Message-Id: <20100820211539.359886978@suse.com>
User-Agent: quilt/0.47-15.10
Date: Fri, 20 Aug 2010 17:14:11 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 10/10] ioctl: Use asm-generic/ioctls.h on s390 (enables termiox)
References: <20100820211401.651509182@suse.com>
Content-Disposition: inline; filename=ioctl-use-asm-generic-ioctls-h-on-s390
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts s390 to use asm-generic/ioctls.h instead of its
own version.

The differences between the arch-specific version and the generic
version are as follows:

- S390 defines its own value for FIOQSIZE, asm-generic/ioctls.h keeps it
- The generic version adds TIOCGRS485 and TIOCGRS485, which are unused
  by any driver available on this architecture
- The generic version adds support for termiox

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 arch/s390/include/asm/ioctls.h |   88 -----------------------------------------
 1 file changed, 1 insertion(+), 87 deletions(-)

--- a/arch/s390/include/asm/ioctls.h
+++ b/arch/s390/include/asm/ioctls.h
@@ -1,94 +1,8 @@
-/*
- *  include/asm-s390/ioctls.h
- *
- *  S390 version
- *
- *  Derived from "include/asm-i386/ioctls.h"
- */
-
 #ifndef __ARCH_S390_IOCTLS_H__
 #define __ARCH_S390_IOCTLS_H__
 
-#include <asm/ioctl.h>
-
-/* 0x54 is just a magic number to make these relatively unique ('T') */
-
-#define TCGETS		0x5401
-#define TCSETS		0x5402
-#define TCSETSW		0x5403
-#define TCSETSF		0x5404
-#define TCGETA		0x5405
-#define TCSETA		0x5406
-#define TCSETAW		0x5407
-#define TCSETAF		0x5408
-#define TCSBRK		0x5409
-#define TCXONC		0x540A
-#define TCFLSH		0x540B
-#define TIOCEXCL	0x540C
-#define TIOCNXCL	0x540D
-#define TIOCSCTTY	0x540E
-#define TIOCGPGRP	0x540F
-#define TIOCSPGRP	0x5410
-#define TIOCOUTQ	0x5411
-#define TIOCSTI		0x5412
-#define TIOCGWINSZ	0x5413
-#define TIOCSWINSZ	0x5414
-#define TIOCMGET	0x5415
-#define TIOCMBIS	0x5416
-#define TIOCMBIC	0x5417
-#define TIOCMSET	0x5418
-#define TIOCGSOFTCAR	0x5419
-#define TIOCSSOFTCAR	0x541A
-#define FIONREAD	0x541B
-#define TIOCINQ		FIONREAD
-#define TIOCLINUX	0x541C
-#define TIOCCONS	0x541D
-#define TIOCGSERIAL	0x541E
-#define TIOCSSERIAL	0x541F
-#define TIOCPKT		0x5420
-#define FIONBIO		0x5421
-#define TIOCNOTTY	0x5422
-#define TIOCSETD	0x5423
-#define TIOCGETD	0x5424
-#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
-#define TIOCSBRK	0x5427  /* BSD compatibility */
-#define TIOCCBRK	0x5428  /* BSD compatibility */
-#define TIOCGSID	0x5429  /* Return the session ID of FD */
-#define TCGETS2		_IOR('T',0x2A, struct termios2)
-#define TCSETS2		_IOW('T',0x2B, struct termios2)
-#define TCSETSW2	_IOW('T',0x2C, struct termios2)
-#define TCSETSF2	_IOW('T',0x2D, struct termios2)
-#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
-#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
-#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
-
-#define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
-#define FIOCLEX		0x5451
-#define FIOASYNC	0x5452
-#define TIOCSERCONFIG	0x5453
-#define TIOCSERGWILD	0x5454
-#define TIOCSERSWILD	0x5455
-#define TIOCGLCKTRMIOS	0x5456
-#define TIOCSLCKTRMIOS	0x5457
-#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
-#define TIOCSERGETLSR   0x5459 /* Get line status register */
-#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
-#define TIOCSERSETMULTI 0x545B /* Set multiport config */
-
-#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
-#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
 #define FIOQSIZE	0x545E
 
-/* Used for packet mode */
-#define TIOCPKT_DATA		 0
-#define TIOCPKT_FLUSHREAD	 1
-#define TIOCPKT_FLUSHWRITE	 2
-#define TIOCPKT_STOP		 4
-#define TIOCPKT_START		 8
-#define TIOCPKT_NOSTOP		16
-#define TIOCPKT_DOSTOP		32
-#define TIOCPKT_IOCTL		64
-
-#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
+#include <asm-generic/ioctls.h>
 
 #endif


