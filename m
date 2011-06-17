Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab1FQI6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:58:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:56155 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758185Ab1FQI5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:57:18 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 07/10] arm: change valid_phys_addr_range's @addr param to phys_addr_t
Date: Fri, 17 Jun 2011 10:46:51 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc2-0.0.5.bd76874-default; KDE/4.6.0; i686; ; )
References: <201106171038.25988.ptesarik@suse.cz>
In-Reply-To: <201106171038.25988.ptesarik@suse.cz>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171046.52057.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No other changes are needed, the function will work just fine with
a potentially larger data type.


Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/arm/include/asm/io.h |    2 +-
 arch/arm/mm/mmap.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index d66605d..91e4ff2 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -290,7 +290,7 @@ extern void pci_iounmap(struct pci_dev *dev, void __iomem *addr);
 
 #ifdef CONFIG_MMU
 #define ARCH_HAS_VALID_PHYS_ADDR_RANGE
-extern int valid_phys_addr_range(unsigned long addr, size_t size);
+extern int valid_phys_addr_range(phys_addr_t addr, size_t size);
 extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
 extern int devmem_is_allowed(unsigned long pfn);
 #endif
diff --git a/arch/arm/mm/mmap.c b/arch/arm/mm/mmap.c
index 74be05f..3bf1d88 100644
--- a/arch/arm/mm/mmap.c
+++ b/arch/arm/mm/mmap.c
@@ -127,7 +127,7 @@ full_search:
  * You really shouldn't be using read() or write() on /dev/mem.  This
  * might go away in the future.
  */
-int valid_phys_addr_range(unsigned long addr, size_t size)
+int valid_phys_addr_range(phys_addr_t addr, size_t size)
 {
 	if (addr < PHYS_OFFSET)
 		return 0;
-- 
1.7.3.4
