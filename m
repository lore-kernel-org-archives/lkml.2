Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab0JZCyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:54:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284Ab0JZCyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:54:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 12/43] MN10300: Don't hard code the cacheline size in
 register defs
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:54:05 +0100
Message-ID: <20101026025405.23512.15982.stgit@warthog.procyon.org.uk>
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

Don't hard code the cacheline size in the cache control register definitions.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/cache.h |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)


diff --git a/arch/mn10300/include/asm/cache.h b/arch/mn10300/include/asm/cache.h
index 781bf61..f29cde2 100644
--- a/arch/mn10300/include/asm/cache.h
+++ b/arch/mn10300/include/asm/cache.h
@@ -43,14 +43,18 @@
 
 /* instruction cache access registers */
 #define ICACHE_DATA(WAY, ENTRY, OFF) \
-	__SYSREG(0xc8000000 + (WAY) * L1_CACHE_WAYDISP + (ENTRY) * 0x10 + (OFF) * 4, u32)
+	__SYSREG(0xc8000000 + (WAY) * L1_CACHE_WAYDISP + \
+		(ENTRY) * L1_CACHE_BYTES + (OFF) * 4, u32)
 #define ICACHE_TAG(WAY, ENTRY)	 \
-	__SYSREG(0xc8100000 + (WAY) * L1_CACHE_WAYDISP + (ENTRY) * 0x10, u32)
+	__SYSREG(0xc8100000 + (WAY) * L1_CACHE_WAYDISP + \
+		(ENTRY) * L1_CACHE_BYTES, u32)
 
-/* instruction cache access registers */
+/* data cache access registers */
 #define DCACHE_DATA(WAY, ENTRY, OFF) \
-	__SYSREG(0xc8200000 + (WAY) * L1_CACHE_WAYDISP + (ENTRY) * 0x10 + (OFF) * 4, u32)
+	__SYSREG(0xc8200000 + (WAY) * L1_CACHE_WAYDISP + \
+		(ENTRY) * L1_CACHE_BYTES + (OFF) * 4, u32)
 #define DCACHE_TAG(WAY, ENTRY)	 \
-	__SYSREG(0xc8300000 + (WAY) * L1_CACHE_WAYDISP + (ENTRY) * 0x10, u32)
+	__SYSREG(0xc8300000 + (WAY) * L1_CACHE_WAYDISP + \
+		(ENTRY) * L1_CACHE_BYTES, u32)
 
 #endif /* _ASM_CACHE_H */

