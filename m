Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab2FYQmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 12:42:23 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51180 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191Ab2FYQmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 12:42:20 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] zram/zcache: swtich Kconfig dependency from X86 to ZSMALLOC
Date: Mon, 25 Jun 2012 11:14:36 -0500
Message-Id: <1340640878-27536-2-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062516-5806-0000-0000-000016A2F08F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch switches zcache and zram dependency to ZSMALLOC
rather than X86.  There is no net change since ZSMALLOC
depends on X86, however, this prevent further changes to
these files as zsmalloc dependencies change.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zcache/Kconfig |    5 +----
 drivers/staging/zram/Kconfig   |    5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
index 7048e01..4881839 100644
--- a/drivers/staging/zcache/Kconfig
+++ b/drivers/staging/zcache/Kconfig
@@ -1,9 +1,6 @@
 config ZCACHE
 	bool "Dynamic compression of swap pages and clean pagecache pages"
-	# X86 dependency is because zsmalloc uses non-portable pte/tlb
-	# functions
-	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && X86
-	select ZSMALLOC
+	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && ZSMALLOC=y
 	select CRYPTO_LZO
 	default n
 	help
diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
index 9d11a4c..be5abe8 100644
--- a/drivers/staging/zram/Kconfig
+++ b/drivers/staging/zram/Kconfig
@@ -1,9 +1,6 @@
 config ZRAM
 	tristate "Compressed RAM block device support"
-	# X86 dependency is because zsmalloc uses non-portable pte/tlb
-	# functions
-	depends on BLOCK && SYSFS && X86
-	select ZSMALLOC
+	depends on BLOCK && SYSFS && ZSMALLOC
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	default n
-- 
1.7.9.5

