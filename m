Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076Ab0JZCy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:54:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759055Ab0JZCyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:54:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 19/43] MN10300: Cacheflush functions should take unsigned
 long addresses
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:54:43 +0100
Message-ID: <20101026025443.23512.62524.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

The functions that perform cache flushing should take addresses of unsigned
long type, not unsigned int.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/cacheflush.h |   18 +++++++++---------
 arch/mn10300/mm/cache-flush-by-tag.S  |   12 ++++++------
 2 files changed, 15 insertions(+), 15 deletions(-)


diff --git a/arch/mn10300/include/asm/cacheflush.h b/arch/mn10300/include/asm/cacheflush.h
index 0b5d004..a9f4168 100644
--- a/arch/mn10300/include/asm/cacheflush.h
+++ b/arch/mn10300/include/asm/cacheflush.h
@@ -22,18 +22,18 @@
 #ifdef CONFIG_MN10300_CACHE_ENABLED
 extern void mn10300_icache_inv(void);
 extern void mn10300_dcache_inv(void);
-extern void mn10300_dcache_inv_page(unsigned start);
-extern void mn10300_dcache_inv_range(unsigned start, unsigned end);
-extern void mn10300_dcache_inv_range2(unsigned start, unsigned size);
+extern void mn10300_dcache_inv_page(unsigned long start);
+extern void mn10300_dcache_inv_range(unsigned long start, unsigned long end);
+extern void mn10300_dcache_inv_range2(unsigned long start, unsigned long size);
 #ifdef CONFIG_MN10300_CACHE_WBACK
 extern void mn10300_dcache_flush(void);
-extern void mn10300_dcache_flush_page(unsigned start);
-extern void mn10300_dcache_flush_range(unsigned start, unsigned end);
-extern void mn10300_dcache_flush_range2(unsigned start, unsigned size);
+extern void mn10300_dcache_flush_page(unsigned long start);
+extern void mn10300_dcache_flush_range(unsigned long start, unsigned long end);
+extern void mn10300_dcache_flush_range2(unsigned long start, unsigned long size);
 extern void mn10300_dcache_flush_inv(void);
-extern void mn10300_dcache_flush_inv_page(unsigned start);
-extern void mn10300_dcache_flush_inv_range(unsigned start, unsigned end);
-extern void mn10300_dcache_flush_inv_range2(unsigned start, unsigned size);
+extern void mn10300_dcache_flush_inv_page(unsigned long start);
+extern void mn10300_dcache_flush_inv_range(unsigned long start, unsigned long end);
+extern void mn10300_dcache_flush_inv_range2(unsigned long start, unsigned long size);
 #else
 #define mn10300_dcache_flush()				do {} while (0)
 #define mn10300_dcache_flush_page(start)		do {} while (0)
diff --git a/arch/mn10300/mm/cache-flush-by-tag.S b/arch/mn10300/mm/cache-flush-by-tag.S
index c8ed1cb..8fe90e4 100644
--- a/arch/mn10300/mm/cache-flush-by-tag.S
+++ b/arch/mn10300/mm/cache-flush-by-tag.S
@@ -62,9 +62,9 @@ mn10300_dcache_flush_end:
 
 ###############################################################################
 #
-# void mn10300_dcache_flush_page(unsigned start)
-# void mn10300_dcache_flush_range(unsigned start, unsigned end)
-# void mn10300_dcache_flush_range2(unsigned start, unsigned size)
+# void mn10300_dcache_flush_page(unsigned long start)
+# void mn10300_dcache_flush_range(unsigned long start, unsigned long end)
+# void mn10300_dcache_flush_range2(unsigned long start, unsigned long size)
 # Flush a range of addresses on a page in the dcache
 #
 ###############################################################################
@@ -142,9 +142,9 @@ mn10300_dcache_flush_inv_end:
 
 ###############################################################################
 #
-# void mn10300_dcache_flush_inv_page(unsigned start)
-# void mn10300_dcache_flush_inv_range(unsigned start, unsigned end)
-# void mn10300_dcache_flush_inv_range2(unsigned start, unsigned size)
+# void mn10300_dcache_flush_inv_page(unsigned long start)
+# void mn10300_dcache_flush_inv_range(unsigned long start, unsigned long end)
+# void mn10300_dcache_flush_inv_range2(unsigned long start, unsigned long size)
 # Flush and invalidate a range of addresses on a page in the dcache
 #
 ###############################################################################

