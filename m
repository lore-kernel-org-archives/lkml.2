Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab2JSNDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:03:53 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49736 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758763Ab2JSNDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:03:48 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, levinsasha928@gmail.com, Marc.Zyngier@arm.com,
        virtualization@lists.linux-foundation.org, akpm@linux-foundation.org,
        ericvh@gmail.com, Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 1/3] mm: highmem: export kmap_to_page for modules
Date: Fri, 19 Oct 2012 14:03:31 +0100
Message-Id: <1350651813-8694-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some virtio device drivers (9p) need to translate high virtual addresses
to physical addresses, which are inserted into the virtqueue for
processing by userspace.

This patch exports the kmap_to_page symbol, so that the affected drivers
can be compiled as modules.

Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 mm/highmem.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index d517cd1..2a07f97 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -105,6 +105,7 @@ struct page *kmap_to_page(void *vaddr)
 
 	return virt_to_page(addr);
 }
+EXPORT_SYMBOL(kmap_to_page);
 
 static void flush_all_zero_pkmaps(void)
 {
-- 
1.7.4.1

