Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab2KDCPp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 22:15:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:9855 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab2KDCPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 22:15:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,707,1344236400"; 
   d="scan'208";a="236866742"
Date: Sun, 4 Nov 2012 10:15:39 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] h8300: add missing L1_CACHE_SHIFT
Message-ID: <20121104021539.GA12616@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To fix build error

lib/atomic64.c: In function 'lock_addr':
lib/atomic64.c:40:11: error: 'L1_CACHE_SHIFT' undeclared (first use in this function)
lib/atomic64.c:40:11: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 arch/h8300/include/asm/cache.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next.orig/arch/h8300/include/asm/cache.h	2012-11-04 09:52:43.852745306 +0800
+++ linux-next/arch/h8300/include/asm/cache.h	2012-11-04 09:53:09.652745920 +0800
@@ -2,7 +2,8 @@
 #define __ARCH_H8300_CACHE_H
 
 /* bytes per L1 cache line */
-#define        L1_CACHE_BYTES  4
+#define        L1_CACHE_SHIFT  2
+#define        L1_CACHE_BYTES  (1 << L1_CACHE_SHIFT)
 
 /* m68k-elf-gcc  2.95.2 doesn't like these */
 
