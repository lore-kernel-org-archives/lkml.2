Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab2GFKI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:08:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42852 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2GFKIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:08:54 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-d4-4ff6b935446a
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] mm: cma: fix condition check when setting global cma area
Date: Fri, 06 Jul 2012 12:08:36 +0200
Message-id: <1341569316-17435-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t9jQV3Tnd/8Db43CVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MzweMC+axVSybt5i9gXEBaxcjJ4eEgInE/Nm32CBsMYkL99YD
	2VwcQgLTGSVWnlnKCOGsZpJYdqeXHaSKTcBQouttF1iHiICCxObeZ6wgRcwCSxgl9p4/wAyS
	EBbwktgxey+QzcHBIqAqceh8HUiYV8BD4vux3UwQ2+Qlnt7vY5vAyL2AkWEVo2hqQXJBcVJ6
	rqFecWJucWleul5yfu4mRrAHn0ntYFzZYHGIUYCDUYmHd8P8b/5CrIllxZW5hxglOJiVRHhV
	VgCFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8xp7f/UXEkhPLEnNTk0tSC2CyTJxcEo1MO6bsJGP
	91HeontWXEJL/q186x1rXjrnuq+KJ4OZgJzELaEj3hKNZ1iqHh95fkXDYbPB5C7e9jc5h/nK
	Fbm85EQW3ww5bbSkvE6yY97NAOeCKVbxXOdYOHscXFnWR7znNvZgcq3lc80SnKR/48DnrDrR
	dtfezrgwRvYfrU2+W/c2Gk9+fc9MiaU4I9FQi7moOBEAuCN0QdwBAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_set_cma_area incorrectly assigned cma to global area on first call
due to incorrect check. This patch fixes this issue.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 include/asm-generic/dma-contiguous.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/dma-contiguous.h b/include/asm-generic/dma-contiguous.h
index c544356..294b1e7 100644
--- a/include/asm-generic/dma-contiguous.h
+++ b/include/asm-generic/dma-contiguous.h
@@ -18,7 +18,7 @@ static inline void dev_set_cma_area(struct device *dev, struct cma *cma)
 {
 	if (dev)
 		dev->cma_area = cma;
-	if (!dev || !dma_contiguous_default_area)
+	if (!dev && !dma_contiguous_default_area)
 		dma_contiguous_default_area = cma;
 }
 
-- 
1.7.1.569.g6f426

