Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab1HWHEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 03:04:53 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:13663 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1HWHEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 03:04:51 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
CC: <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH] mm:page.h: Calculate virt_to_page and page_to_virt via predefined macro.
Date: Tue, 23 Aug 2011 14:58:26 +0800
Message-ID: <1314082706-11352-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

In NOMMU architecture, if physical memory doesn't start from 0, ARCH_PFN_OFFSET is defined
to generate page index in mem_map array. Because virtual address is equal to physical
address, PAGE_OFFSET is always 0. virt_to_page and page_to_virt should not index page by
PAGE_OFFSET directly.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 include/asm-generic/page.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/page.h b/include/asm-generic/page.h
index 75fec18..96a1dc3 100644
--- a/include/asm-generic/page.h
+++ b/include/asm-generic/page.h
@@ -79,8 +79,13 @@ extern unsigned long memory_end;
 #define virt_to_pfn(kaddr)	(__pa(kaddr) >> PAGE_SHIFT)
 #define pfn_to_virt(pfn)	__va((pfn) << PAGE_SHIFT)
 
+#if 0
 #define virt_to_page(addr)	(mem_map + (((unsigned long)(addr)-PAGE_OFFSET) >> PAGE_SHIFT))
 #define page_to_virt(page)	((((page) - mem_map) << PAGE_SHIFT) + PAGE_OFFSET)
+#endif
+#define virt_to_page(addr)      pfn_to_page(virt_to_pfn(addr))
+#define page_to_virt(page)      pfn_to_virt(page_to_pfn(page))
+
 
 #ifndef page_to_phys
 #define page_to_phys(page)      ((dma_addr_t)page_to_pfn(page) << PAGE_SHIFT)
-- 
1.7.0.4


