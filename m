Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab2HHGK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:10:58 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48567 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2HHGKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:10:55 -0400
X-AuditID: 9c93016f-b7b08ae00000790d-02-502202ea308b
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 7/7] zram: select ZSMALLOC when ZRAM is configured
Date: Wed,  8 Aug 2012 15:12:20 +0900
Message-Id: <1344406340-14128-8-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344406340-14128-1-git-send-email-minchan@kernel.org>
References: <1344406340-14128-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the monent, we can configure zram in driver/block once zsmalloc
in mm menu is configured firstly. It's not convenient.

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

