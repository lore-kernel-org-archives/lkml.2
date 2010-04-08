Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab0DHBie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 21:38:34 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34239 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab0DHBid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 21:38:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=aGtWNsY6xDVKkyyp8qYQkZz07oHJjTEJOfqYbHdeqUajB3JfEAMunW38DdHG5oo69X
         SEZ+hNuAxWovJWVETvTRUgoH3/CJnDMLzbHJpc6k+xiolBgFndRutVFVG7W6GsiVNNSK
         mPEt9tDSw6Qkk5Fh9dIoZNVZRWCqYdaI35Mgo=
MIME-Version: 1.0
Date: Wed, 7 Apr 2010 19:38:32 -0600
Message-ID: <x2sb985fb501004071838z51a832dftdfaece15e5a0e154@mail.gmail.com>
Subject: [PATCH] increase pipe size/buffers/atomicity :D
From: brian <knotwurk@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(tested and working with 2.6.32.8 kernel, on a Athlon/686)


--- include/linux/pipe_fs_i.h.orig      2010-04-06 22:56:51.000000000 -0500
+++ include/linux/pipe_fs_i.h   2010-04-06 22:56:58.000000000 -0500
@@ -3,7 +3,7 @@

 #define PIPEFS_MAGIC 0x50495045

-#define PIPE_BUFFERS (16)
+#define PIPE_BUFFERS (32)

 #define PIPE_BUF_FLAG_LRU      0x01    /* page is on the LRU */
 #define PIPE_BUF_FLAG_ATOMIC   0x02    /* was atomically mapped */
--- include/asm-generic/page.h.orig     2010-04-06 22:57:08.000000000 -0500
+++ include/asm-generic/page.h  2010-04-06 22:57:23.000000000 -0500
@@ -12,7 +12,7 @@

 /* PAGE_SHIFT determines the page size */

-#define PAGE_SHIFT     12
+#define PAGE_SHIFT     13
 #ifdef __ASSEMBLY__
 #define PAGE_SIZE      (1 << PAGE_SHIFT)
 #else
--- include/linux/limits.h.orig 2010-04-06 22:54:15.000000000 -0500
+++ include/linux/limits.h      2010-04-06 22:56:28.000000000 -0500
@@ -10,7 +10,7 @@
 #define MAX_INPUT        255   /* size of the type-ahead buffer */
 #define NAME_MAX         255   /* # chars in a file name */
 #define PATH_MAX        4096   /* # chars in a path name including nul */
-#define PIPE_BUF        4096   /* # bytes in atomic write to a pipe */
+#define PIPE_BUF        8192   /* # bytes in atomic write to a pipe */
 #define XATTR_NAME_MAX   255   /* # chars in an extended attribute name */
 #define XATTR_SIZE_MAX 65536   /* size of an extended attribute value (64k) */
 #define XATTR_LIST_MAX 65536   /* size of extended attribute namelist (64k) */
