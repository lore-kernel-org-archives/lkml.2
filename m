Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab0KVRwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 12:52:39 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:13154 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab0KVRwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 12:52:39 -0500
From: Lasse Collin <lasse.collin@tukaani.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Decompressors: Add missing INIT (i.e. __init)
Date: Mon, 22 Nov 2010 19:41:04 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-ARCH; KDE/4.5.3; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011221941.04815.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

diff -uprN linux-2.6.37-rc3.orig/lib/decompress_inflate.c linux-2.6.37-rc3/lib/decompress_inflate.c
--- linux-2.6.37-rc3.orig/lib/decompress_inflate.c	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc3/lib/decompress_inflate.c	2010-11-21 10:29:23.000000000 +0200
@@ -27,7 +27,7 @@
 
 #define GZIP_IOBUF_SIZE (16*1024)
 
-static int nofill(void *buffer, unsigned int len)
+static int INIT nofill(void *buffer, unsigned int len)
 {
 	return -1;
 }
diff -uprN linux-2.6.37-rc3.orig/lib/decompress_unlzma.c linux-2.6.37-rc3/lib/decompress_unlzma.c
--- linux-2.6.37-rc3.orig/lib/decompress_unlzma.c	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc3/lib/decompress_unlzma.c	2010-11-21 10:26:45.000000000 +0200
@@ -82,7 +82,7 @@ struct rc {
 #define RC_MODEL_TOTAL_BITS 11
 
 
-static int nofill(void *buffer, unsigned int len)
+static int INIT nofill(void *buffer, unsigned int len)
 {
 	return -1;
 }
@@ -169,7 +169,7 @@ static inline void INIT rc_update_bit_0(
 	rc->range = rc->bound;
 	*p += ((1 << RC_MODEL_TOTAL_BITS) - *p) >> RC_MOVE_BITS;
 }
-static inline void rc_update_bit_1(struct rc *rc, uint16_t *p)
+static inline void INIT rc_update_bit_1(struct rc *rc, uint16_t *p)
 {
 	rc->range -= rc->bound;
 	rc->code -= rc->bound;
