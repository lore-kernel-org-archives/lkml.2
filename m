Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590Ab0JFSHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:07:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58341 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759532Ab0JFSGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:06:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 8/8] arm: remove generic asm header file contents
Date: Wed,  6 Oct 2010 20:06:20 +0200
Message-Id: <1286388380-20646-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286388380-20646-1-git-send-email-arnd@arndb.de>
References: <1286388380-20646-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:SW5Y/yBpJ5BQMOK/X768pzWYnybVLLIeIxCygEuekPb
 Zr7Uz75ngbGawkiRO1rpeHeZblwKlrdcvMI3xgZrg3PI93bhn5
 5hGFkI+qI2gu045vZUQtrVsG2ZcA162rcQvbON2lCv2tgAMV8X
 20A5cTfnbaW1zC+GPXRafnrEh8t7bjvIzNPXeuPIl7iI8bZ3JT
 A4QxYMMFJRmoAsu0T/a1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the generic version of the header file reduces
the amount of code that needs to be maintained in the
ARM architecture in case of ABI changes.

These 17 header files have been previously converted
to look like their generic counterparts in order to
guarantee that replacing the implementation with the
generic include does not have any unintended consequences.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/ioctls.h      |   95 +-----------------
 arch/arm/include/asm/ipcbuf.h      |   35 +------
 arch/arm/include/asm/msgbuf.h      |   48 +---------
 arch/arm/include/asm/param.h       |   35 +------
 arch/arm/include/asm/parport.h     |   32 +------
 arch/arm/include/asm/posix_types.h |  163 +-----------------------------
 arch/arm/include/asm/segment.h     |   10 +--
 arch/arm/include/asm/sembuf.h      |   39 +-------
 arch/arm/include/asm/serial.h      |   27 +-----
 arch/arm/include/asm/shmbuf.h      |   60 +-----------
 arch/arm/include/asm/signal.h      |  130 +-----------------------
 arch/arm/include/asm/socket.h      |   68 +------------
 arch/arm/include/asm/sockios.h     |   14 +---
 arch/arm/include/asm/termbits.h    |  200 +-----------------------------------
 arch/arm/include/asm/termios.h     |  155 +---------------------------
 arch/arm/include/asm/timex.h       |   16 +---
 arch/arm/include/asm/types.h       |   43 +--------
 17 files changed, 17 insertions(+), 1153 deletions(-)

diff --git a/arch/arm/include/asm/ioctls.h b/arch/arm/include/asm/ioctls.h
index 0040d08..6917be1 100644
--- a/arch/arm/include/asm/ioctls.h
+++ b/arch/arm/include/asm/ioctls.h
@@ -4,99 +4,6 @@
 /* ARM uses a different value from the asm-generic definition for this */
 #define FIOQSIZE	0x545E
 
-#include <linux/ioctl.h>
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
-#define TCGETS2		_IOR('T', 0x2A, struct termios2)
-#define TCSETS2		_IOW('T', 0x2B, struct termios2)
-#define TCSETSW2	_IOW('T', 0x2C, struct termios2)
-#define TCSETSF2	_IOW('T', 0x2D, struct termios2)
-#define TIOCGRS485	0x542E
-#define TIOCSRS485	0x542F
-#define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
-#define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
-#define TCGETX		0x5432 /* SYS5 TCGETX compatibility */
-#define TCSETX		0x5433
-#define TCSETXF		0x5434
-#define TCSETXW		0x5435
-#define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
-
-#define FIONCLEX	0x5450
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
-
-/*
- * Some arches already define FIOQSIZE due to a historical
- * conflict with a Hayes modem-specific ioctl value.
- */
-#ifndef FIOQSIZE
-# define FIOQSIZE	0x5460
-#endif
-
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
-#define TIOCSER_TEMT	0x01	/* Transmitter physically empty */
+#include <asm-generic/ioctls.h>
 
 #endif
diff --git a/arch/arm/include/asm/ipcbuf.h b/arch/arm/include/asm/ipcbuf.h
index 40e492d..84c7e51 100644
--- a/arch/arm/include/asm/ipcbuf.h
+++ b/arch/arm/include/asm/ipcbuf.h
@@ -1,34 +1 @@
-#ifndef __ASMARM_IPCBUF_H
-#define __ASMARM_IPCBUF_H
-
-/*
- * The generic ipc64_perm structure:
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * ipc64_perm was originally meant to be architecture specific, but
- * everyone just ended up making identical copies without specific
- * optimizations, so we may just as well all use the same one.
- *
- * Pad space is left for:
- * - 32-bit mode_t on architectures that only had 16 bit
- * - 32-bit seq
- * - 2 miscellaneous 32-bit values
- */
-
-struct ipc64_perm {
-	__kernel_key_t		key;
-	__kernel_uid32_t	uid;
-	__kernel_gid32_t	gid;
-	__kernel_uid32_t	cuid;
-	__kernel_gid32_t	cgid;
-	__kernel_mode_t		mode;
-				/* pad if mode_t is u16: */
-	unsigned char		__pad1[4 - sizeof(__kernel_mode_t)];
-	unsigned short		seq;
-	unsigned short		__pad2;
-	unsigned long		__unused1;
-	unsigned long		__unused2;
-};
-
-#endif /* __ASMARM_IPCBUF_H */
+#include <asm-generic/ipcbuf.h>
diff --git a/arch/arm/include/asm/msgbuf.h b/arch/arm/include/asm/msgbuf.h
index ca4e383..809134c 100644
--- a/arch/arm/include/asm/msgbuf.h
+++ b/arch/arm/include/asm/msgbuf.h
@@ -1,47 +1 @@
-#ifndef _ASMARM_MSGBUF_H
-#define _ASMARM_MSGBUF_H
-
-#include <asm/bitsperlong.h>
-/*
- * generic msqid64_ds structure.
- *
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * msqid64_ds was originally meant to be architecture specific, but
- * everyone just ended up making identical copies without specific
- * optimizations, so we may just as well all use the same one.
- *
- * 64 bit architectures typically define a 64 bit __kernel_time_t,
- * so they do not need the first three padding words.
- * On big-endian systems, the padding is in the wrong place.
- *
- * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem
- * - 2 miscellaneous 32-bit values
- */
-
-struct msqid64_ds {
-	struct ipc64_perm msg_perm;
-	__kernel_time_t msg_stime;	/* last msgsnd time */
-#if __BITS_PER_LONG != 64
-	unsigned long	__unused1;
-#endif
-	__kernel_time_t msg_rtime;	/* last msgrcv time */
-#if __BITS_PER_LONG != 64
-	unsigned long	__unused2;
-#endif
-	__kernel_time_t msg_ctime;	/* last change time */
-#if __BITS_PER_LONG != 64
-	unsigned long	__unused3;
-#endif
-	unsigned long  msg_cbytes;	/* current number of bytes on queue */
-	unsigned long  msg_qnum;	/* number of messages in queue */
-	unsigned long  msg_qbytes;	/* max number of bytes on queue */
-	__kernel_pid_t msg_lspid;	/* pid of last msgsnd */
-	__kernel_pid_t msg_lrpid;	/* last receive pid */
-	unsigned long  __unused4;
-	unsigned long  __unused5;
-};
-
-#endif /* _ASMARM_MSGBUF_H */
+#include <asm-generic/msgbuf.h>
diff --git a/arch/arm/include/asm/param.h b/arch/arm/include/asm/param.h
index eaca062..965d454 100644
--- a/arch/arm/include/asm/param.h
+++ b/arch/arm/include/asm/param.h
@@ -1,34 +1 @@
-/*
- *  arch/arm/include/asm/param.h
- *
- *  Copyright (C) 1995-1999 Russell King
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef __ASM_PARAM_H
-#define __ASM_PARAM_H
-
-
-#ifdef __KERNEL__
-# define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
-# define USER_HZ	100		/* some user interfaces are */
-# define CLOCKS_PER_SEC	(USER_HZ)       /* in "ticks" like times() */
-#endif
-
-#ifndef HZ
-#define HZ 100
-#endif
-
-#ifndef EXEC_PAGESIZE
-#define EXEC_PAGESIZE	4096
-#endif
-
-#ifndef NOGROUP
-#define NOGROUP		(-1)
-#endif
-
-#define MAXHOSTNAMELEN	64	/* max length of hostname */
-
-#endif
+#include <asm-generic/param.h>
diff --git a/arch/arm/include/asm/parport.h b/arch/arm/include/asm/parport.h
index b4c19a8..cf252af 100644
--- a/arch/arm/include/asm/parport.h
+++ b/arch/arm/include/asm/parport.h
@@ -1,31 +1 @@
-/*
- *  arch/arm/include/asm/parport.h: ARM-specific parport initialisation
- *
- *  Copyright (C) 1999, 2000  Tim Waugh <tim@cyberelk.demon.co.uk>
- *
- * This file should only be included by drivers/parport/parport_pc.c.
- */
-
-#ifndef __ASMARM_PARPORT_H
-#define __ASMARM_PARPORT_H
-
-/*
- * An ISA bus may have i8255 parallel ports at well-known
- * locations in the I/O space, which are scanned by
- * parport_pc_find_isa_ports.
- *
- * Without ISA support, the driver will only attach
- * to devices on the PCI bus.
- */
-
-static int __devinit parport_pc_find_isa_ports(int autoirq, int autodma);
-static int __devinit parport_pc_find_nonpci_ports(int autoirq, int autodma)
-{
-#ifdef CONFIG_ISA
-	return parport_pc_find_isa_ports(autoirq, autodma);
-#else
-	return 0;
-#endif
-}
-
-#endif /* !(_ASMARM_PARPORT_H) */
+#include <asm-generic/parport.h>
diff --git a/arch/arm/include/asm/posix_types.h b/arch/arm/include/asm/posix_types.h
index 558cf4b..34aa045 100644
--- a/arch/arm/include/asm/posix_types.h
+++ b/arch/arm/include/asm/posix_types.h
@@ -48,167 +48,6 @@ typedef unsigned short		__kernel_old_gid_t;
 typedef unsigned short		__kernel_old_dev_t;
 #define __kernel_old_dev_t	__kernel_old_dev_t
 
-/* generic contents from here */
-
-#include <asm/bitsperlong.h>
-/*
- * This file is generally used by user-level software, so you need to
- * be a little careful about namespace pollution etc.
- *
- * First the types that are often defined in different ways across
- * architectures, so that you can override them.
- */
-
-#ifndef __kernel_ino_t
-typedef unsigned long	__kernel_ino_t;
-#endif
-
-#ifndef __kernel_mode_t
-typedef unsigned int	__kernel_mode_t;
-#endif
-
-#ifndef __kernel_nlink_t
-typedef unsigned long	__kernel_nlink_t;
-#endif
-
-#ifndef __kernel_pid_t
-typedef int		__kernel_pid_t;
-#endif
-
-#ifndef __kernel_ipc_pid_t
-typedef int		__kernel_ipc_pid_t;
-#endif
-
-#ifndef __kernel_uid_t
-typedef unsigned int	__kernel_uid_t;
-typedef unsigned int	__kernel_gid_t;
-#endif
-
-#ifndef __kernel_suseconds_t
-typedef long		__kernel_suseconds_t;
-#endif
-
-#ifndef __kernel_daddr_t
-typedef int		__kernel_daddr_t;
-#endif
-
-#ifndef __kernel_uid32_t
-typedef __kernel_uid_t	__kernel_uid32_t;
-typedef __kernel_gid_t	__kernel_gid32_t;
-#endif
-
-#ifndef __kernel_old_uid_t
-typedef __kernel_uid_t	__kernel_old_uid_t;
-typedef __kernel_gid_t	__kernel_old_gid_t;
-#endif
-
-#ifndef __kernel_old_dev_t
-typedef unsigned int	__kernel_old_dev_t;
-#endif
-
-/*
- * Most 32 bit architectures use "unsigned int" size_t,
- * and all 64 bit architectures use "unsigned long" size_t.
- */
-#ifndef __kernel_size_t
-#if __BITS_PER_LONG != 64
-typedef unsigned int	__kernel_size_t;
-typedef int		__kernel_ssize_t;
-typedef int		__kernel_ptrdiff_t;
-#else
-typedef unsigned long	__kernel_size_t;
-typedef long		__kernel_ssize_t;
-typedef long		__kernel_ptrdiff_t;
-#endif
-#endif
-
-/*
- * anything below here should be completely generic
- */
-typedef long		__kernel_off_t;
-typedef long long	__kernel_loff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#ifdef __KERNEL__
-
-#undef __FD_SET
-static inline void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
-}
-
-#undef __FD_CLR
-static inline void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
-}
-
-#undef __FD_ISSET
-static inline int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__p)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant case (8 ints,
- * for a 256-bit fd_set)
- */
-#undef __FD_ZERO
-static inline void __FD_ZERO(__kernel_fd_set *__p)
-{
-	unsigned long *__tmp = __p->fds_bits;
-	int __i;
-
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		case 16:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			__tmp[ 8] = 0; __tmp[ 9] = 0;
-			__tmp[10] = 0; __tmp[11] = 0;
-			__tmp[12] = 0; __tmp[13] = 0;
-			__tmp[14] = 0; __tmp[15] = 0;
-			return;
-
-		case 8:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			return;
-
-		case 4:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			return;
-		}
-	}
-	__i = __FDSET_LONGS;
-	while (__i) {
-		__i--;
-		*__tmp = 0;
-		__tmp++;
-	}
-}
-
-#endif /* __KERNEL__ */
+#include <asm-generic/posix_types.h>
 
 #endif
diff --git a/arch/arm/include/asm/segment.h b/arch/arm/include/asm/segment.h
index b8b7291..f1b81e5 100644
--- a/arch/arm/include/asm/segment.h
+++ b/arch/arm/include/asm/segment.h
@@ -1,9 +1 @@
-#ifndef __ASM_ARM_SEGMENT_H
-#define __ASM_ARM_SEGMENT_H
-/*
- * Only here because we have some old header files that expect it...
- *
- * New architectures probably don't want to have their own version.
- */
-
-#endif /* __ASM_ARM_SEGMENT_H */
+#include <asm-generic/segment.h>
diff --git a/arch/arm/include/asm/sembuf.h b/arch/arm/include/asm/sembuf.h
index f7131b7..7673b83 100644
--- a/arch/arm/include/asm/sembuf.h
+++ b/arch/arm/include/asm/sembuf.h
@@ -1,38 +1 @@
-#ifndef _ASMARM_SEMBUF_H
-#define _ASMARM_SEMBUF_H
-
-#include <asm/bitsperlong.h>
-
-/*
- * The semid64_ds structure for x86 architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * semid64_ds was originally meant to be architecture specific, but
- * everyone just ended up making identical copies without specific
- * optimizations, so we may just as well all use the same one.
- *
- * 64 bit architectures typically define a 64 bit __kernel_time_t,
- * so they do not need the first two padding words.
- * On big-endian systems, the padding is in the wrong place.
- *
- * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem
- * - 2 miscellaneous 32-bit values
- */
-struct semid64_ds {
-	struct ipc64_perm sem_perm;	/* permissions .. see ipc.h */
-	__kernel_time_t	sem_otime;	/* last semop time */
-#if __BITS_PER_LONG != 64
-	unsigned long	__unused1;
-#endif
-	__kernel_time_t	sem_ctime;	/* last change time */
-#if __BITS_PER_LONG != 64
-	unsigned long	__unused2;
-#endif
-	unsigned long	sem_nsems;	/* no. of semaphores in array */
-	unsigned long	__unused3;
-	unsigned long	__unused4;
-};
-
-#endif /* _ASMARM_SEMBUF_H */
+#include <asm-generic/sembuf.h>
diff --git a/arch/arm/include/asm/serial.h b/arch/arm/include/asm/serial.h
index 560f625..a0cb0ca 100644
--- a/arch/arm/include/asm/serial.h
+++ b/arch/arm/include/asm/serial.h
@@ -1,26 +1 @@
-/*
- *  arch/arm/include/asm/serial.h
- *
- *  Copyright (C) 1996 Russell King.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- *  Changelog:
- *   15-10-1996	RMK	Created
- */
-
-#ifndef __ASM_SERIAL_H
-#define __ASM_SERIAL_H
-
-/*
- * This should not be an architecture specific #define, oh well.
- *
- * Traditionally, it just describes i8250 and related serial ports
- * that have this clock rate.
- */
-
-#define BASE_BAUD (1843200 / 16)
-
-#endif
+#include <asm-generic/serial.h>
diff --git a/arch/arm/include/asm/shmbuf.h b/arch/arm/include/asm/shmbuf.h
index 39b1ab0..83c05fc 100644
--- a/arch/arm/include/asm/shmbuf.h
+++ b/arch/arm/include/asm/shmbuf.h
@@ -1,59 +1 @@
-#ifndef _ASMARM_SHMBUF_H
-#define _ASMARM_SHMBUF_H
-
-#include <asm/bitsperlong.h>
-
-/*
- * The shmid64_ds structure for x86 architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * shmid64_ds was originally meant to be architecture specific, but
- * everyone just ended up making identical copies without specific
- * optimizations, so we may just as well all use the same one.
- *
- * 64 bit architectures typically define a 64 bit __kernel_time_t,
- * so they do not need the first two padding words.
- * On big-endian systems, the padding is in the wrong place.
- *
- *
- * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem
- * - 2 miscellaneous 32-bit values
- */
-
-struct shmid64_ds {
-	struct ipc64_perm	shm_perm;	/* operation perms */
-	size_t			shm_segsz;	/* size of segment (bytes) */
-	__kernel_time_t		shm_atime;	/* last attach time */
-#if __BITS_PER_LONG != 64
-	unsigned long		__unused1;
-#endif
-	__kernel_time_t		shm_dtime;	/* last detach time */
-#if __BITS_PER_LONG != 64
-	unsigned long		__unused2;
-#endif
-	__kernel_time_t		shm_ctime;	/* last change time */
-#if __BITS_PER_LONG != 64
-	unsigned long		__unused3;
-#endif
-	__kernel_pid_t		shm_cpid;	/* pid of creator */
-	__kernel_pid_t		shm_lpid;	/* pid of last operator */
-	unsigned long		shm_nattch;	/* no. of current attaches */
-	unsigned long		__unused4;
-	unsigned long		__unused5;
-};
-
-struct shminfo64 {
-	unsigned long	shmmax;
-	unsigned long	shmmin;
-	unsigned long	shmmni;
-	unsigned long	shmseg;
-	unsigned long	shmall;
-	unsigned long	__unused1;
-	unsigned long	__unused2;
-	unsigned long	__unused3;
-	unsigned long	__unused4;
-};
-
-#endif /* _ASMARM_SHMBUF_H */
+#include <asm-generic/shmbuf.h>
diff --git a/arch/arm/include/asm/signal.h b/arch/arm/include/asm/signal.h
index 6c67030..f79be90 100644
--- a/arch/arm/include/asm/signal.h
+++ b/arch/arm/include/asm/signal.h
@@ -15,136 +15,8 @@
  */
 #define SIGSWI		32
 
-/* Generic stuff below */
-#include <linux/types.h>
+#include <asm-generic/signal.h>
 
-#define _NSIG		64
-#define _NSIG_BPW	__BITS_PER_LONG
-#define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
-
-#define SIGHUP		 1
-#define SIGINT		 2
-#define SIGQUIT		 3
-#define SIGILL		 4
-#define SIGTRAP		 5
-#define SIGABRT		 6
-#define SIGIOT		 6
-#define SIGBUS		 7
-#define SIGFPE		 8
-#define SIGKILL		 9
-#define SIGUSR1		10
-#define SIGSEGV		11
-#define SIGUSR2		12
-#define SIGPIPE		13
-#define SIGALRM		14
-#define SIGTERM		15
-#define SIGSTKFLT	16
-#define SIGCHLD		17
-#define SIGCONT		18
-#define SIGSTOP		19
-#define SIGTSTP		20
-#define SIGTTIN		21
-#define SIGTTOU		22
-#define SIGURG		23
-#define SIGXCPU		24
-#define SIGXFSZ		25
-#define SIGVTALRM	26
-#define SIGPROF		27
-#define SIGWINCH	28
-#define SIGIO		29
-#define SIGPOLL		SIGIO
-/*
-#define SIGLOST		29
-*/
-#define SIGPWR		30
-#define SIGSYS		31
-#define	SIGUNUSED	31
-
-/* These should not be considered constants from userland.  */
-#define SIGRTMIN	32
-#ifndef SIGRTMAX
-#define SIGRTMAX	_NSIG
-#endif
-
-/*
- * SA_FLAGS values:
- *
- * SA_ONSTACK indicates that a registered stack_t will be used.
- * SA_SIGINFO deliver the signal with SIGINFO structs
- * SA_RESTART flag to get restarting signals (which were the default long ago)
- * SA_NOCLDSTOP flag to turn off SIGCHLD when children stop.
- * SA_RESETHAND clears the handler when the signal is delivered.
- * SA_NOCLDWAIT flag on SIGCHLD to inhibit zombies.
- * SA_NODEFER prevents the current signal from being masked in the handler.
- *
- * SA_ONESHOT and SA_NOMASK are the historical Linux names for the Single
- * Unix names RESETHAND and NODEFER respectively.
- */
-#define SA_NOCLDSTOP	0x00000001
-#define SA_NOCLDWAIT	0x00000002
-#define SA_SIGINFO	0x00000004
-#define SA_ONSTACK	0x08000000
-#define SA_RESTART	0x10000000
-#define SA_NODEFER	0x40000000
-#define SA_RESETHAND	0x80000000
-
-#define SA_NOMASK	SA_NODEFER
-#define SA_ONESHOT	SA_RESETHAND
-
-/*
- * New architectures should not define the obsolete
- *	SA_RESTORER	0x04000000
- */
-
-/*
- * sigaltstack controls
- */
-#define SS_ONSTACK	1
-#define SS_DISABLE	2
-
-#define MINSIGSTKSZ	2048
-#define SIGSTKSZ	8192
-
-#ifndef __ASSEMBLY__
-typedef struct {
-	unsigned long sig[_NSIG_WORDS];
-} sigset_t;
-
-/* not actually used, but required for linux/syscalls.h */
-typedef unsigned long old_sigset_t;
-
-#include <asm-generic/signal-defs.h>
-
-struct sigaction {
-	__sighandler_t sa_handler;
-	unsigned long sa_flags;
-#ifdef SA_RESTORER
-	__sigrestore_t sa_restorer;
-#endif
-	sigset_t sa_mask;		/* mask last for extensibility */
-};
-
-struct k_sigaction {
-	struct sigaction sa;
-};
-
-typedef struct sigaltstack {
-	void __user *ss_sp;
-	int ss_flags;
-	size_t ss_size;
-} stack_t;
-
-#ifdef __KERNEL__
-
-#include <asm/sigcontext.h>
-#undef __HAVE_ARCH_SIG_BITOPS
-
-#define ptrace_signal_deliver(regs, cookie) do { } while (0)
-
-#endif /* __KERNEL__ */
-#endif /* __ASSEMBLY__ */
-
-/* End generic stuff */
 #ifdef __KERNEL__
 struct old_sigaction {
 	__sighandler_t sa_handler;
diff --git a/arch/arm/include/asm/socket.h b/arch/arm/include/asm/socket.h
index 5a0fbcc..6b71384 100644
--- a/arch/arm/include/asm/socket.h
+++ b/arch/arm/include/asm/socket.h
@@ -1,67 +1 @@
-#ifndef _ASMARM_SOCKET_H
-#define _ASMARM_SOCKET_H
-
-#include <asm/sockios.h>
-
-/* For setsockopt(2) */
-#define SOL_SOCKET	1
-
-#define SO_DEBUG	1
-#define SO_REUSEADDR	2
-#define SO_TYPE		3
-#define SO_ERROR	4
-#define SO_DONTROUTE	5
-#define SO_BROADCAST	6
-#define SO_SNDBUF	7
-#define SO_RCVBUF	8
-#define SO_SNDBUFFORCE	32
-#define SO_RCVBUFFORCE	33
-#define SO_KEEPALIVE	9
-#define SO_OOBINLINE	10
-#define SO_NO_CHECK	11
-#define SO_PRIORITY	12
-#define SO_LINGER	13
-#define SO_BSDCOMPAT	14
-/* To add :#define SO_REUSEPORT 15 */
-
-#ifndef SO_PASSCRED /* powerpc only differs in these */
-#define SO_PASSCRED	16
-#define SO_PEERCRED	17
-#define SO_RCVLOWAT	18
-#define SO_SNDLOWAT	19
-#define SO_RCVTIMEO	20
-#define SO_SNDTIMEO	21
-#endif
-
-/* Security levels - as per NRL IPv6 - don't actually do anything */
-#define SO_SECURITY_AUTHENTICATION		22
-#define SO_SECURITY_ENCRYPTION_TRANSPORT	23
-#define SO_SECURITY_ENCRYPTION_NETWORK		24
-
-#define SO_BINDTODEVICE	25
-
-/* Socket filtering */
-#define SO_ATTACH_FILTER	26
-#define SO_DETACH_FILTER	27
-
-#define SO_PEERNAME		28
-#define SO_TIMESTAMP		29
-#define SCM_TIMESTAMP		SO_TIMESTAMP
-
-#define SO_ACCEPTCONN		30
-
-#define SO_PEERSEC		31
-#define SO_PASSSEC		34
-#define SO_TIMESTAMPNS		35
-#define SCM_TIMESTAMPNS		SO_TIMESTAMPNS
-
-#define SO_MARK			36
-
-#define SO_TIMESTAMPING		37
-#define SCM_TIMESTAMPING	SO_TIMESTAMPING
-
-#define SO_PROTOCOL		38
-#define SO_DOMAIN		39
-
-#define SO_RXQ_OVFL             40
-#endif /* _ASM_SOCKET_H */
+#include <asm-generic/socket.h>
diff --git a/arch/arm/include/asm/sockios.h b/arch/arm/include/asm/sockios.h
index 42b3d72..def6d47 100644
--- a/arch/arm/include/asm/sockios.h
+++ b/arch/arm/include/asm/sockios.h
@@ -1,13 +1 @@
-#ifndef __ARCH_ARM_SOCKIOS_H
-#define __ARCH_ARM_SOCKIOS_H
-
-/* Socket-level I/O control calls. */
-#define FIOSETOWN	0x8901
-#define SIOCSPGRP	0x8902
-#define FIOGETOWN	0x8903
-#define SIOCGPGRP	0x8904
-#define SIOCATMARK	0x8905
-#define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
-#define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
-
-#endif
+#include <asm-generic/sockios.h>
diff --git a/arch/arm/include/asm/termbits.h b/arch/arm/include/asm/termbits.h
index b2e61b9..3935b10 100644
--- a/arch/arm/include/asm/termbits.h
+++ b/arch/arm/include/asm/termbits.h
@@ -1,199 +1 @@
-#ifndef __ASM_ARM_TERMBITS_H
-#define __ASM_ARM_TERMBITS_H
-
-#include <linux/posix_types.h>
-
-typedef unsigned char	cc_t;
-typedef unsigned int	speed_t;
-typedef unsigned int	tcflag_t;
-
-#define NCCS 19
-struct termios {
-	tcflag_t c_iflag;		/* input mode flags */
-	tcflag_t c_oflag;		/* output mode flags */
-	tcflag_t c_cflag;		/* control mode flags */
-	tcflag_t c_lflag;		/* local mode flags */
-	cc_t c_line;			/* line discipline */
-	cc_t c_cc[NCCS];		/* control characters */
-};
-
-struct termios2 {
-	tcflag_t c_iflag;		/* input mode flags */
-	tcflag_t c_oflag;		/* output mode flags */
-	tcflag_t c_cflag;		/* control mode flags */
-	tcflag_t c_lflag;		/* local mode flags */
-	cc_t c_line;			/* line discipline */
-	cc_t c_cc[NCCS];		/* control characters */
-	speed_t c_ispeed;		/* input speed */
-	speed_t c_ospeed;		/* output speed */
-};
-
-struct ktermios {
-	tcflag_t c_iflag;		/* input mode flags */
-	tcflag_t c_oflag;		/* output mode flags */
-	tcflag_t c_cflag;		/* control mode flags */
-	tcflag_t c_lflag;		/* local mode flags */
-	cc_t c_line;			/* line discipline */
-	cc_t c_cc[NCCS];		/* control characters */
-	speed_t c_ispeed;		/* input speed */
-	speed_t c_ospeed;		/* output speed */
-};
-
-/* c_cc characters */
-#define VINTR 0
-#define VQUIT 1
-#define VERASE 2
-#define VKILL 3
-#define VEOF 4
-#define VTIME 5
-#define VMIN 6
-#define VSWTC 7
-#define VSTART 8
-#define VSTOP 9
-#define VSUSP 10
-#define VEOL 11
-#define VREPRINT 12
-#define VDISCARD 13
-#define VWERASE 14
-#define VLNEXT 15
-#define VEOL2 16
-
-/* c_iflag bits */
-#define IGNBRK	0000001
-#define BRKINT	0000002
-#define IGNPAR	0000004
-#define PARMRK	0000010
-#define INPCK	0000020
-#define ISTRIP	0000040
-#define INLCR	0000100
-#define IGNCR	0000200
-#define ICRNL	0000400
-#define IUCLC	0001000
-#define IXON	0002000
-#define IXANY	0004000
-#define IXOFF	0010000
-#define IMAXBEL	0020000
-#define IUTF8	0040000
-
-/* c_oflag bits */
-#define OPOST	0000001
-#define OLCUC	0000002
-#define ONLCR	0000004
-#define OCRNL	0000010
-#define ONOCR	0000020
-#define ONLRET	0000040
-#define OFILL	0000100
-#define OFDEL	0000200
-#define NLDLY	0000400
-#define   NL0	0000000
-#define   NL1	0000400
-#define CRDLY	0003000
-#define   CR0	0000000
-#define   CR1	0001000
-#define   CR2	0002000
-#define   CR3	0003000
-#define TABDLY	0014000
-#define   TAB0	0000000
-#define   TAB1	0004000
-#define   TAB2	0010000
-#define   TAB3	0014000
-#define   XTABS	0014000
-#define BSDLY	0020000
-#define   BS0	0000000
-#define   BS1	0020000
-#define VTDLY	0040000
-#define   VT0	0000000
-#define   VT1	0040000
-#define FFDLY	0100000
-#define   FF0	0000000
-#define   FF1	0100000
-
-/* c_cflag bit meaning */
-#define CBAUD	0010017
-#define  B0	0000000		/* hang up */
-#define  B50	0000001
-#define  B75	0000002
-#define  B110	0000003
-#define  B134	0000004
-#define  B150	0000005
-#define  B200	0000006
-#define  B300	0000007
-#define  B600	0000010
-#define  B1200	0000011
-#define  B1800	0000012
-#define  B2400	0000013
-#define  B4800	0000014
-#define  B9600	0000015
-#define  B19200	0000016
-#define  B38400	0000017
-#define EXTA B19200
-#define EXTB B38400
-#define CSIZE	0000060
-#define   CS5	0000000
-#define   CS6	0000020
-#define   CS7	0000040
-#define   CS8	0000060
-#define CSTOPB	0000100
-#define CREAD	0000200
-#define PARENB	0000400
-#define PARODD	0001000
-#define HUPCL	0002000
-#define CLOCAL	0004000
-#define CBAUDEX 0010000
-#define    BOTHER 0010000
-#define    B57600 0010001
-#define   B115200 0010002
-#define   B230400 0010003
-#define   B460800 0010004
-#define   B500000 0010005
-#define   B576000 0010006
-#define   B921600 0010007
-#define  B1000000 0010010
-#define  B1152000 0010011
-#define  B1500000 0010012
-#define  B2000000 0010013
-#define  B2500000 0010014
-#define  B3000000 0010015
-#define  B3500000 0010016
-#define  B4000000 0010017
-#define CIBAUD	  002003600000	/* input baud rate */
-#define CMSPAR	  010000000000	/* mark or space (stick) parity */
-#define CRTSCTS	  020000000000	/* flow control */
-
-#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
-
-/* c_lflag bits */
-#define ISIG	0000001
-#define ICANON	0000002
-#define XCASE	0000004
-#define ECHO	0000010
-#define ECHOE	0000020
-#define ECHOK	0000040
-#define ECHONL	0000100
-#define NOFLSH	0000200
-#define TOSTOP	0000400
-#define ECHOCTL	0001000
-#define ECHOPRT	0002000
-#define ECHOKE	0004000
-#define FLUSHO	0010000
-#define PENDIN	0040000
-#define IEXTEN	0100000
-#define EXTPROC	0200000
-
-/* tcflow() and TCXONC use these */
-#define	TCOOFF		0
-#define	TCOON		1
-#define	TCIOFF		2
-#define	TCION		3
-
-/* tcflush() and TCFLSH use these */
-#define	TCIFLUSH	0
-#define	TCOFLUSH	1
-#define	TCIOFLUSH	2
-
-/* tcsetattr uses these */
-#define	TCSANOW		0
-#define	TCSADRAIN	1
-#define	TCSAFLUSH	2
-
-#endif	/* __ASM_ARM_TERMBITS_H */
+#include <asm-generic/termbits.h>
diff --git a/arch/arm/include/asm/termios.h b/arch/arm/include/asm/termios.h
index 94ce9ec..280d78a 100644
--- a/arch/arm/include/asm/termios.h
+++ b/arch/arm/include/asm/termios.h
@@ -1,154 +1 @@
-#ifndef __ASM_ARM_TERMIOS_H
-#define __ASM_ARM_TERMIOS_H
-/*
- * Most architectures have straight copies of the x86 code, with
- * varying levels of bug fixes on top. Usually it's a good idea
- * to use this generic version instead, but be careful to avoid
- * ABI changes.
- * New architectures should not provide their own version.
- */
-
-#include <asm/termbits.h>
-#include <asm/ioctls.h>
-
-struct winsize {
-	unsigned short ws_row;
-	unsigned short ws_col;
-	unsigned short ws_xpixel;
-	unsigned short ws_ypixel;
-};
-
-#define NCC 8
-struct termio {
-	unsigned short c_iflag;		/* input mode flags */
-	unsigned short c_oflag;		/* output mode flags */
-	unsigned short c_cflag;		/* control mode flags */
-	unsigned short c_lflag;		/* local mode flags */
-	unsigned char c_line;		/* line discipline */
-	unsigned char c_cc[NCC];	/* control characters */
-};
-
-/* modem lines */
-#define TIOCM_LE	0x001
-#define TIOCM_DTR	0x002
-#define TIOCM_RTS	0x004
-#define TIOCM_ST	0x008
-#define TIOCM_SR	0x010
-#define TIOCM_CTS	0x020
-#define TIOCM_CAR	0x040
-#define TIOCM_RNG	0x080
-#define TIOCM_DSR	0x100
-#define TIOCM_CD	TIOCM_CAR
-#define TIOCM_RI	TIOCM_RNG
-#define TIOCM_OUT1	0x2000
-#define TIOCM_OUT2	0x4000
-#define TIOCM_LOOP	0x8000
-
-/* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
-
-#ifdef __KERNEL__
-
-#include <asm/uaccess.h>
-
-/*	intr=^C		quit=^\		erase=del	kill=^U
-	eof=^D		vtime=\0	vmin=\1		sxtc=\0
-	start=^Q	stop=^S		susp=^Z		eol=\0
-	reprint=^R	discard=^U	werase=^W	lnext=^V
-	eol2=\0
-*/
-#define INIT_C_CC "\003\034\177\025\004\0\1\0\021\023\032\0\022\017\027\026\0"
-
-/*
- * Translate a "termio" structure into a "termios". Ugh.
- */
-static inline int user_termio_to_kernel_termios(struct ktermios *termios,
-						const struct termio __user *termio)
-{
-	unsigned short tmp;
-
-	if (get_user(tmp, &termio->c_iflag) < 0)
-		goto fault;
-	termios->c_iflag = (0xffff0000 & termios->c_iflag) | tmp;
-
-	if (get_user(tmp, &termio->c_oflag) < 0)
-		goto fault;
-	termios->c_oflag = (0xffff0000 & termios->c_oflag) | tmp;
-
-	if (get_user(tmp, &termio->c_cflag) < 0)
-		goto fault;
-	termios->c_cflag = (0xffff0000 & termios->c_cflag) | tmp;
-
-	if (get_user(tmp, &termio->c_lflag) < 0)
-		goto fault;
-	termios->c_lflag = (0xffff0000 & termios->c_lflag) | tmp;
-
-	if (get_user(termios->c_line, &termio->c_line) < 0)
-		goto fault;
-
-	if (copy_from_user(termios->c_cc, termio->c_cc, NCC) != 0)
-		goto fault;
-
-	return 0;
-
- fault:
-	return -EFAULT;
-}
-
-/*
- * Translate a "termios" structure into a "termio". Ugh.
- */
-static inline int kernel_termios_to_user_termio(struct termio __user *termio,
-						struct ktermios *termios)
-{
-	if (put_user(termios->c_iflag, &termio->c_iflag) < 0 ||
-	    put_user(termios->c_oflag, &termio->c_oflag) < 0 ||
-	    put_user(termios->c_cflag, &termio->c_cflag) < 0 ||
-	    put_user(termios->c_lflag, &termio->c_lflag) < 0 ||
-	    put_user(termios->c_line,  &termio->c_line) < 0 ||
-	    copy_to_user(termio->c_cc, termios->c_cc, NCC) != 0)
-		return -EFAULT;
-
-	return 0;
-}
-
-#ifdef TCGETS2
-static inline int user_termios_to_kernel_termios(struct ktermios *k,
-						 struct termios2 __user *u)
-{
-	return copy_from_user(k, u, sizeof(struct termios2));
-}
-
-static inline int kernel_termios_to_user_termios(struct termios2 __user *u,
-						 struct ktermios *k)
-{
-	return copy_to_user(u, k, sizeof(struct termios2));
-}
-
-static inline int user_termios_to_kernel_termios_1(struct ktermios *k,
-						   struct termios __user *u)
-{
-	return copy_from_user(k, u, sizeof(struct termios));
-}
-
-static inline int kernel_termios_to_user_termios_1(struct termios __user *u,
-						   struct ktermios *k)
-{
-	return copy_to_user(u, k, sizeof(struct termios));
-}
-#else /* TCGETS2 */
-static inline int user_termios_to_kernel_termios(struct ktermios *k,
-						 struct termios __user *u)
-{
-	return copy_from_user(k, u, sizeof(struct termios));
-}
-
-static inline int kernel_termios_to_user_termios(struct termios __user *u,
-						 struct ktermios *k)
-{
-	return copy_to_user(u, k, sizeof(struct termios));
-}
-#endif /* TCGETS2 */
-
-#endif	/* __KERNEL__ */
-
-#endif	/* __ASM_ARM_TERMIOS_H */
+#include <asm-generic/termios.h>
diff --git a/arch/arm/include/asm/timex.h b/arch/arm/include/asm/timex.h
index 55a01f1..a6a42d5 100644
--- a/arch/arm/include/asm/timex.h
+++ b/arch/arm/include/asm/timex.h
@@ -13,20 +13,6 @@
 #define _ASMARM_TIMEX_H
 
 #include <mach/timex.h>
-
-typedef unsigned long cycles_t;
-#ifndef get_cycles
-static inline cycles_t get_cycles(void)
-{
-	return 0;
-}
-#endif
-
-/*
- * Architectures are encouraged to implement read_current_timer
- * and define this in order to avoid the expensive delay loop
- * calibration during boot.
- */
-#undef ARCH_HAS_READ_CURRENT_TIMER
+#include <asm-generic/timex.h>
 
 #endif
diff --git a/arch/arm/include/asm/types.h b/arch/arm/include/asm/types.h
index b7389db..b9e79bc 100644
--- a/arch/arm/include/asm/types.h
+++ b/arch/arm/include/asm/types.h
@@ -1,42 +1 @@
-#ifndef __ASM_ARM_TYPES_H
-#define __ASM_ARM_TYPES_H
-/*
- * int-ll64 is used practically everywhere now,
- * so use it as a reasonable default.
- */
-#include <asm-generic/int-ll64.h>
-
-#ifndef __ASSEMBLY__
-
-typedef unsigned short umode_t;
-
-#endif /* __ASSEMBLY__ */
-
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
-/*
- * DMA addresses may be very different from physical addresses
- * and pointers. i386 and powerpc may have 64 bit DMA on 32 bit
- * systems, while sparc64 uses 32 bit DMA addresses for 64 bit
- * physical addresses.
- * This default defines dma_addr_t to have the same size as
- * phys_addr_t, which is the most common way.
- * Do not define the dma64_addr_t type, which never really
- * worked.
- */
-#ifndef dma_addr_t
-#ifdef CONFIG_PHYS_ADDR_T_64BIT
-typedef u64 dma_addr_t;
-#else
-typedef u32 dma_addr_t;
-#endif /* CONFIG_PHYS_ADDR_T_64BIT */
-#endif /* dma_addr_t */
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* __KERNEL__ */
-
-#endif
+#include <asm-generic/types.h>
-- 
1.7.1

