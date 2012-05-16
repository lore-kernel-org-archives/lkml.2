Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912Ab2EPCFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 22:05:48 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51787 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271Ab2EPCFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 22:05:01 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-12-4fb30b477e3d
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v2 2/3] remove dependency with x86
Date: Wed, 16 May 2012 11:05:18 +0900
Message-Id: <1337133919-4182-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337133919-4182-1-git-send-email-minchan@kernel.org>
References: <1337133919-4182-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exactly saying, [zram|zcache] should has a dependency with
zsmalloc, not x86. So replace x86 dependeny with ZSMALLOC.

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zcache/Kconfig |    3 +--
 drivers/staging/zram/Kconfig   |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
index 7048e01..ceb7f28 100644
--- a/drivers/staging/zcache/Kconfig
+++ b/drivers/staging/zcache/Kconfig
@@ -2,8 +2,7 @@ config ZCACHE
 	bool "Dynamic compression of swap pages and clean pagecache pages"
 	# X86 dependency is because zsmalloc uses non-portable pte/tlb
 	# functions
-	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && X86
-	select ZSMALLOC
+	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && ZSMALLOC
 	select CRYPTO_LZO
 	default n
 	help
diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
index 9d11a4c..e3ac62d 100644
--- a/drivers/staging/zram/Kconfig
+++ b/drivers/staging/zram/Kconfig
@@ -2,8 +2,7 @@ config ZRAM
 	tristate "Compressed RAM block device support"
 	# X86 dependency is because zsmalloc uses non-portable pte/tlb
 	# functions
-	depends on BLOCK && SYSFS && X86
-	select ZSMALLOC
+	depends on BLOCK && SYSFS && ZSMALLOC
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	default n
-- 
1.7.9.5

