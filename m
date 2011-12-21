Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1LUQ22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:28:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab1LUQ2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:28:24 -0500
Date: Wed, 21 Dec 2011 18:30:22 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 RFC (repost) 14/16] mn10300: add missing __iomap markers
Message-ID: <1937e158e890d52d2097360d3270f270bd7e5001.1324484752.git.mst@redhat.com>
References: <cover.1324484752.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1324484752.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MN10300's *ioremap*() collection lacks __iomem markers.
Fix that.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/mn10300/include/asm/io.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/mn10300/include/asm/io.h b/arch/mn10300/include/asm/io.h
index 787255d..0d6d54f 100644
--- a/arch/mn10300/include/asm/io.h
+++ b/arch/mn10300/include/asm/io.h
@@ -251,15 +251,15 @@ static inline void *phys_to_virt(unsigned long address)
 /*
  * Change "struct page" to physical address.
  */
-static inline void *__ioremap(unsigned long offset, unsigned long size,
-			      unsigned long flags)
+static inline void __iomem *__ioremap(unsigned long offset, unsigned long size,
+				      unsigned long flags)
 {
-	return (void *) offset;
+	return (void __iomem *) offset;
 }
 
-static inline void *ioremap(unsigned long offset, unsigned long size)
+static inline void __iomem *ioremap(unsigned long offset, unsigned long size)
 {
-	return (void *) offset;
+	return (void __iomem *) offset;
 }
 
 /*
@@ -267,14 +267,14 @@ static inline void *ioremap(unsigned long offset, unsigned long size)
  * area.  it's useful if some control registers are in such an area and write
  * combining or read caching is not desirable:
  */
-static inline void *ioremap_nocache(unsigned long offset, unsigned long size)
+static inline void __iomem *ioremap_nocache(unsigned long offset, unsigned long size)
 {
-	return (void *) (offset | 0x20000000);
+	return (void __iomem *) (offset | 0x20000000);
 }
 
 #define ioremap_wc ioremap_nocache
 
-static inline void iounmap(void *addr)
+static inline void iounmap(void __iomem *addr)
 {
 }
 
-- 
1.7.8.382.g3daff

