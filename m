Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab1FQI6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:58:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001Ab1FQI5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:57:18 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 06/10] sh: change valid_phys_addr_range's @addr param to phys_addr_t
Date: Fri, 17 Jun 2011 10:46:24 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc2-0.0.5.bd76874-default; KDE/4.6.0; i686; ; )
References: <201106171038.25988.ptesarik@suse.cz>
In-Reply-To: <201106171038.25988.ptesarik@suse.cz>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171046.24949.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No other changes are needed, the function will work just fine with
a potentially larger data type.


Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/sh/include/asm/io.h |    2 +-
 arch/sh/mm/mmap.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh/include/asm/io.h b/arch/sh/include/asm/io.h
index 28c5aa5..e6d5add 100644
--- a/arch/sh/include/asm/io.h
+++ b/arch/sh/include/asm/io.h
@@ -383,7 +383,7 @@ static inline int iounmap_fixed(void __iomem *addr) { return -EINVAL; }
 #define xlate_dev_kmem_ptr(p)	p
 
 #define ARCH_HAS_VALID_PHYS_ADDR_RANGE
-int valid_phys_addr_range(unsigned long addr, size_t size);
+int valid_phys_addr_range(phys_addr_t addr, size_t size);
 int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
 
 #endif /* __KERNEL__ */
diff --git a/arch/sh/mm/mmap.c b/arch/sh/mm/mmap.c
index afeb710..80bf494 100644
--- a/arch/sh/mm/mmap.c
+++ b/arch/sh/mm/mmap.c
@@ -238,7 +238,7 @@ bottomup:
  * You really shouldn't be using read() or write() on /dev/mem.  This
  * might go away in the future.
  */
-int valid_phys_addr_range(unsigned long addr, size_t count)
+int valid_phys_addr_range(phys_addr_t addr, size_t count)
 {
 	if (addr < __MEMORY_START)
 		return 0;
-- 
1.7.3.4
