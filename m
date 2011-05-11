Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab1EKVGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:06:55 -0400
Received: from c-76-97-164-112.hsd1.ga.comcast.net ([76.97.164.112]:55110 "EHLO
	deneb.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756060Ab1EKVGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:06:51 -0400
X-Greylist: delayed 3155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 17:06:39 EDT
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 11/16] C6X: add lib files
Date: Wed, 11 May 2011 16:13:58 -0400
Message-Id: <1305144843-5058-12-git-send-email-msalter@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1305144843-5058-11-git-send-email-msalter@redhat.com>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
 <1305144843-5058-2-git-send-email-msalter@redhat.com>
 <1305144843-5058-3-git-send-email-msalter@redhat.com>
 <1305144843-5058-4-git-send-email-msalter@redhat.com>
 <1305144843-5058-5-git-send-email-msalter@redhat.com>
 <1305144843-5058-6-git-send-email-msalter@redhat.com>
 <1305144843-5058-7-git-send-email-msalter@redhat.com>
 <1305144843-5058-8-git-send-email-msalter@redhat.com>
 <1305144843-5058-9-git-send-email-msalter@redhat.com>
 <1305144843-5058-10-git-send-email-msalter@redhat.com>
 <1305144843-5058-11-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/lib/Makefile         |   10 +
 arch/c6x/lib/csum_64plus.S    |  408 +++++++++++++++++++++++++++++++++++++++++
 arch/c6x/lib/divi.S           |   51 +++++
 arch/c6x/lib/divremi.S        |   45 +++++
 arch/c6x/lib/divremu.S        |   86 +++++++++
 arch/c6x/lib/divu.S           |   97 ++++++++++
 arch/c6x/lib/divull.c         |  332 +++++++++++++++++++++++++++++++++
 arch/c6x/lib/llshl.S          |   36 ++++
 arch/c6x/lib/llshr.S          |   36 ++++
 arch/c6x/lib/llshru.S         |   36 ++++
 arch/c6x/lib/memcmp.c         |   26 +++
 arch/c6x/lib/memcpy_64plus.S  |   45 +++++
 arch/c6x/lib/memmove.c        |   32 ++++
 arch/c6x/lib/memset.c         |   25 +++
 arch/c6x/lib/mpyll.S          |   47 +++++
 arch/c6x/lib/negll.S          |   29 +++
 arch/c6x/lib/pop_rts.S        |   30 +++
 arch/c6x/lib/push_rts.S       |   28 +++
 arch/c6x/lib/remi.S           |   62 ++++++
 arch/c6x/lib/remu.S           |   81 ++++++++
 arch/c6x/lib/strasgi.S        |   88 +++++++++
 arch/c6x/lib/strasgi_64plus.S |   37 ++++
 22 files changed, 1667 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/lib/Makefile
 create mode 100644 arch/c6x/lib/csum_64plus.S
 create mode 100644 arch/c6x/lib/divi.S
 create mode 100644 arch/c6x/lib/divremi.S
 create mode 100644 arch/c6x/lib/divremu.S
 create mode 100644 arch/c6x/lib/divu.S
 create mode 100644 arch/c6x/lib/divull.c
 create mode 100644 arch/c6x/lib/llshl.S
 create mode 100644 arch/c6x/lib/llshr.S
 create mode 100644 arch/c6x/lib/llshru.S
 create mode 100644 arch/c6x/lib/memcmp.c
 create mode 100644 arch/c6x/lib/memcpy_64plus.S
 create mode 100644 arch/c6x/lib/memmove.c
 create mode 100644 arch/c6x/lib/memset.c
 create mode 100644 arch/c6x/lib/mpyll.S
 create mode 100644 arch/c6x/lib/negll.S
 create mode 100644 arch/c6x/lib/pop_rts.S
 create mode 100644 arch/c6x/lib/push_rts.S
 create mode 100644 arch/c6x/lib/remi.S
 create mode 100644 arch/c6x/lib/remu.S
 create mode 100644 arch/c6x/lib/strasgi.S
 create mode 100644 arch/c6x/lib/strasgi_64plus.S

diff --git a/arch/c6x/lib/Makefile b/arch/c6x/lib/Makefile
new file mode 100644
index 0000000..5c095e8
--- /dev/null
+++ b/arch/c6x/lib/Makefile
@@ -0,0 +1,10 @@
+#
+# Makefile for arch/c6x/lib/
+#
+
+lib-y  := memcmp.o memmove.o memset.o \
+          divu.o divi.o pop_rts.o push_rts.o remi.o remu.o \
+          strasgi.o llshru.o llshr.o llshl.o negll.o mpyll.o divull.o \
+	  divremi.o divremu.o
+
+lib-$(CONFIG_TMS320C64XPLUS) += csum_64plus.o memcpy_64plus.o strasgi_64plus.o
diff --git a/arch/c6x/lib/csum_64plus.S b/arch/c6x/lib/csum_64plus.S
new file mode 100644
index 0000000..a8d050e
--- /dev/null
+++ b/arch/c6x/lib/csum_64plus.S
@@ -0,0 +1,408 @@
+;
+;  linux/arch/c6x/lib/csum_64plus.s
+;
+;  Port on Texas Instruments TMS320C6x architecture
+;
+;  Copyright (C) 2006, 2009, 2010 Texas Instruments Incorporated
+;  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+;
+;  This program is free software; you can redistribute it and/or modify
+;  it under the terms of the GNU General Public License version 2 as
+;  published by the Free Software Foundation.
+;
+
+;
+;unsigned int csum_partial_copy(const char *src, char * dst,
+;				int len, int sum)
+;
+; A4:	src
+; B4:	dst
+; A6:	len
+; B6:	sum
+; return csum in A4
+;
+
+	.global  csum_partial_copy
+	.text
+
+csum_partial_copy:
+	MVC	.S2	ILC,B30
+
+	MV	.D1X	B6,A31		; given csum
+	ZERO	.D1	A9		; csum (a side)
+||	ZERO	.D2	B9		; csum (b side)
+||	SHRU	.S2X	A6,2,B5		; len / 4
+
+	;; Check alignment and size
+	AND	.S1	3,A4,A1
+||	AND	.S2	3,B4,B0
+	OR	.L2X	B0,A1,B0	; non aligned condition
+||	MVC	.S2	B5,ILC
+||	MVK	.D2	1,B2
+||	MV	.D1X	B5,A1		; words condition
+  [!A1]	B	.S1	L8
+   [B0] BNOP	.S1	L6,5
+
+	SPLOOP		1
+
+	;; Main loop for aligned words
+	LDW	.D1T1	*A4++,A7
+	NOP	4
+	MV	.S2X	A7,B7
+||	EXTU	.S1	A7,0,16,A16
+	STW	.D2T2	B7,*B4++
+||	MPYU	.M2	B7,B2,B8
+||	ADD	.L1	A16,A9,A9
+	NOP
+	SPKERNEL	8,0
+||	ADD	.L2	B8,B9,B9
+
+	ZERO	.D1	A1
+||	ADD	.L1X	A9,B9,A9	;  add csum from a and b sides
+
+L6:
+  [!A1]	BNOP	.S1	L8,5
+
+	;; Main loop for non-aligned words
+	SPLOOP		2
+ ||	MVK	.L1	1,A2
+
+	LDNW	.D1T1	*A4++,A7
+	NOP		3
+
+	NOP
+	MV	.S2X	A7,B7
+ ||	EXTU	.S1	A7,0,16,A16
+ ||	MPYU	.M1	A7,A2,A8
+
+	ADD	.L1	A16,A9,A9
+	SPKERNEL	6,0
+ ||	STNW	.D2T2	B7,*B4++
+ ||	ADD	.L1	A8,A9,A9
+
+L8:	AND	.S2X	2,A6,B5
+	CMPGT	.L2	B5,0,B0
+  [!B0]	BNOP	.S1	L82,4
+
+	;; Manage half-word
+	ZERO	.L1	A7
+||	ZERO	.D1	A8
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+
+	LDBU	.D1T1	*A4++,A7
+	LDBU	.D1T1	*A4++,A8
+	NOP		3
+	SHL	.S1	A7,8,A0
+	ADD	.S1	A8,A9,A9
+	STB	.D2T1	A7,*B4++
+||	ADD	.S1	A0,A9,A9
+	STB	.D2T1	A8,*B4++
+
+#else
+
+	LDBU	.D1T1	*A4++,A7
+	LDBU	.D1T1	*A4++,A8
+	NOP		3
+	ADD	.S1	A7,A9,A9
+	SHL	.S1	A8,8,A0
+
+	STB	.D2T1	A7,*B4++
+||	ADD	.S1	A0,A9,A9
+	STB	.D2T1	A8,*B4++
+
+#endif
+
+	;; Manage eventually the last byte
+L82:	AND	.S2X	1,A6,B0
+  [!B0]	BNOP	.S1	L9,5
+
+||	ZERO	.L1	A7
+
+L83:	LDBU	.D1T1	*A4++,A7
+	NOP		4
+
+	MV	.L2X	A7,B7
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+
+	STB	.D2T2	B7,*B4++
+||	SHL	.S1	A7,8,A7
+	ADD	.S1	A7,A9,A9
+
+#else
+
+	STB	.D2T2	B7,*B4++
+||	ADD	.S1	A7,A9,A9
+
+#endif
+
+	;; Fold the csum
+L9:	SHRU	.S2X	A9,16,B0
+  [!B0]	BNOP	.S1	L10,5
+
+L91:	SHRU	.S2X	A9,16,B4
+||	EXTU	.S1	A9,16,16,A3
+	ADD	.D1X	A3,B4,A9
+
+	SHRU	.S1	A9,16,A0
+   [A0]	BNOP	.S1	L91,5
+
+L10:	ADD	.D1	A31,A9,A9
+	MV	.D1	A9,A4
+
+	BNOP	.S2	B3,4
+	MVC	.S2	B30,ILC
+
+	.global  csum_partial_copy_old
+	.text
+
+;
+;unsigned short
+;ip_fast_csum(unsigned char *iph, unsigned int ihl)
+;{
+;	unsigned int checksum = 0;
+;	unsigned short *tosum = (unsigned short *) iph;
+;	int len;
+;
+;	len = ihl*4;
+;
+;	if (len <= 0)
+;		return 0;
+;
+;	while(len) {
+;		len -= 2;
+;		checksum += *tosum++;
+;	}
+;	if (len & 1)
+;		checksum += *(unsigned char*) tosum;
+;
+;	while(checksum >> 16)
+;		checksum = (checksum & 0xffff) + (checksum >> 16);
+;
+;	return ~checksum;
+;}
+;
+; A4:	iph
+; B4:	ihl
+; return checksum in A4
+;
+
+	.global  ip_fast_csum
+	.text
+
+ip_fast_csum:
+	ZERO	.D1	A5
+ ||	MVC	.S2	ILC,B30
+	SHL	.S2	B4,2,B0
+	CMPGT	.L2	B0,0,B1
+  [!B1] BNOP	.S1	L15,4
+  [!B1]	ZERO	.D1	A3
+
+  [!B0]	B	.S1	L12
+	SHRU	.S2	B0,1,B0
+	MVC	.S2	B0,ILC
+	NOP	3
+
+	SPLOOP	1
+	LDHU	.D1T1	*A4++,A3
+	NOP	3
+	NOP
+	SPKERNEL	5,0
+ ||	ADD	.L1	A3,A5,A5
+
+L12:	SHRU	.S1	A5,16,A0
+  [!A0]	BNOP	.S1	L14,5
+
+L13:	SHRU	.S2X	A5,16,B4
+	EXTU	.S1	A5,16,16,A3
+	ADD	.D1X	A3,B4,A5
+	SHRU	.S1	A5,16,A0
+  [A0]	BNOP	.S1	L13,5
+
+L14:	NOT	.D1	A5,A3
+	EXTU	.S1	A3,16,16,A3
+
+L15:	BNOP	.S2	B3,3
+	MVC	.S2	B30,ILC
+	MV	.D1	A3,A4
+
+;
+;unsigned short
+;do_csum(unsigned char *buff, unsigned int len)
+;{
+;	int odd, count;
+;	unsigned int result = 0;
+;
+;	if (len <= 0)
+;		goto out;
+;	odd = 1 & (unsigned long) buff;
+;	if (odd) {
+;#ifdef __LITTLE_ENDIAN
+;		result += (*buff << 8);
+;#else
+;		result = *buff;
+;#endif
+;		len--;
+;		buff++;
+;	}
+;	count = len >> 1;		/* nr of 16-bit words.. */
+;	if (count) {
+;		if (2 & (unsigned long) buff) {
+;			result += *(unsigned short *) buff;
+;			count--;
+;			len -= 2;
+;			buff += 2;
+;		}
+;		count >>= 1;		/* nr of 32-bit words.. */
+;		if (count) {
+;			unsigned int carry = 0;
+;			do {
+;				unsigned int w = *(unsigned int *) buff;
+;				count--;
+;				buff += 4;
+;				result += carry;
+;				result += w;
+;				carry = (w > result);
+;			} while (count);
+;			result += carry;
+;			result = (result & 0xffff) + (result >> 16);
+;		}
+;		if (len & 2) {
+;			result += *(unsigned short *) buff;
+;			buff += 2;
+;		}
+;	}
+;	if (len & 1)
+;#ifdef __LITTLE_ENDIAN
+;		result += *buff;
+;#else
+;		result += (*buff << 8);
+;#endif
+;	result = (result & 0xffff) + (result >> 16);
+;	/* add up carry.. */
+;	result = (result & 0xffff) + (result >> 16);
+;	if (odd)
+;		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
+;out:
+;	return result;
+;}
+;
+; A4:	buff
+; B4:	len
+; return checksum in A4
+;
+	   .global  do_csum
+	   .text
+do_csum:
+	   CMPGT   .L2	   B4,0,B0
+   [!B0]   BNOP    .S1	   L26,3
+	   EXTU    .S1	   A4,31,31,A0
+
+	   MV	   .L1	   A0,A3
+||	   MV	   .S1X    B3,A5
+||	   MV	   .L2	   B4,B3
+||	   ZERO    .D1	   A1
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+   [A0]    SUB	   .L2	   B3,1,B3
+|| [A0]    LDBU    .D1T1   *A4++,A1
+#else
+   [!A0]   BNOP    .S1	   L21,5
+|| [A0]    LDBU    .D1T1   *A4++,A0
+	   SUB	   .L2	   B3,1,B3
+||	   SHL	   .S1	   A0,8,A1
+L21:
+#endif
+	   SHR	   .S2	   B3,1,B0
+   [!B0]   BNOP    .S1	   L24,3
+	   MVK	   .L1	   2,A0
+	   AND	   .L1	   A4,A0,A0
+
+   [!A0]   BNOP    .S1	   L22,5
+|| [A0]    LDHU    .D1T1   *A4++,A0
+	   SUB	   .L2	   B0,1,B0
+||	   SUB	   .S2	   B3,2,B3
+||	   ADD	   .L1	   A0,A1,A1
+L22:
+	   SHR	   .S2	   B0,1,B0
+||	   ZERO    .L1	   A0
+
+   [!B0]   BNOP    .S1	   L23,5
+|| [B0]    MVC	   .S2	   B0,ILC
+
+	   SPLOOP  3
+	   SPMASK  L1
+||	   MV	   .L1	   A1,A2
+||	   LDW	   .D1T1   *A4++,A1
+
+	   NOP	   4
+	   ADD	   .L1	   A0,A1,A0
+	   ADD	   .L1	   A2,A0,A2
+
+	   SPKERNEL 1,2
+||	   CMPGTU  .L1	   A1,A2,A0
+
+	   ADD	   .L1	   A0,A2,A6
+	   EXTU    .S1	   A6,16,16,A7
+	   SHRU    .S2X    A6,16,B0
+	   NOP		   1
+	   ADD	   .L1X    A7,B0,A1
+L23:
+	   MVK	   .L2	   2,B0
+	   AND	   .L2	   B3,B0,B0
+   [B0]    LDHU    .D1T1   *A4++,A0
+	   NOP	   4
+   [B0]    ADD	   .L1	   A0,A1,A1
+L24:
+	   EXTU    .S2	   B3,31,31,B0
+#ifdef CONFIG_CPU_BIG_ENDIAN
+   [!B0]   BNOP    .S1	   L25,4
+|| [B0]    LDBU    .D1T1   *A4,A0
+	   SHL	   .S1	   A0,8,A0
+	   ADD	   .L1	   A0,A1,A1
+L25:
+#else
+   [B0]    LDBU    .D1T1   *A4,A0
+	   NOP	   4
+   [B0]    ADD	   .L1	   A0,A1,A1
+#endif
+	   EXTU    .S1	   A1,16,16,A0
+	   SHRU    .S2X    A1,16,B0
+	   NOP	   1
+	   ADD	   .L1X    A0,B0,A0
+	   SHRU    .S1	   A0,16,A1
+	   ADD	   .L1	   A0,A1,A0
+	   EXTU    .S1	   A0,16,16,A1
+	   EXTU    .S1	   A1,16,24,A2
+
+	   EXTU    .S1	   A1,24,16,A0
+||	   MV	   .L2X    A3,B0
+
+   [B0]    OR	   .L1	   A0,A2,A1
+L26:
+	   NOP	   1
+	   BNOP    .S2X    A5,4
+	   MV	   .L1	   A1,A4
+
+;__wsum csum_partial(const void *buff, int len, __wsum wsum)
+;{
+;	unsigned int sum = (__force unsigned int)wsum;
+;	unsigned int result = do_csum(buff, len);
+;
+;	/* add in old sum, and carry.. */
+;	result += sum;
+;	if (sum > result)
+;		result += 1;
+;	return (__force __wsum)result;
+;}
+;
+	.global	csum_partial
+csum_partial:
+	   MV	   .L1X    B3,A9
+||	   CALLP   .S2	   do_csum,B3
+||	   MV	   .S1	   A6,A8
+	   BNOP    .S2X    A9,2
+	   ADD	   .L1	   A8,A4,A1
+	   CMPGTU  .L1	   A8,A1,A0
+	   ADD	   .L1	   A1,A0,A4
diff --git a/arch/c6x/lib/divi.S b/arch/c6x/lib/divi.S
new file mode 100644
index 0000000..8613f18
--- /dev/null
+++ b/arch/c6x/lib/divi.S
@@ -0,0 +1,51 @@
+;;  Copyright 2010  Free Software Foundation, Inc.
+;;  Contributed by Bernd Schmidt <bernds@codesourcery.com>.
+;;
+;; This program is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 2 of the License, or
+;; (at your option) any later version.
+;;
+;; This program is distributed in the hope that it will be useful,
+;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;; GNU General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with this program; if not, write to the Free Software
+;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+
+	;; ABI considerations for the divide functions
+	;; The following registers are call-used:
+	;; __c6xabi_divi A0,A1,A2,A4,A6,B0,B1,B2,B4,B5
+	;; __c6xabi_divu A0,A1,A2,A4,A6,B0,B1,B2,B4
+	;; __c6xabi_remi A1,A2,A4,A5,A6,B0,B1,B2,B4
+	;; __c6xabi_remu A1,A4,A5,A7,B0,B1,B2,B4
+	;;
+	;; In our implementation, divu and remu are leaf functions,
+	;; while both divi and remi call into divu.
+	;; A0 is not clobbered by any of the functions.
+	;; divu does not clobber B2 either, which is taken advantage of
+	;; in remi.
+	;; divi uses B5 to hold the original return address during
+	;; the call to divu.
+	;; remi uses B2 and A5 to hold the input values during the
+	;; call to divu.  It stores B3 in on the stack.
+
+	.text
+	.global __c6xabi_divi
+__c6xabi_divi:
+	call	.s2	__c6xabi_divu
+||	mv	.d2	B3, B5
+||	cmpgt	.l1	0, A4, A1
+||	cmpgt	.l2	0, B4, B1
+
+   [A1]	neg	.l1	A4, A4
+|| [B1]	neg	.l2	B4, B4
+||	xor	.s1x	A1, B1, A1
+   [A1] addkpc	.s2	_divu_ret, B3, 4
+_divu_ret:
+	neg	.l1	A4, A4
+||	mv	.l2	B3,B5
+||	ret	.s2	B5
+	nop		5
diff --git a/arch/c6x/lib/divremi.S b/arch/c6x/lib/divremi.S
new file mode 100644
index 0000000..d0ed842
--- /dev/null
+++ b/arch/c6x/lib/divremi.S
@@ -0,0 +1,45 @@
+;;  Copyright 2010  Free Software Foundation, Inc.
+;;  Contributed by Bernd Schmidt <bernds@codesourcery.com>.
+;;
+;; This program is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 2 of the License, or
+;; (at your option) any later version.
+;;
+;; This program is distributed in the hope that it will be useful,
+;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;; GNU General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with this program; if not, write to the Free Software
+;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+
+	.text
+	.global __c6xabi_divremi
+
+__c6xabi_divremi:
+	stw	.d2t2	B3, *B15--[2]
+||	cmpgt	.l1	0, A4, A1
+||	cmpgt	.l2	0, B4, B2
+||	mv	.s1	A4, A5
+||	call	.s2	__c6xabi_divu
+
+   [A1]	neg	.l1	A4, A4
+|| [B2]	neg	.l2	B4, B4
+||	xor	.s2x	B2, A1, B0
+||	mv	.d2	B4, B2
+
+   [B0]	addkpc	.s2	_divu_ret_1, B3, 1
+  [!B0] addkpc	.s2	_divu_ret_2, B3, 1
+	nop	2
+_divu_ret_1:
+	neg	.l1	A4, A4
+_divu_ret_2:
+	ldw	.d2t2	*++B15[2], B3
+
+	mpy32	.m1x	A4, B2, A6
+	nop		3
+	ret	.s2	B3
+	sub	.l1	A5, A6, A5
+	nop	4
diff --git a/arch/c6x/lib/divremu.S b/arch/c6x/lib/divremu.S
new file mode 100644
index 0000000..32adbe5
--- /dev/null
+++ b/arch/c6x/lib/divremu.S
@@ -0,0 +1,86 @@
+;;  Copyright 2011  Free Software Foundation, Inc.
+;;  Contributed by Bernd Schmidt <bernds@codesourcery.com>.
+;;
+;; This program is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 2 of the License, or
+;; (at your option) any later version.
+;;
+;; This program is distributed in the hope that it will be useful,
+;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;; GNU General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with this program; if not, write to the Free Software
+;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+
+	.text
+	.global __c6xabi_divremu
+
+__c6xabi_divremu:
+	;; We use a series of up to 31 subc instructions.  First, we find
+	;; out how many leading zero bits there are in the divisor.  This
+	;; gives us both a shift count for aligning (shifting) the divisor
+	;; to the, and the number of times we have to execute subc.
+
+	;; At the end, we have both the remainder and most of the quotient
+	;; in A4.  The top bit of the quotient is computed first and is
+	;; placed in A2.
+
+	;; Return immediately if the dividend is zero.	Setting B4 to 1
+	;; is a trick to allow us to leave the following insns in the jump
+	;; delay slot without affecting the result.
+	mv	.s2x	A4, B1
+
+  [b1]	lmbd	.l2	1, B4, B1
+||[!b1] b	.s2	B3	; RETURN A
+||[!b1] mvk	.d2	1, B4
+
+||[!b1] zero	.s1	A5
+	mv	.l1x	B1, A6
+||	shl	.s2	B4, B1, B4
+
+	;; The loop performs a maximum of 28 steps, so we do the
+	;; first 3 here.
+	cmpltu	.l1x	A4, B4, A2
+  [!A2]	sub	.l1x	A4, B4, A4
+||	shru	.s2	B4, 1, B4
+||	xor	.s1	1, A2, A2
+
+	shl	.s1	A2, 31, A2
+|| [b1]	subc	.l1x	A4,B4,A4
+|| [b1]	add	.s2	-1, B1, B1
+   [b1]	subc	.l1x	A4,B4,A4
+|| [b1]	add	.s2	-1, B1, B1
+
+	;; RETURN A may happen here (note: must happen before the next branch)
+__divremu0:
+	cmpgt	.l2	B1, 7, B0
+|| [b1]	subc	.l1x	A4,B4,A4
+|| [b1]	add	.s2	-1, B1, B1
+   [b1]	subc	.l1x	A4,B4,A4
+|| [b1]	add	.s2	-1, B1, B1
+|| [b0] b	.s1	__divremu0
+   [b1]	subc	.l1x	A4,B4,A4
+|| [b1]	add	.s2	-1, B1, B1
+   [b1]	subc	.l1x	A4,B4,A4
+|| [b1]	add	.s2	-1, B1, B1
+   [b1]	subc	.l1x	A4,B4,A4
+|| [b1]	add	.s2	-1, B1, B1
+   [b1]	subc	.l1x	A4,B4,A4
+|| [b1]	add	.s2	-1, B1, B1
+   [b1]	subc	.l1x	A4,B4,A4
+|| [b1]	add	.s2	-1, B1, B1
+	;; loop backwards branch happens here
+
+	ret	.s2	B3
+||	mvk	.s1	32, A1
+	sub	.l1	A1, A6, A6
+||	extu	.s1	A4, A6, A5
+	shl	.s1	A4, A6, A4
+	shru	.s1	A4, 1, A4
+||	sub	.l1	A6, 1, A6
+	or	.l1	A2, A4, A4
+	shru	.s1	A4, A6, A4
+	nop
diff --git a/arch/c6x/lib/divu.S b/arch/c6x/lib/divu.S
new file mode 100644
index 0000000..54e147f
--- /dev/null
+++ b/arch/c6x/lib/divu.S
@@ -0,0 +1,97 @@
+;;  Copyright 2010  Free Software Foundation, Inc.
+;;  Contributed by Bernd Schmidt <bernds@codesourcery.com>.
+;;
+;; This program is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 2 of the License, or
+;; (at your option) any later version.
+;;
+;; This program is distributed in the hope that it will be useful,
+;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;; GNU General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with this program; if not, write to the Free Software
+;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+
+	;; ABI considerations for the divide functions
+	;; The following registers are call-used:
+	;; __c6xabi_divi A0,A1,A2,A4,A6,B0,B1,B2,B4,B5
+	;; __c6xabi_divu A0,A1,A2,A4,A6,B0,B1,B2,B4
+	;; __c6xabi_remi A1,A2,A4,A5,A6,B0,B1,B2,B4
+	;; __c6xabi_remu A1,A4,A5,A7,B0,B1,B2,B4
+	;;
+	;; In our implementation, divu and remu are leaf functions,
+	;; while both divi and remi call into divu.
+	;; A0 is not clobbered by any of the functions.
+	;; divu does not clobber B2 either, which is taken advantage of
+	;; in remi.
+	;; divi uses B5 to hold the original return address during
+	;; the call to divu.
+	;; remi uses B2 and A5 to hold the input values during the
+	;; call to divu.  It stores B3 in on the stack.
+
+	.text
+	.global __c6xabi_divu
+__c6xabi_divu:
+	;; We use a series of up to 31 subc instructions.  First, we find
+	;; out how many leading zero bits there are in the divisor.  This
+	;; gives us both a shift count for aligning (shifting) the divisor
+	;; to the, and the number of times we have to execute subc.
+
+	;; At the end, we have both the remainder and most of the quotient
+	;; in A4.  The top bit of the quotient is computed first and is
+	;; placed in A2.
+
+	;; Return immediately if the dividend is zero.
+	 mv	.s2x	A4, B1
+   [B1]	 lmbd	.l2	1, B4, B1
+|| [!B1] b	.s2	B3	; RETURN A
+|| [!B1] mvk	.d2	1, B4
+	 mv	.l1x	B1, A6
+||	 shl	.s2	B4, B1, B4
+
+	;; The loop performs a maximum of 28 steps, so we do the
+	;; first 3 here.
+	 cmpltu	.l1x	A4, B4, A2
+   [!A2] sub	.l1x	A4, B4, A4
+||	 shru	.s2	B4, 1, B4
+||	 xor	.s1	1, A2, A2
+
+	 shl	.s1	A2, 31, A2
+|| [B1]	 subc	.l1x	A4,B4,A4
+|| [B1]	 add	.s2	-1, B1, B1
+   [B1]	 subc	.l1x	A4,B4,A4
+|| [B1]	 add	.s2	-1, B1, B1
+
+	;; RETURN A may happen here (note: must happen before the next branch)
+_divu_loop:
+	 cmpgt	.l2	B1, 7, B0
+|| [B1]	 subc	.l1x	A4,B4,A4
+|| [B1]	 add	.s2	-1, B1, B1
+   [B1]	 subc	.l1x	A4,B4,A4
+|| [B1]	 add	.s2	-1, B1, B1
+|| [B0]  b	.s1	_divu_loop
+   [B1]	 subc	.l1x	A4,B4,A4
+|| [B1]	 add	.s2	-1, B1, B1
+   [B1]	 subc	.l1x	A4,B4,A4
+|| [B1]	 add	.s2	-1, B1, B1
+   [B1]	 subc	.l1x	A4,B4,A4
+|| [B1]	 add	.s2	-1, B1, B1
+   [B1]	 subc	.l1x	A4,B4,A4
+|| [B1]	 add	.s2	-1, B1, B1
+   [B1]	 subc	.l1x	A4,B4,A4
+|| [B1]	 add	.s2	-1, B1, B1
+	;; loop backwards branch happens here
+
+	 ret	.s2	B3
+||	 mvk	.s1	32, A1
+	 sub	.l1	A1, A6, A6
+	 shl	.s1	A4, A6, A4
+	 shru	.s1	A4, 1, A4
+||	 sub	.l1	A6, 1, A6
+	 or	.l1	A2, A4, A4
+	 shru	.s1	A4, A6, A4
+	 nop
+
diff --git a/arch/c6x/lib/divull.c b/arch/c6x/lib/divull.c
new file mode 100644
index 0000000..97eae9b
--- /dev/null
+++ b/arch/c6x/lib/divull.c
@@ -0,0 +1,332 @@
+/* Copyright (C) 1989, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999,
+   2000, 2001, 2002  Free Software Foundation, Inc.
+
+This code was pulled from an old (GPLv2) libgcc.
+
+This program is free software; you can redistribute it and/or modify it under
+the terms of the GNU General Public License as published by the Free Software
+Foundation; either version 2, or (at your option) any later version.
+
+In addition to the permissions in the GNU General Public License, the
+Free Software Foundation gives you unlimited permission to link the
+compiled version of this file into combinations with other programs,
+and to distribute those combinations without any restriction coming
+from the use of this file.  (The General Public License restrictions
+do apply in other respects; for example, they cover modification of
+the file, and distribution when not linked into a combine
+executable.)
+
+This program is distributed in the hope that it will be useful, but WITHOUT
+ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+for more details.
+
+You should have received a copy of the GNU General Public License
+along with GCC; see the file COPYING.  If not, write to the Free
+Software Foundation, 59 Temple Place - Suite 330, Boston, MA
+02111-1307, USA.  */
+
+#include <linux/types.h>
+#include <linux/bitops.h>
+
+static inline unsigned __clz(unsigned x)
+{
+	asm(" lmbd .l1 1,%0,%0\n" : "+a"(x));
+	return x;
+}
+#define count_leading_zeros(count, x) (count) = __clz(x)
+
+#define W_TYPE_SIZE	32
+
+#define __BITS4 (W_TYPE_SIZE / 4)
+#define __ll_B ((uint32_t) 1 << (W_TYPE_SIZE / 2))
+#define __ll_lowpart(t) ((uint32_t) (t) & (__ll_B - 1))
+#define __ll_highpart(t) ((uint32_t) (t) >> (W_TYPE_SIZE / 2))
+
+
+#define sub_ddmmss(sh, sl, ah, al, bh, bl) \
+	do {								\
+		uint32_t __x;						\
+		__x = (al) - (bl);					\
+		(sh) = (ah) - (bh) - (__x > (al));			\
+		(sl) = __x;						\
+	} while (0)
+
+#define umul_ppmm(w1, w0, u, v)						\
+	do {								\
+		uint32_t __x0, __x1, __x2, __x3;			\
+		uint16_t __ul, __vl, __uh, __vh;			\
+									\
+		__ul = __ll_lowpart(u);					\
+		__uh = __ll_highpart(u);				\
+		__vl = __ll_lowpart(v);					\
+		__vh = __ll_highpart(v);				\
+									\
+		__x0 = (uint32_t) __ul * __vl;				\
+		__x1 = (uint32_t) __ul * __vh;				\
+		__x2 = (uint32_t) __uh * __vl;				\
+		__x3 = (uint32_t) __uh * __vh;				\
+									\
+		__x1 += __ll_highpart(__x0);/* this can't give carry */ \
+		__x1 += __x2;		/* but this indeed can */	\
+		if (__x1 < __x2)	/* did we get it? */	\
+			__x3 += __ll_B;	/* yes, add it in the proper pos. */ \
+									\
+		(w1) = __x3 + __ll_highpart(__x1);			\
+		(w0) = __ll_lowpart(__x1) * __ll_B + __ll_lowpart(__x0); \
+	} while (0)
+
+#define __udiv_qrnnd_c(q, r, n1, n0, d) \
+	do {								\
+		uint32_t __d1, __d0, __q1, __q0;			\
+		uint32_t __r1, __r0, __m;				\
+		__d1 = __ll_highpart(d);				\
+		__d0 = __ll_lowpart(d);					\
+									\
+		__r1 = (n1) % __d1;					\
+		__q1 = (n1) / __d1;					\
+		__m = (uint32_t) __q1 * __d0;				\
+		__r1 = __r1 * __ll_B | __ll_highpart(n0);		\
+		if (__r1 < __m)	{					\
+			__q1--, __r1 += (d);				\
+			/* i.e. we didn't get carry when adding to __r1 */ \
+			if (__r1 >= (d))				\
+				if (__r1 < __m)				\
+					__q1--, __r1 += (d);		\
+		}							\
+		__r1 -= __m;						\
+									\
+		__r0 = __r1 % __d1;					\
+		__q0 = __r1 / __d1;					\
+		__m = (uint32_t) __q0 * __d0;				\
+		__r0 = __r0 * __ll_B | __ll_lowpart(n0);		\
+		if (__r0 < __m) {					\
+			__q0--, __r0 += (d);				\
+			if (__r0 >= (d))				\
+				if (__r0 < __m)				\
+					__q0--, __r0 += (d);		\
+		}							\
+		__r0 -= __m;						\
+									\
+		(q) = (uint32_t) __q1 * __ll_B | __q0;			\
+		(r) = __r0;						\
+	} while (0)
+
+#define UDIV_NEEDS_NORMALIZATION 1
+#define udiv_qrnnd __udiv_qrnnd_c
+
+struct llstruct {
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	uint32_t high;
+	uint32_t low;
+#else
+	uint32_t low;
+	uint32_t high;
+#endif
+};
+
+typedef union {
+	struct llstruct s;
+	int64_t ll;
+} llunion_t;
+
+static inline uint64_t __udivmoddi4(uint64_t n, uint64_t d, uint64_t *rp)
+{
+	llunion_t ww;
+	llunion_t nn, dd;
+	llunion_t rr;
+	uint32_t d0, d1, n0, n1, n2;
+	uint32_t q0, q1;
+	uint32_t b, bm;
+
+	nn.ll = n;
+	dd.ll = d;
+
+	d0 = dd.s.low;
+	d1 = dd.s.high;
+	n0 = nn.s.low;
+	n1 = nn.s.high;
+
+#if !UDIV_NEEDS_NORMALIZATION
+	if (d1 == 0) {
+		if (d0 > n1) {
+			/* 0q = nn / 0D */
+
+			udiv_qrnnd(q0, n0, n1, n0, d0);
+			q1 = 0;
+
+			/* Remainder in n0.  */
+		} else {
+			/* qq = NN / 0d */
+
+			if (d0 == 0)
+				d0 = 1 / d0; /* Divide intentionally by zero. */
+
+			udiv_qrnnd(q1, n1, 0, n1, d0);
+			udiv_qrnnd(q0, n0, n1, n0, d0);
+
+			/* Remainder in n0.  */
+		}
+
+		if (rp != 0) {
+			rr.s.low = n0;
+			rr.s.high = 0;
+			*rp = rr.ll;
+		}
+	}
+
+#else /* UDIV_NEEDS_NORMALIZATION */
+
+	if (d1 == 0) {
+		if (d0 > n1) {
+			/* 0q = nn / 0D */
+
+			count_leading_zeros(bm, d0);
+
+			if (bm != 0) {
+				/* Normalize, i.e. make the most significant
+				   bit of the denominator set.	*/
+
+				d0 = d0 << bm;
+				n1 = (n1 << bm) | (n0 >> (W_TYPE_SIZE - bm));
+				n0 = n0 << bm;
+			}
+
+			udiv_qrnnd(q0, n0, n1, n0, d0);
+			q1 = 0;
+
+			/* Remainder in n0 >> bm.  */
+		} else {
+			/* qq = NN / 0d */
+
+			if (d0 == 0)
+				d0 = 1 / d0; /* Divide intentionally by zero. */
+
+			count_leading_zeros(bm, d0);
+
+			if (bm == 0) {
+				/* From (n1 >= d0) /\ (the most significant bit
+				   of d0 is set), conclude (the most significant
+				   bit of n1 is set) /\ (the leading quotient
+				   digit q1 = 1).
+
+				   This special case is necessary, not an
+				   optimization. (Shifts counts of W_TYPE_SIZE
+				   are undefined.)  */
+
+				n1 -= d0;
+				q1 = 1;
+			} else {
+				/* Normalize.  */
+
+				b = W_TYPE_SIZE - bm;
+
+				d0 = d0 << bm;
+				n2 = n1 >> b;
+				n1 = (n1 << bm) | (n0 >> b);
+				n0 = n0 << bm;
+
+				udiv_qrnnd(q1, n1, n2, n1, d0);
+			}
+
+			/* n1 != d0...	*/
+
+			udiv_qrnnd(q0, n0, n1, n0, d0);
+
+			/* Remainder in n0 >> bm.  */
+		}
+
+		if (rp != NULL) {
+			rr.s.low = n0 >> bm;
+			rr.s.high = 0;
+			*rp = rr.ll;
+		}
+	}
+#endif /* UDIV_NEEDS_NORMALIZATION */
+
+	else {
+		if (d1 > n1) {
+			/* 00 = nn / DD */
+
+			q0 = 0;
+			q1 = 0;
+
+			/* Remainder in n1n0.  */
+			if (rp != NULL) {
+				rr.s.low = n0;
+				rr.s.high = n1;
+				*rp = rr.ll;
+			}
+		} else {
+			/* 0q = NN / dd */
+
+			count_leading_zeros(bm, d1);
+			if (bm == 0) {
+				/* From (n1 >= d1) /\ (the most significant bit
+				   of d1 is set), conclude (the most significant
+				   bit of n1 is set) /\ (the quotient digit
+				   q0 = 0 or 1).
+
+				   This special case is necessary, not an
+				   optimization.  */
+
+				/* The condition on the next line takes
+				   advantage of that n1 >= d1 (true due to
+				   program flow).  */
+				if (n1 > d1 || n0 >= d0) {
+					q0 = 1;
+					sub_ddmmss(n1, n0, n1, n0, d1, d0);
+				} else
+					q0 = 0;
+
+				q1 = 0;
+
+				if (rp != NULL) {
+					rr.s.low = n0;
+					rr.s.high = n1;
+					*rp = rr.ll;
+				}
+			} else {
+				uint32_t m1, m0;
+				/* Normalize.  */
+
+				b = W_TYPE_SIZE - bm;
+
+				d1 = (d1 << bm) | (d0 >> b);
+				d0 = d0 << bm;
+				n2 = n1 >> b;
+				n1 = (n1 << bm) | (n0 >> b);
+				n0 = n0 << bm;
+
+				udiv_qrnnd(q0, n1, n2, n1, d1);
+				umul_ppmm(m1, m0, q0, d0);
+
+				if (m1 > n1 || (m1 == n1 && m0 > n0)) {
+					q0--;
+					sub_ddmmss(m1, m0, m1, m0, d1, d0);
+				}
+
+				q1 = 0;
+
+				/* Remainder in (n1n0 - m1m0) >> bm.  */
+				if (rp != NULL) {
+					sub_ddmmss(n1, n0, n1, n0, m1, m0);
+					rr.s.low = (n1 << b) | (n0 >> bm);
+					rr.s.high = n1 >> bm;
+					*rp = rr.ll;
+				}
+			}
+		}
+	}
+
+	ww.s.low = q0;
+	ww.s.high = q1;
+	return ww.ll;
+}
+
+uint64_t
+__c6xabi_divull(uint64_t n, uint64_t d)
+{
+	return __udivmoddi4(n, d, (uint64_t *)0);
+}
+
diff --git a/arch/c6x/lib/llshl.S b/arch/c6x/lib/llshl.S
new file mode 100644
index 0000000..99b739e
--- /dev/null
+++ b/arch/c6x/lib/llshl.S
@@ -0,0 +1,36 @@
+;;  Copyright (C) 2010 Texas Instruments Incorporated
+;;  Contributed by Mark Salter <msalter@redhat.com>.
+;;
+;; This program is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 2 of the License, or
+;; (at your option) any later version.
+;;
+;; This program is distributed in the hope that it will be useful,
+;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;; GNU General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with this program; if not, write to the Free Software
+;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+
+;;  uint64_t __c6xabi_llshl(uint64_t val, uint shift)
+
+	.text
+	.global __c6xabi_llshl
+__c6xabi_llshl:
+	 mv	.l1x	B4,A1
+   [!A1] b	.s2	B3		; just return if zero shift
+	 mvk	.s1	32,A0
+	 sub	.d1	A0,A1,A0
+	 cmplt	.l1	0,A0,A2
+   [A2]	 shru	.s1	A4,A0,A0
+   [!A2] neg	.l1	A0,A5
+|| [A2]  shl	.s1	A5,A1,A5
+   [!A2] shl	.s1	A4,A5,A5
+|| [A2]  or	.d1	A5,A0,A5
+|| [!A2] mvk	.l1	0,A4
+   [A2]	 shl	.s1	A4,A1,A4
+	 bnop	.s2	B3,5
+
diff --git a/arch/c6x/lib/llshr.S b/arch/c6x/lib/llshr.S
new file mode 100644
index 0000000..989feed
--- /dev/null
+++ b/arch/c6x/lib/llshr.S
@@ -0,0 +1,36 @@
+;;  Copyright (C) 2010 Texas Instruments Incorporated
+;;  Contributed by Mark Salter <msalter@redhat.com>.
+;;
+;; This program is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 2 of the License, or
+;; (at your option) any later version.
+;;
+;; This program is distributed in the hope that it will be useful,
+;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;; GNU General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with this program; if not, write to the Free Software
+;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+
+;;  uint64_t __c6xabi_llshr(uint64_t val, uint shift)
+
+	.text
+	.global __c6xabi_llshr
+__c6xabi_llshr:
+	 mv	.l1x	B4,A1
+   [!A1] b	.s2	B3		; return if zero shift count
+	 mvk	.s1	32,A0
+	 sub	.d1	A0,A1,A0
+	 cmplt	.l1	0,A0,A2
+   [A2]  shl	.s1	A5,A0,A0
+	 nop
+   [!A2] neg	.l1	A0,A4
+|| [A2]  shru	.s1	A4,A1,A4
+   [!A2] shr	.s1	A5,A4,A4
+|| [A2]  or	.d1	A4,A0,A4
+   [!A2] shr	.s1	A5,0x1f,A5
+   [A2]  shr	.s1	A5,A1,A5
+	 bnop	.s2	B3,5
diff --git a/arch/c6x/lib/llshru.S b/arch/c6x/lib/llshru.S
new file mode 100644
index 0000000..07a4631
--- /dev/null
+++ b/arch/c6x/lib/llshru.S
@@ -0,0 +1,36 @@
+;;  Copyright (C) 2010 Texas Instruments Incorporated
+;;  Contributed by Mark Salter <msalter@redhat.com>.
+;;
+;; This program is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 2 of the License, or
+;; (at your option) any later version.
+;;
+;; This program is distributed in the hope that it will be useful,
+;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;; GNU General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with this program; if not, write to the Free Software
+;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+
+;;  uint64_t __c6xabi_llshru(uint64_t val, uint shift)
+
+	.text
+	.global __c6xabi_llshru
+__c6xabi_llshru:
+	 mv	.l1x	B4,A1
+   [!A1] b	.s2	B3		; return if zero shift count
+	 mvk	.s1	32,A0
+	 sub	.d1	A0,A1,A0
+	 cmplt	.l1	0,A0,A2
+   [A2]  shl	.s1	A5,A0,A0
+	 nop
+   [!A2] neg	.l1	A0,A4
+|| [A2]  shru	.s1	A4,A1,A4
+   [!A2] shru	.s1	A5,A4,A4
+|| [A2]  or	.d1	A4,A0,A4
+|| [!A2] mvk	.l1	0,A5
+   [A2]  shru	.s1	A5,A1,A5
+	 bnop	.s2	B3,5
diff --git a/arch/c6x/lib/memcmp.c b/arch/c6x/lib/memcmp.c
new file mode 100644
index 0000000..2393530
--- /dev/null
+++ b/arch/c6x/lib/memcmp.c
@@ -0,0 +1,26 @@
+/*
+ *  linux/arch/c6x/lib/memcmp.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/types.h>
+#include <linux/module.h>
+
+int memcmp(const void *cs, const void *ct, size_t count)
+{
+	const unsigned char *su1, *su2;
+
+	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--)
+		if (*su1 != *su2)
+			return (*su1 < *su2) ? -1 : 1;
+	return 0;
+}
+EXPORT_SYMBOL(memcmp);
+
diff --git a/arch/c6x/lib/memcpy_64plus.S b/arch/c6x/lib/memcpy_64plus.S
new file mode 100644
index 0000000..231ee25
--- /dev/null
+++ b/arch/c6x/lib/memcpy_64plus.S
@@ -0,0 +1,45 @@
+;  Port on Texas Instruments TMS320C6x architecture
+;
+;  Copyright (C) 2006, 2009, 2010 Texas Instruments Incorporated
+;  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+;
+;  This program is free software; you can redistribute it and/or modify
+;  it under the terms of the GNU General Public License version 2 as
+;  published by the Free Software Foundation.
+;
+
+	.global  memcpy
+	.text
+
+memcpy:
+	AND	.L1	0x1,A6,A0
+ ||	AND	.S1	0x2,A6,A1
+ ||	AND	.L2X	0x4,A6,B0
+ ||	MV	.D1	A4,A3
+ ||	MVC	.S2	ILC,B2
+
+   [A0] LDB	.D2T1	*B4++,A5
+   [A1] LDB	.D2T1	*B4++,A7
+   [A1] LDB	.D2T1	*B4++,A8
+   [B0] LDNW	.D2T1	*B4++,A9
+ ||	SHRU	.S2X	A6,0x3,B1
+  [!B1] BNOP	.S2	B3,1
+
+   [A0] STB	.D1T1	A5,*A3++
+ ||[B1] MVC	.S2	B1,ILC
+   [A1] STB	.D1T1	A7,*A3++
+   [A1] STB	.D1T1	A8,*A3++
+   [B0] STNW	.D1T1	A9,*A3++	; return when len < 8
+
+	SPLOOP	2
+
+	LDNDW	.D2T1	*B4++,A9:A8
+	NOP	3
+
+	NOP
+	SPKERNEL	0,0
+ ||	STNDW	.D1T1	A9:A8,*A3++
+
+	BNOP	.S2	B3,4
+	MVC	.S2	B2,ILC
+
diff --git a/arch/c6x/lib/memmove.c b/arch/c6x/lib/memmove.c
new file mode 100644
index 0000000..23b6a81
--- /dev/null
+++ b/arch/c6x/lib/memmove.c
@@ -0,0 +1,32 @@
+/*
+ *  linux/arch/c6x/lib/memmove.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2005, 2009 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/string.h>
+
+void *memmove(void *s1, const void *s2, size_t n)
+{
+	register char *s = (char *) s1;
+	register const char *p = (const char *) s2;
+
+	if (p >= s) {
+		return memcpy(s, p, n);
+	} else {
+		while (n) {
+			--n;
+			s[n] = p[n];
+		}
+	}
+	return s1;
+}
+EXPORT_SYMBOL(memmove);
diff --git a/arch/c6x/lib/memset.c b/arch/c6x/lib/memset.c
new file mode 100644
index 0000000..7fda20f
--- /dev/null
+++ b/arch/c6x/lib/memset.c
@@ -0,0 +1,25 @@
+/*
+ *  linux/arch/c6x/lib/memcmp.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/types.h>
+#include <linux/module.h>
+
+void *memset(void *mem, register int ch, register size_t length)
+{
+	register char *m = (char *)mem - 1;
+
+	while (length--)
+		*++m = ch;
+	return mem;
+}
+EXPORT_SYMBOL(memset);
+
diff --git a/arch/c6x/lib/mpyll.S b/arch/c6x/lib/mpyll.S
new file mode 100644
index 0000000..d2427ab
--- /dev/null
+++ b/arch/c6x/lib/mpyll.S
@@ -0,0 +1,47 @@
+;;  Copyright (C) 2010 Texas Instruments Incorporated
+;;  Contributed by Mark Salter <msalter@redhat.com>.
+;;
+;; This program is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 2 of the License, or
+;; (at your option) any later version.
+;;
+;; This program is distributed in the hope that it will be useful,
+;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;; GNU General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with this program; if not, write to the Free Software
+;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+
+	;; uint64_t __c6xabi_mpyll(uint64_t x, uint64_t y)
+	;;
+	;; 64x64 multiply
+	;; First compute partial results using 32-bit parts of x and y:
+	;;
+	;;   b63	 b32 b31	  b0
+	;;    -----------------------------
+	;;    |      1	    |	   0	  |
+	;;    -----------------------------
+	;;
+	;;   P0 = X0*Y0
+	;;   P1 = X0*Y1 + X1*Y0
+	;;   P2 = X1*Y1
+	;;
+	;;   result = (P2 << 64) + (P1 << 32) + P0
+	;;
+	;; Since the result is also 64-bit, we can skip the P2 term.
+
+	.text
+	.global __c6xabi_mpyll
+__c6xabi_mpyll:
+	mpy32u	.m1x	A4,B4,A1:A0	; X0*Y0
+	b	.s2	B3
+ ||	mpy32u	.m2x	B5,A4,B1:B0	; X0*Y1 (don't need upper 32-bits)
+ ||	mpy32u	.m1x	A5,B4,A3:A2	; X1*Y0 (don't need upper 32-bits)
+	nop
+	nop
+	mv	.s1	A0,A4
+	add	.l1x	A2,B0,A5
+	add	.s1	A1,A5,A5
diff --git a/arch/c6x/lib/negll.S b/arch/c6x/lib/negll.S
new file mode 100644
index 0000000..7747521
--- /dev/null
+++ b/arch/c6x/lib/negll.S
@@ -0,0 +1,29 @@
+;;  Copyright (C) 2010 Texas Instruments Incorporated
+;;  Contributed by Mark Salter <msalter@redhat.com>.
+;;
+;; This program is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 2 of the License, or
+;; (at your option) any later version.
+;;
+;; This program is distributed in the hope that it will be useful,
+;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;; GNU General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with this program; if not, write to the Free Software
+;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+
+;;  int64_t __c6xabi_negll(int64_t val)
+
+	.text
+	.global __c6xabi_negll
+__c6xabi_negll:
+	b	.s2	B3
+	mvk	.l1	0,A0
+	subu	.l1	A0,A4,A3:A2
+	sub	.l1	A0,A5,A0
+||	ext	.s1	A3,24,24,A5
+	add	.l1	A5,A0,A5
+	mv	.s1	A2,A4
diff --git a/arch/c6x/lib/pop_rts.S b/arch/c6x/lib/pop_rts.S
new file mode 100644
index 0000000..e1847fb
--- /dev/null
+++ b/arch/c6x/lib/pop_rts.S
@@ -0,0 +1,30 @@
+;;  Copyright 2010  Free Software Foundation, Inc.
+;;  Contributed by Bernd Schmidt <bernds@codesourcery.com>.
+;;
+;; This program is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 2 of the License, or
+;; (at your option) any later version.
+;;
+;; This program is distributed in the hope that it will be useful,
+;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;; GNU General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with this program; if not, write to the Free Software
+;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+
+	.text
+	.global __c6xabi_pop_rts
+
+__c6xabi_pop_rts:
+	lddw	.d2t2	*++B15, B3:B2
+	lddw	.d2t1	*++B15, A11:A10
+	lddw	.d2t2	*++B15, B11:B10
+	lddw	.d2t1	*++B15, A13:A12
+	lddw	.d2t2	*++B15, B13:B12
+	lddw	.d2t1	*++B15, A15:A14
+||	b	.s2	B3
+	ldw	.d2t2	*++B15[2], B14
+	nop	4
diff --git a/arch/c6x/lib/push_rts.S b/arch/c6x/lib/push_rts.S
new file mode 100644
index 0000000..637d56a
--- /dev/null
+++ b/arch/c6x/lib/push_rts.S
@@ -0,0 +1,28 @@
+;;  Copyright 2010  Free Software Foundation, Inc.
+;;  Contributed by Bernd Schmidt <bernds@codesourcery.com>.
+;;
+;; This program is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 2 of the License, or
+;; (at your option) any later version.
+;;
+;; This program is distributed in the hope that it will be useful,
+;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;; GNU General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with this program; if not, write to the Free Software
+;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+
+	.text
+	.global __c6xabi_push_rts
+__c6xabi_push_rts:
+	stw	.d2t2	B14, *B15--[2]
+	stdw	.d2t1	A15:A14, *B15--
+||	b	.s2x	A3
+	stdw	.d2t2	B13:B12, *B15--
+	stdw	.d2t1	A13:A12, *B15--
+	stdw	.d2t2	B11:B10, *B15--
+	stdw	.d2t1	A11:A10, *B15--
+	stdw	.d2t2	B3:B2, *B15--
diff --git a/arch/c6x/lib/remi.S b/arch/c6x/lib/remi.S
new file mode 100644
index 0000000..cb6063f
--- /dev/null
+++ b/arch/c6x/lib/remi.S
@@ -0,0 +1,62 @@
+;;  Copyright 2010  Free Software Foundation, Inc.
+;;  Contributed by Bernd Schmidt <bernds@codesourcery.com>.
+;;
+;; This program is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 2 of the License, or
+;; (at your option) any later version.
+;;
+;; This program is distributed in the hope that it will be useful,
+;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;; GNU General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with this program; if not, write to the Free Software
+;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+
+	;; ABI considerations for the divide functions
+	;; The following registers are call-used:
+	;; __c6xabi_divi A0,A1,A2,A4,A6,B0,B1,B2,B4,B5
+	;; __c6xabi_divu A0,A1,A2,A4,A6,B0,B1,B2,B4
+	;; __c6xabi_remi A1,A2,A4,A5,A6,B0,B1,B2,B4
+	;; __c6xabi_remu A1,A4,A5,A7,B0,B1,B2,B4
+	;;
+	;; In our implementation, divu and remu are leaf functions,
+	;; while both divi and remi call into divu.
+	;; A0 is not clobbered by any of the functions.
+	;; divu does not clobber B2 either, which is taken advantage of
+	;; in remi.
+	;; divi uses B5 to hold the original return address during
+	;; the call to divu.
+	;; remi uses B2 and A5 to hold the input values during the
+	;; call to divu.  It stores B3 in on the stack.
+
+	.text
+	.global __c6xabi_remi
+
+__c6xabi_remi:
+	stw	.d2t2	B3, *B15--[2]
+||	cmpgt	.l1	0, A4, A1
+||	cmpgt	.l2	0, B4, B2
+||	mv	.s1	A4, A5
+||	call	.s2	__c6xabi_divu
+
+   [A1]	neg	.l1	A4, A4
+|| [B2]	neg	.l2	B4, B4
+||	xor	.s2x	B2, A1, B0
+||	mv	.d2	B4, B2
+
+   [B0]	addkpc	.s2	_divu_ret_1, B3, 1
+  [!B0] addkpc	.s2	_divu_ret_2, B3, 1
+	nop	2
+_divu_ret_1:
+	neg	.l1	A4, A4
+_divu_ret_2:
+	ldw	.d2t2	*++B15[2], B3
+
+	mpy32	.m1x	A4, B2, A6
+	nop		3
+	ret	.s2	B3
+	sub	.l1	A5, A6, A4
+	nop	4
diff --git a/arch/c6x/lib/remu.S b/arch/c6x/lib/remu.S
new file mode 100644
index 0000000..e1d9f30
--- /dev/null
+++ b/arch/c6x/lib/remu.S
@@ -0,0 +1,81 @@
+;;  Copyright 2010  Free Software Foundation, Inc.
+;;  Contributed by Bernd Schmidt <bernds@codesourcery.com>.
+;;
+;; This program is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 2 of the License, or
+;; (at your option) any later version.
+;;
+;; This program is distributed in the hope that it will be useful,
+;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;; GNU General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with this program; if not, write to the Free Software
+;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+
+	;; ABI considerations for the divide functions
+	;; The following registers are call-used:
+	;; __c6xabi_divi A0,A1,A2,A4,A6,B0,B1,B2,B4,B5
+	;; __c6xabi_divu A0,A1,A2,A4,A6,B0,B1,B2,B4
+	;; __c6xabi_remi A1,A2,A4,A5,A6,B0,B1,B2,B4
+	;; __c6xabi_remu A1,A4,A5,A7,B0,B1,B2,B4
+	;;
+	;; In our implementation, divu and remu are leaf functions,
+	;; while both divi and remi call into divu.
+	;; A0 is not clobbered by any of the functions.
+	;; divu does not clobber B2 either, which is taken advantage of
+	;; in remi.
+	;; divi uses B5 to hold the original return address during
+	;; the call to divu.
+	;; remi uses B2 and A5 to hold the input values during the
+	;; call to divu.  It stores B3 in on the stack.
+
+
+	.text
+	.global __c6xabi_remu
+
+__c6xabi_remu:
+	;; The ABI seems designed to prevent these functions calling each other,
+	;; so we duplicate most of the divsi3 code here.
+	 mv	.s2x	A4, B1
+	 lmbd	.l2	1, B4, B1
+|| [!B1] b	.s2	B3	; RETURN A
+|| [!B1] mvk	.d2	1, B4
+
+	 mv	.l1x	B1, A7
+||	 shl	.s2	B4, B1, B4
+
+	 cmpltu	.l1x	A4, B4, A1
+   [!A1] sub	.l1x	A4, B4, A4
+	 shru	.s2	B4, 1, B4
+
+_remu_loop:
+	 cmpgt	.l2	B1, 7, B0
+|| [B1]	 subc	.l1x	A4,B4,A4
+|| [B1]	 add	.s2	-1, B1, B1
+	;; RETURN A may happen here (note: must happen before the next branch)
+   [B1]	 subc	.l1x	A4,B4,A4
+|| [B1]	 add	.s2	-1, B1, B1
+|| [B0]	 b	.s1	_remu_loop
+   [B1]	 subc	.l1x	A4,B4,A4
+|| [B1]	 add	.s2	-1, B1, B1
+   [B1]	 subc	.l1x	A4,B4,A4
+|| [B1]	 add	.s2	-1, B1, B1
+   [B1]	 subc	.l1x	A4,B4,A4
+|| [B1]	 add	.s2	-1, B1, B1
+   [B1]	 subc	.l1x	A4,B4,A4
+|| [B1]	 add	.s2	-1, B1, B1
+   [B1]	 subc	.l1x	A4,B4,A4
+|| [B1]	 add	.s2	-1, B1, B1
+	;; loop backwards branch happens here
+
+	 ret	.s2	B3
+   [B1]	 subc	.l1x	A4,B4,A4
+|| [B1]	 add	.s2	-1, B1, B1
+   [B1]	 subc	.l1x	A4,B4,A4
+
+	 extu	.s1	A4, A7, A4
+	 nop	2
+
diff --git a/arch/c6x/lib/strasgi.S b/arch/c6x/lib/strasgi.S
new file mode 100644
index 0000000..6861e25
--- /dev/null
+++ b/arch/c6x/lib/strasgi.S
@@ -0,0 +1,88 @@
+;;  Copyright 2010  Free Software Foundation, Inc.
+;;  Contributed by Bernd Schmidt <bernds@codesourcery.com>.
+;;
+;; This program is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 2 of the License, or
+;; (at your option) any later version.
+;;
+;; This program is distributed in the hope that it will be useful,
+;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;; GNU General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with this program; if not, write to the Free Software
+;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+
+	.text
+	.global __c6xabi_strasgi
+
+__c6xabi_strasgi:
+
+	;; This is essentially memcpy, with alignment known to be at least
+	;; 4, and the size a multiple of 4 greater than or equal to 28.
+	 ldw	.d2t1	*B4++, A0
+||	 mvk	.s2	16, B1
+	 ldw	.d2t1	*B4++, A1
+||	 mvk	.s2	20, B2
+||	 sub	.d1	A6, 24, A6
+	 ldw	.d2t1	*B4++, A5
+	 ldw	.d2t1	*B4++, A7
+||	 mv	.l2x	A6, B7
+	 ldw	.d2t1	*B4++, A8
+	 ldw	.d2t1	*B4++, A9
+||	 mv	.s2x	A0, B5
+||	 cmpltu	.l2	B2, B7, B0
+
+_strasgi_loop:
+	 stw	.d1t2	B5, *A4++
+|| [B0]	 ldw	.d2t1	*B4++, A0
+||	 mv	.s2x	A1, B5
+||	 mv	.l2	B7, B6
+
+   [B0]	 sub	.d2	B6, 24, B7
+|| [B0]	 b	.s2	_strasgi_loop
+||	 cmpltu	.l2	B1, B6, B0
+
+   [B0]	 ldw	.d2t1	*B4++, A1
+||	 stw	.d1t2	B5, *A4++
+||	 mv	.s2x	A5, B5
+||	 cmpltu	.l2	12, B6, B0
+
+   [B0]	 ldw	.d2t1	*B4++, A5
+||	 stw	.d1t2	B5, *A4++
+||	 mv	.s2x	A7, B5
+||	 cmpltu	.l2	8, B6, B0
+
+   [B0]	 ldw	.d2t1	*B4++, A7
+||	 stw	.d1t2	B5, *A4++
+||	 mv	.s2x	A8, B5
+||	 cmpltu	.l2	4, B6, B0
+
+   [B0]	 ldw	.d2t1	*B4++, A8
+||	 stw	.d1t2	B5, *A4++
+||	 mv	.s2x	A9, B5
+||	 cmpltu	.l2	0, B6, B0
+
+   [B0]	 ldw	.d2t1	*B4++, A9
+||	 stw	.d1t2	B5, *A4++
+||	 mv	.s2x	A0, B5
+||	 cmpltu	.l2	B2, B7, B0
+
+	;; loop back branch happens here
+
+	 cmpltu	.l2	B1, B6, B0
+||	 ret	.s2	b3
+
+   [B0]	 stw	.d1t1	A1, *A4++
+||	 cmpltu	.l2	12, B6, B0
+   [B0]	 stw	.d1t1	A5, *A4++
+||	 cmpltu	.l2	8, B6, B0
+   [B0]	 stw	.d1t1	A7, *A4++
+||	 cmpltu	.l2	4, B6, B0
+   [B0]	 stw	.d1t1	A8, *A4++
+||	 cmpltu	.l2	0, B6, B0
+   [B0]	 stw	.d1t1	A9, *A4++
+
+	;; return happens here
diff --git a/arch/c6x/lib/strasgi_64plus.S b/arch/c6x/lib/strasgi_64plus.S
new file mode 100644
index 0000000..cbeab22
--- /dev/null
+++ b/arch/c6x/lib/strasgi_64plus.S
@@ -0,0 +1,37 @@
+;;  Copyright 2010  Free Software Foundation, Inc.
+;;  Contributed by Bernd Schmidt <bernds@codesourcery.com>.
+;;
+;; This program is free software; you can redistribute it and/or modify
+;; it under the terms of the GNU General Public License as published by
+;; the Free Software Foundation; either version 2 of the License, or
+;; (at your option) any later version.
+;;
+;; This program is distributed in the hope that it will be useful,
+;; but WITHOUT ANY WARRANTY; without even the implied warranty of
+;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+;; GNU General Public License for more details.
+;;
+;; You should have received a copy of the GNU General Public License
+;; along with this program; if not, write to the Free Software
+;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+
+	.text
+	.global __c6xabi_strasgi_64plus
+
+__c6xabi_strasgi_64plus:
+	shru	.s2x	a6, 2, b31
+||	mv	.s1	a4, a30
+||	mv	.d2	b4, b30
+
+	add	.s2	-4, b31, b31
+
+	sploopd		1
+||	mvc	.s2	b31, ilc
+	ldw	.d2t2	*b30++, b31
+	nop	4
+	mv	.s1x	b31,a31
+	spkernel	6, 0
+||	stw	.d1t1	a31, *a30++
+
+	ret	.s2	b3
+	nop 5
-- 
1.6.2.5

