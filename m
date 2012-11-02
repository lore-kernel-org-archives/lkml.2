Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2KBHHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 03:07:07 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56905 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab2KBHGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 03:06:49 -0400
X-AuditID: 9c930197-b7c0bae00000042f-73-509371049de9
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Jens Axboe <axboe@kernel.dk>, Pekka Enberg <penberg@cs.helsinki.fi>,
        gaowanlong@cn.fujitsu.com, Minchan Kim <minchan@kernel.org>
Subject: [PATCH v4 3/3] zram: select ZSMALLOC when ZRAM is configured
Date: Fri,  2 Nov 2012 16:12:47 +0900
Message-Id: <1351840367-4152-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351840367-4152-1-git-send-email-minchan@kernel.org>
References: <1351840367-4152-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the monent, we can configure zram in driver/block once zsmalloc
in /lib menu is configured firstly. It's not convenient.

User can configure zram in driver/block regardless of zsmalloc enabling
by this patch.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/Kconfig b/drivers/block/zram/Kconfig
index be5abe8..ee23a86 100644
--- a/drivers/block/zram/Kconfig
+++ b/drivers/block/zram/Kconfig
@@ -1,6 +1,7 @@
 config ZRAM
 	tristate "Compressed RAM block device support"
-	depends on BLOCK && SYSFS && ZSMALLOC
+	depends on BLOCK && SYSFS
+	select ZSMALLOC
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	default n
-- 
1.7.9.5

