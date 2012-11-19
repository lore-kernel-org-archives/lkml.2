Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab2KSXfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 18:35:25 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48179 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab2KSXfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 18:35:17 -0500
X-AuditID: 9c93016f-b7b42ae000004383-dd-50aac22ef73d
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Jens Axboe <axboe@kernel.dk>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Luigi Semenzato <semenzato@google.com>, gaowanlong@cn.fujitsu.com,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v5 3/3] zram: select ZSMALLOC when ZRAM is configured
Date: Tue, 20 Nov 2012 08:35:13 +0900
Message-Id: <1353368113-1971-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353368113-1971-1-git-send-email-minchan@kernel.org>
References: <1353368113-1971-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the monent, we can configure zram in driver/block once zsmalloc
in /lib menu is configured firstly. It's not convenient.

User can configure zram in driver/block regardless of zsmalloc enabling
by this patch.

Acked-by: Pekka Enberg <penberg@kernel.org>
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

