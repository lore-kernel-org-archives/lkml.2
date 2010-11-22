Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab0KVR55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 12:57:57 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:34882 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0KVR54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 12:57:56 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Decompressors: Include <linux/slab.h> in <linux/decompress/mm.h>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
From: Lasse Collin <lasse.collin@tukaani.org>
Date: Mon, 22 Nov 2010 19:57:31 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011221957.31125.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

Currently users of mm.h need to include <linux/slab.h> to use
the macros malloc() and free() provided by mm.h. This fixes it.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

 include/linux/decompress/mm.h |    1 +
 lib/decompress_bunzip2.c      |    1 -
 lib/decompress_inflate.c      |    1 -
 lib/decompress_unlzma.c       |    1 -
 lib/decompress_unlzo.c        |    1 -
 5 files changed, 1 insertion(+), 4 deletions(-)

diff -uprN linux-2.6.37-rc3.orig/include/linux/decompress/mm.h linux-2.6.37-rc3/include/linux/decompress/mm.h
--- linux-2.6.37-rc3.orig/include/linux/decompress/mm.h	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc3/include/linux/decompress/mm.h	2010-11-22 14:40:35.000000000 +0200
@@ -72,6 +72,7 @@ static void free(void *where)
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 #include <linux/vmalloc.h>
 
 /* Use defines rather than static inline in order to avoid spurious
diff -uprN linux-2.6.37-rc3.orig/lib/decompress_bunzip2.c linux-2.6.37-rc3/lib/decompress_bunzip2.c
--- linux-2.6.37-rc3.orig/lib/decompress_bunzip2.c	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc3/lib/decompress_bunzip2.c	2010-11-22 14:40:35.000000000 +0200
@@ -49,7 +49,6 @@
 #define PREBOOT
 #else
 #include <linux/decompress/bunzip2.h>
-#include <linux/slab.h>
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
diff -uprN linux-2.6.37-rc3.orig/lib/decompress_inflate.c linux-2.6.37-rc3/lib/decompress_inflate.c
--- linux-2.6.37-rc3.orig/lib/decompress_inflate.c	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc3/lib/decompress_inflate.c	2010-11-22 14:40:35.000000000 +0200
@@ -19,7 +19,6 @@
 #include "zlib_inflate/inflate.h"
 
 #include "zlib_inflate/infutil.h"
-#include <linux/slab.h>
 
 #endif /* STATIC */
 
diff -uprN linux-2.6.37-rc3.orig/lib/decompress_unlzma.c linux-2.6.37-rc3/lib/decompress_unlzma.c
--- linux-2.6.37-rc3.orig/lib/decompress_unlzma.c	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc3/lib/decompress_unlzma.c	2010-11-22 14:40:35.000000000 +0200
@@ -33,7 +33,6 @@
 #define PREBOOT
 #else
 #include <linux/decompress/unlzma.h>
-#include <linux/slab.h>
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
diff -uprN linux-2.6.37-rc3.orig/lib/decompress_unlzo.c linux-2.6.37-rc3/lib/decompress_unlzo.c
--- linux-2.6.37-rc3.orig/lib/decompress_unlzo.c	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc3/lib/decompress_unlzo.c	2010-11-22 14:40:35.000000000 +0200
@@ -33,7 +33,6 @@
 #ifdef STATIC
 #include "lzo/lzo1x_decompress.c"
 #else
-#include <linux/slab.h>
 #include <linux/decompress/unlzo.h>
 #endif
 
