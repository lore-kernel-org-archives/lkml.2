Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab1LGJWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:22:14 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54200 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab1LGJWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:22:12 -0500
Message-ID: <1323249719.27710.2.camel@phoenix>
Subject: [PATCH] highmem: fix missed kmap_atomic update in
 arch/arm/include/asm/highmem.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <amwang@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 07 Dec 2011 17:21:59 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 37bfbb "highmem: kill all __kmap_atomic()" missed the update to
arch/arm/include/asm/highmem.h.

This patch fixes below build error:
  CC      init/main.o
In file included from include/linux/pagemap.h:10,
                 from include/linux/mempolicy.h:70,
                 from init/main.c:49:
include/linux/highmem.h: In function 'kmap_atomic_deprecated':
include/linux/highmem.h:127: error: implicit declaration of function 'kmap_atomic'
include/linux/highmem.h:127: warning: return makes pointer from integer without a cast
include/linux/highmem.h: In function 'clear_highpage':
include/linux/highmem.h:218: warning: initialization makes pointer from integer without a cast
include/linux/highmem.h: In function 'zero_user_segments':
include/linux/highmem.h:227: warning: initialization makes pointer from integer without a cast
include/linux/highmem.h: In function 'copy_highpage':
include/linux/highmem.h:279: warning: assignment makes pointer from integer without a cast
include/linux/highmem.h:280: warning: assignment makes pointer from integer without a cast
make[1]: *** [init/main.o] Error 1
make: *** [init] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I got the build error by "make tegra_defconfig;make" on linux-next 20111207.
Thus this patch is against linux-next tree.

BTW, why commit 37bfbb "highmem: kill all __kmap_atomic()" does not have any
Signed-off-by?

Axel
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
1.7.5.4



