Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965018Ab2B1Nht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:37:49 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:56893 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757242Ab2B1Nhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:37:34 -0500
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Davidlohr Bueso <dave@gnu.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC][PATCH 6/6] USB: ffs-test: Don't duplicate {get,put}_unaligned*() functions
Date: Tue, 28 Feb 2012 13:37:25 +0000
Message-Id: <1330436245-24875-7-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1330436245-24875-1-git-send-email-matt@console-pimps.org>
References: <1330436245-24875-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Use the header file in tools/include instead of duplicating the endian
functions.

Cc: Davidlohr Bueso <dave@gnu.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 tools/usb/Makefile   |    2 +-
 tools/usb/ffs-test.c |   29 +----------------------------
 2 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/tools/usb/Makefile b/tools/usb/Makefile
index 8b704af..396d6c4 100644
--- a/tools/usb/Makefile
+++ b/tools/usb/Makefile
@@ -3,7 +3,7 @@
 CC = $(CROSS_COMPILE)gcc
 PTHREAD_LIBS = -lpthread
 WARNINGS = -Wall -Wextra
-CFLAGS = $(WARNINGS) -g $(PTHREAD_LIBS)
+CFLAGS = $(WARNINGS) -g $(PTHREAD_LIBS) -I../include
 
 all: testusb ffs-test
 %: %.c
diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index b9c7986..384f47a 100644
--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -36,6 +36,7 @@
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <unistd.h>
+#include <tools/le_byteshift.h>
 
 #include "../../include/linux/usb/functionfs.h"
 
@@ -47,34 +48,6 @@
 #define le32_to_cpu(x)  le32toh(x)
 #define le16_to_cpu(x)  le16toh(x)
 
-static inline __u16 get_unaligned_le16(const void *_ptr)
-{
-	const __u8 *ptr = _ptr;
-	return ptr[0] | (ptr[1] << 8);
-}
-
-static inline __u32 get_unaligned_le32(const void *_ptr)
-{
-	const __u8 *ptr = _ptr;
-	return ptr[0] | (ptr[1] << 8) | (ptr[2] << 16) | (ptr[3] << 24);
-}
-
-static inline void put_unaligned_le16(__u16 val, void *_ptr)
-{
-	__u8 *ptr = _ptr;
-	*ptr++ = val;
-	*ptr++ = val >> 8;
-}
-
-static inline void put_unaligned_le32(__u32 val, void *_ptr)
-{
-	__u8 *ptr = _ptr;
-	*ptr++ = val;
-	*ptr++ = val >>  8;
-	*ptr++ = val >> 16;
-	*ptr++ = val >> 24;
-}
-
 
 /******************** Messages and Errors ***********************************/
 
-- 
1.7.4.4

