Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab0JYO1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:27:04 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:39417 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab0JYO1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:27:03 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Oct 2010 10:27:02 EDT
Date: Mon, 25 Oct 2010 16:10:38 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>, Mikael Starvik <starvik@axis.com>
Subject: Re: [PATCH 08/49] ioctl: Use asm-generic/ioctls.h on cris (enables
	termiox)
Message-ID: <20101025141038.GH5043@axis.com>
References: <20101022175112.GC13489@kroah.com> <1287771688-14805-8-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287771688-14805-8-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 08:20:47PM +0200, Greg Kroah-Hartman wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> This patch converts cris to use asm-generic/ioctls.h instead of its
> own version.
> 
> The differences between the arch-specific version and the generic
> version are as follows:
> 
> - CRIS defines two ioctls: TIOCSERSETRS485 and TIOCSERWRRS485,
>   kept in arch-specific portion
> - CRIS defines a different value for TIOCSRS485, kept via ifndef in generic
> - The generic version adds support for termiox

Excellent, looks great.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Cc: Mikael Starvik <starvik@axis.com>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  arch/cris/include/asm/ioctls.h |   84 +---------------------------------------
>  include/asm-generic/ioctls.h   |    2 +
>  2 files changed, 3 insertions(+), 83 deletions(-)
> 
> diff --git a/arch/cris/include/asm/ioctls.h b/arch/cris/include/asm/ioctls.h
> index c9129ed..488fbb3 100644
> --- a/arch/cris/include/asm/ioctls.h
> +++ b/arch/cris/include/asm/ioctls.h
> @@ -1,93 +1,11 @@
>  #ifndef __ARCH_CRIS_IOCTLS_H__
>  #define __ARCH_CRIS_IOCTLS_H__
>  
> -/* verbatim copy of asm-i386/ioctls.h */
> -
> -#include <asm/ioctl.h>
> -
> -/* 0x54 is just a magic number to make these relatively unique ('T') */
> -
> -#define TCGETS		0x5401
> -#define TCSETS		0x5402
> -#define TCSETSW		0x5403
> -#define TCSETSF		0x5404
> -#define TCGETA		0x5405
> -#define TCSETA		0x5406
> -#define TCSETAW		0x5407
> -#define TCSETAF		0x5408
> -#define TCSBRK		0x5409
> -#define TCXONC		0x540A
> -#define TCFLSH		0x540B
> -#define TIOCEXCL	0x540C
> -#define TIOCNXCL	0x540D
> -#define TIOCSCTTY	0x540E
> -#define TIOCGPGRP	0x540F
> -#define TIOCSPGRP	0x5410
> -#define TIOCOUTQ	0x5411
> -#define TIOCSTI		0x5412
> -#define TIOCGWINSZ	0x5413
> -#define TIOCSWINSZ	0x5414
> -#define TIOCMGET	0x5415
> -#define TIOCMBIS	0x5416
> -#define TIOCMBIC	0x5417
> -#define TIOCMSET	0x5418
> -#define TIOCGSOFTCAR	0x5419
> -#define TIOCSSOFTCAR	0x541A
> -#define FIONREAD	0x541B
> -#define TIOCINQ		FIONREAD
> -#define TIOCLINUX	0x541C
> -#define TIOCCONS	0x541D
> -#define TIOCGSERIAL	0x541E
> -#define TIOCSSERIAL	0x541F
> -#define TIOCPKT		0x5420
> -#define FIONBIO		0x5421
> -#define TIOCNOTTY	0x5422
> -#define TIOCSETD	0x5423
> -#define TIOCGETD	0x5424
> -#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
> -#define TIOCSBRK	0x5427  /* BSD compatibility */
> -#define TIOCCBRK	0x5428  /* BSD compatibility */
> -#define TIOCGSID	0x5429  /* Return the session ID of FD */
> -#define TCGETS2		_IOR('T',0x2A, struct termios2)
> -#define TCSETS2		_IOW('T',0x2B, struct termios2)
> -#define TCSETSW2	_IOW('T',0x2C, struct termios2)
> -#define TCSETSF2	_IOW('T',0x2D, struct termios2)
> -#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
> -#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
> -#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
> -
> -#define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
> -#define FIOCLEX		0x5451
> -#define FIOASYNC	0x5452
> -#define TIOCSERCONFIG	0x5453
> -#define TIOCSERGWILD	0x5454
> -#define TIOCSERSWILD	0x5455
> -#define TIOCGLCKTRMIOS	0x5456
> -#define TIOCSLCKTRMIOS	0x5457
>  #define TIOCSERGSTRUCT	0x5458 /* For debugging only */
> -#define TIOCSERGETLSR   0x5459 /* Get line status register */
> -#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
> -#define TIOCSERSETMULTI 0x545B /* Set multiport config */
> -
> -#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
> -#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
> -#define FIOQSIZE	0x5460
> -
>  #define TIOCSERSETRS485	0x5461  /* enable rs-485 (deprecated) */
>  #define TIOCSERWRRS485	0x5462  /* write rs-485 */
>  #define TIOCSRS485	0x5463  /* enable rs-485 */
> -#define TIOCGRS485	0x542E  /* get rs-485 */
> -
> -/* Used for packet mode */
> -#define TIOCPKT_DATA		 0
> -#define TIOCPKT_FLUSHREAD	 1
> -#define TIOCPKT_FLUSHWRITE	 2
> -#define TIOCPKT_STOP		 4
> -#define TIOCPKT_START		 8
> -#define TIOCPKT_NOSTOP		16
> -#define TIOCPKT_DOSTOP		32
> -#define TIOCPKT_IOCTL		64
>  
> -#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
> +#include <asm-generic/ioctls.h>
>  
>  #endif
> diff --git a/include/asm-generic/ioctls.h b/include/asm-generic/ioctls.h
> index 8554cb6..a321665 100644
> --- a/include/asm-generic/ioctls.h
> +++ b/include/asm-generic/ioctls.h
> @@ -62,7 +62,9 @@
>  #define TCSETSW2	_IOW('T', 0x2C, struct termios2)
>  #define TCSETSF2	_IOW('T', 0x2D, struct termios2)
>  #define TIOCGRS485	0x542E
> +#ifndef TIOCSRS485
>  #define TIOCSRS485	0x542F
> +#endif
>  #define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
>  #define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
>  #define TCGETX		0x5432 /* SYS5 TCGETX compatibility */
> -- 
> 1.7.2
/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
