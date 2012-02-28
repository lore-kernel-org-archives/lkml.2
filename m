Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030341Ab2B1T2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:28:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55032 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030279Ab2B1T16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:27:58 -0500
Date: Tue, 28 Feb 2012 11:27:02 -0800
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-24fa9a9d6d70ef7ef7087dce472a8f43a9078da5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        mingo@redhat.com, dave@gnu.org, tglx@linutronix.de,
        matt.fleming@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, dave@gnu.org,
        matt.fleming@intel.com
In-Reply-To: <1330436245-24875-7-git-send-email-matt@console-pimps.org>
References: <1330436245-24875-7-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] USB: ffs-test: Don't duplicate {get,
 put}_unaligned*() functions
Git-Commit-ID: 24fa9a9d6d70ef7ef7087dce472a8f43a9078da5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 28 Feb 2012 11:27:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  24fa9a9d6d70ef7ef7087dce472a8f43a9078da5
Gitweb:     http://git.kernel.org/tip/24fa9a9d6d70ef7ef7087dce472a8f43a9078da5
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Tue, 28 Feb 2012 13:37:25 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 28 Feb 2012 10:23:18 -0800

USB: ffs-test: Don't duplicate {get,put}_unaligned*() functions

Use the header file in tools/include instead of duplicating the endian
functions.

Cc: Davidlohr Bueso <dave@gnu.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1330436245-24875-7-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
 
