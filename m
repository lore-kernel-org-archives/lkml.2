Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab2IQFPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 01:15:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58914 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab2IQFPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 01:15:32 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, sachin.kamat@linaro.org, patches@linaro.org,
        Arnd Bergmann <arnd@arndb.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] ARM: dma-mapping: Fix potential memory leak in atomic_pool_init()
Date: Mon, 17 Sep 2012 10:39:43 +0530
Message-Id: <1347858583-13338-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When either of __alloc_from_contiguous or __alloc_remap_buffer fails
to provide a valid pointer, allocated memory is freed up and an error
is returned. 'pages' was however not freed before returning error.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 arch/arm/mm/dma-mapping.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 546a3e8..477a2d2 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -367,6 +367,8 @@ static int __init atomic_pool_init(void)
 		       (unsigned)pool->size / 1024);
 		return 0;
 	}
+
+	kfree(pages);
 no_pages:
 	kfree(bitmap);
 no_bitmap:
-- 
1.7.4.1

