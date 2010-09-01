Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab0IAHVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 03:21:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50833 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab0IAHVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 03:21:20 -0400
Date: Wed, 1 Sep 2010 08:21:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 01/10] ioctl: Use asm-generic/ioctls.h on arm (enables
	termiox)
Message-ID: <20100901072108.GD8142@n2100.arm.linux.org.uk>
References: <20100820211401.651509182@suse.com> <20100820211537.982686153@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820211537.982686153@suse.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ensure that you Cc the ARM kernel mailing list.

Patch looks good in any case.  Who's going to handle this?

On Fri, Aug 20, 2010 at 05:14:02PM -0400, Jeff Mahoney wrote:
> This patch converts arm to use asm-generic/ioctls.h instead of its
> own version.
> 
> The differences between the arch-specific version and the generic
> version are as follows:
> 
> - ARM defines its own value for FIOQSIZE, asm-generic/ioctls.h keeps it
> - The generic version adds support for termiox
> 
> Cc: Russell King <linux@arm.linux.org.uk>

Reviewed-by: Russell King <rmk+kernel@arm.linux.org.uk>

> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
> 
>  arch/arm/include/asm/ioctls.h |   83 ------------------------------------------
>  1 file changed, 1 insertion(+), 82 deletions(-)
> 
> --- a/arch/arm/include/asm/ioctls.h
> +++ b/arch/arm/include/asm/ioctls.h
> @@ -1,89 +1,8 @@
>  #ifndef __ASM_ARM_IOCTLS_H
>  #define __ASM_ARM_IOCTLS_H
>  
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
> -#define TIOCGRS485      0x542E
> -#define TIOCSRS485      0x542F
> -
> -#define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
> -#define FIOCLEX		0x5451
> -#define FIOASYNC	0x5452
> -#define TIOCSERCONFIG	0x5453
> -#define TIOCSERGWILD	0x5454
> -#define TIOCSERSWILD	0x5455
> -#define TIOCGLCKTRMIOS	0x5456
> -#define TIOCSLCKTRMIOS	0x5457
> -#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
> -#define TIOCSERGETLSR   0x5459 /* Get line status register */
> -#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
> -#define TIOCSERSETMULTI 0x545B /* Set multiport config */
> -
> -#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
> -#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
>  #define FIOQSIZE	0x545E
>  
> -/* Used for packet mode */
> -#define TIOCPKT_DATA		 0
> -#define TIOCPKT_FLUSHREAD	 1
> -#define TIOCPKT_FLUSHWRITE	 2
> -#define TIOCPKT_STOP		 4
> -#define TIOCPKT_START		 8
> -#define TIOCPKT_NOSTOP		16
> -#define TIOCPKT_DOSTOP		32
> -#define TIOCPKT_IOCTL		64
> -
> -#define TIOCSER_TEMT	0x01	/* Transmitter physically empty */
> +#include <asm-generic/ioctls.h>
>  
>  #endif
> 
> 
