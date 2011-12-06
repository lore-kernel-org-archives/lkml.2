Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1LFSuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:50:40 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58710 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab1LFSug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:50:36 -0500
From: Stephen Warren <swarren@nvidia.com>
To: Cong Wang <amwang@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] highmem: Fix ARM build break due to __kmap_atomic rename
Date: Tue,  6 Dec 2011 11:50:26 -0700
Message-Id: <1323197426-10815-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Git commit 37bfbb9 "highmem: kill all __kmap_atomic()" renamed
__kmap_atomic to kmap_atomic. However, arch/arm/include/asm/highmem.h
wasn't updated for that change. This change does so, and fixes the
ARM build break.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
This shows up in next-20111206 at least.

 arch/arm/include/asm/highmem.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/highmem.h b/arch/arm/include/asm/highmem.h
index a4edd19..8c5e828 100644
--- a/arch/arm/include/asm/highmem.h
+++ b/arch/arm/include/asm/highmem.h
@@ -57,7 +57,7 @@ static inline void *kmap_high_get(struct page *page)
 #ifdef CONFIG_HIGHMEM
 extern void *kmap(struct page *page);
 extern void kunmap(struct page *page);
-extern void *__kmap_atomic(struct page *page);
+extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 extern struct page *kmap_atomic_to_page(const void *ptr);
-- 
1.7.0.4

