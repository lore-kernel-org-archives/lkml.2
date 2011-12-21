Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab1LUQ2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:28:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab1LUQ2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:28:03 -0500
Date: Wed, 21 Dec 2011 18:30:02 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 RFC (repost) 11/16] tile: don't panic on iomap
Message-ID: <aa4256d1c1644875fd69c7024193c7ac317ee7c6.1324484752.git.mst@redhat.com>
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

I think panic on iomap is there just for debugging.
If we return NULL instead, the generic pci_iomap will
DTRT so we don't need to roll our own.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/io.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
index c9ea165..d2152de 100644
--- a/arch/tile/include/asm/io.h
+++ b/arch/tile/include/asm/io.h
@@ -204,7 +204,8 @@ static inline long ioport_panic(void)
 
 static inline void __iomem *ioport_map(unsigned long port, unsigned int len)
 {
-	return (void __iomem *) ioport_panic();
+	pr_info("ioport_map: mapping IO resources is unsupported on tile.\n");
+	return NULL;
 }
 
 static inline void ioport_unmap(void __iomem *addr)
-- 
1.7.8.382.g3daff

