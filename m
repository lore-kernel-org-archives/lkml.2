Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab0DYNnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 09:43:42 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39624 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab0DYNnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 09:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=te3dp5Vyyh/0qbBhW+AFjFMYwM75ld3MivmAt2+bDnDIZyiPB6opKgzSKN0q8Hbo09
         QFXVk+PfBiKisk6EQDoruoxLYGjWtRX8Aq4i/zQ0psGp8uRls5o/TS1xGKh/xkrWEvwn
         uZ4Gb2A73pYZEnxoLTHwisvE/M5groTDFvris=
Date: Sun, 25 Apr 2010 22:18:51 +0900
From: Yoichi Yuasa <yuasa@linux-mips.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: yuasa@linux-mips.org, Naren Sankar <nsankar@broadcom.com>,
       Jarod Wilson <jarod@wilsonet.com>, Scott Davilla <davilla@4pi.com>,
       Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] staging: crystalhd: remove unused bc_dts_types.h
Message-Id: <20100425221851.223dc284.yuasa@linux-mips.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
---
 drivers/staging/crystalhd/bc_dts_defs.h  |    2 -
 drivers/staging/crystalhd/bc_dts_types.h |  121 ------------------------------
 2 files changed, 0 insertions(+), 123 deletions(-)
 delete mode 100644 drivers/staging/crystalhd/bc_dts_types.h

diff --git a/drivers/staging/crystalhd/bc_dts_defs.h b/drivers/staging/crystalhd/bc_dts_defs.h
index c34cc07..cd12605 100644
--- a/drivers/staging/crystalhd/bc_dts_defs.h
+++ b/drivers/staging/crystalhd/bc_dts_defs.h
@@ -26,8 +26,6 @@
 #ifndef _BC_DTS_DEFS_H_
 #define _BC_DTS_DEFS_H_
 
-#include "bc_dts_types.h"
-
 /* BIT Mask */
 #define BC_BIT(_x)		(1 << (_x))
 
diff --git a/drivers/staging/crystalhd/bc_dts_types.h b/drivers/staging/crystalhd/bc_dts_types.h
deleted file mode 100644
index ac0c817..0000000
--- a/drivers/staging/crystalhd/bc_dts_types.h
+++ /dev/null
@@ -1,121 +0,0 @@
-/********************************************************************
- * Copyright(c) 2006-2009 Broadcom Corporation.
- *
- *  Name: bc_dts_types.h
- *
- *  Description: Data types
- *
- *  AU
- *
- *  HISTORY:
- *
- ********************************************************************
- * This header is free software: you can redistribute it and/or modify
- * it under the terms of the GNU Lesser General Public License as published
- * by the Free Software Foundation, either version 2.1 of the License.
- *
- * This header is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- * You should have received a copy of the GNU Lesser General Public License
- * along with this header.  If not, see <http://www.gnu.org/licenses/>.
- *******************************************************************/
-
-#ifndef _BC_DTS_TYPES_H_
-#define _BC_DTS_TYPES_H_
-
-#ifdef __LINUX_USER__  // Don't include these for KERNEL..
-#include <stdint.h>
-#endif
-
-#if defined(_WIN64) || defined(_WIN32)
-typedef uint32_t		U32;
-typedef int32_t			S32;
-typedef uint16_t		U16;
-typedef int16_t			S16;
-typedef unsigned char		U8;
-typedef char			S8;
-#endif
-
-#ifndef PVOID
-typedef void	*PVOID;
-#endif
-
-#ifndef BOOL
-typedef int	BOOL;
-#endif
-
-#ifdef WIN32
-    typedef unsigned __int64	U64;
-#elif defined(_WIN64)
-    typedef uint64_t U64;
-#endif
-
-#ifdef _WIN64
-#if !(defined(POINTER_32))
-#define POINTER_32	__ptr32
-#endif
-#else	/* _WIN32 */
-#define POINTER_32
-#endif
-
-#if defined(__KERNEL__) || defined(__LINUX_USER__)
-
-#ifdef __LINUX_USER__	/* Don't include these for KERNEL */
-typedef uint32_t	ULONG;
-typedef int32_t		LONG;
-typedef void		*HANDLE;
-#ifndef VOID
-typedef void		VOID;
-#endif
-typedef void		*LPVOID;
-typedef uint32_t	DWORD;
-typedef uint32_t	UINT32;
-typedef uint32_t	*LPDWORD;
-typedef unsigned char	*PUCHAR;
-
-#ifndef TRUE
-	#define TRUE		1
-#endif
-
-#ifndef FALSE
-	#define FALSE		0
-#endif
-
-#define TEXT
-
-#else
-
-/* For Kernel usage.. */
-typedef bool	bc_bool_t;
-#endif
-
-#else
-
-#ifndef uint64_t
-typedef struct _uint64_t {
-	uint32_t low_dw;
-	uint32_t hi_dw;
-} uint64_t;
-#endif
-
-#ifndef int32_t
-typedef signed long		int32_t;
-#endif
-
-#ifndef uint32_t
-typedef unsigned long	uint32_t;
-#endif
-
-#ifndef uint16_t
-typedef unsigned short	uint16_t;
-#endif
-
-#ifndef uint8_t
-typedef unsigned char	uint8_t;
-#endif
-#endif
-
-#endif
-
-- 
1.7.1

