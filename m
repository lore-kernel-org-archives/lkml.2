Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab2HXHUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:20:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52179 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab2HXHUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:20:38 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-9d-50372b443d9e
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] mm: cma: fix alignment requirements for contiguous regions
Date: Fri, 24 Aug 2012 09:20:10 +0200
Message-id: <1345792810-5152-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t9jQV0XbfMAg/vPJC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGoTOr2QtaOCtO3drD1sB4jL2LkZNDQsBEYvOkC6wQtpjEhXvr
	2boYuTiEBKYzSkz+18IC4axmkjhw4yETSBWbgKFE19suNhBbRCBM4vHHr2AdzALvGSVWTt7F
	CJIQFvCW6Gy4DTaWRUBV4uSeNywgNq+Au8S5rZ9YINbJSzy938c2gZF7ASPDKkbR1ILkguKk
	9FwjveLE3OLSvHS95PzcTYxgLz6T3sG4qsHiEKMAB6MSD++OFrMAIdbEsuLK3EOMEhzMSiK8
	8x8DhXhTEiurUovy44tKc1KLDzFKc7AoifPy9xkGCAmkJ5akZqemFqQWwWSZODilGhi7TVcp
	PFol2io2nU/4w7Gbk05Lss5OnbGq8l75vJ1xWjITJtqHNJQkbOx/eOlI3OYzOy+ri6kkXQ5h
	9+xV2j79MEPJTNs2+62vjlRP/78k5taR8vkXz2Y+cexZKPf7p/gMPe0VVRc235430S7wnpJy
	8KF0nqonf+p0TzcwrfP6mXqmkmemxhx1JZbijERDLeai4kQAaPDhGd4BAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Contiguous Memory Allocator requires each of its regions to be aligned
in such a way that it is possible to change migration type for all
pageblocks holding it and then isolate page of largest possible order from
the buddy allocator (which is MAX_ORDER-1). This patch relaxes alignment
requirements by one order, because MAX_ORDER alignment is not really
needed.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/base/dma-contiguous.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 78efb03..34d94c7 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -250,7 +250,7 @@ int __init dma_declare_contiguous(struct device *dev, unsigned long size,
 		return -EINVAL;
 
 	/* Sanitise input arguments */
-	alignment = PAGE_SIZE << max(MAX_ORDER, pageblock_order);
+	alignment = PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
 	base = ALIGN(base, alignment);
 	size = ALIGN(size, alignment);
 	limit &= ~(alignment - 1);
-- 
1.7.1.569.g6f426

