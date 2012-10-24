Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2JXFJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:09:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26650 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab2JXFJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:09:16 -0400
X-AuditID: cbfee61b-b7f616d00000319b-6a-508777fa6475
From: Jingoo Han <jg1.han@samsung.com>
To: "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Russell King'" <linux@arm.linux.org.uk>
Subject: [PATCH] ARM: dma-mapping: fix build warning in __dma_alloc()
Date: Wed, 24 Oct 2012 14:09:14 +0900
Message-id: <000f01cdb1a5$b6409b60$22c1d220$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2xpbYhmQsmM3DDRkGpqBMJe18/Mw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd3f5e0BBjcms1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mhcs+sBXcZKt4snE7awPjKdYuRk4OCQETibapD9kgbDGJC/fW
	A9lcHEICixglfr5qZ4dwZjNJrJw3BayKTUBN4suXw+wgtohAucSbb7dZQGxmAR+JX9N2gU0V
	FnCVOLhtEVg9i4CqxNwXK8DqeQVsJW7PWs0CYQtK/Jh8D6pXS2L9zuNMELa8xOY1b5m7GDmA
	LlKXePRXF2KVnsT7jgnMECUiEvtevGOcwCgwC8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9Jz
	jfSKE3OLS/PS9ZLzczcxggPzmfQOxlUNFocYBTgYlXh4E0+0BQixJpYVV+YeYpTgYFYS4Z18
	FyjEm5JYWZValB9fVJqTWnyIUZqDRUmct9kjJUBIID2xJDU7NbUgtQgmy8TBKdXAqMZSdVfr
	y8OeosJ9QXmn9jBITkh9tilp7a1X9X585aZBhUc++6c3Bc7iDKw+PEdn3vensowmjSnyfKfC
	AiK+xk62EDJrVr/LOtntvPf3xMlSdqvZ2xJ/zq5dnL/XNGLGSyZTwVO6DYEbLvxb+fqV9e5Z
	xpuKX4Za3HpxKtpzvvXS99eS3Du/KbEUZyQaajEXFScCAIDvDQFIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build warning in __dma_alloc() as below:

arch/arm/mm/dma-mapping.c: In function '__dma_alloc':
arch/arm/mm/dma-mapping.c:653:29: warning: 'page' may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 arch/arm/mm/dma-mapping.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 477a2d2..58bc3e4 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -610,7 +610,7 @@ static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
 			 gfp_t gfp, pgprot_t prot, bool is_coherent, const void *caller)
 {
 	u64 mask = get_coherent_dma_mask(dev);
-	struct page *page;
+	struct page *page = NULL;
 	void *addr;
 
 #ifdef CONFIG_DMA_API_DEBUG
-- 
1.7.1


