Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab1K3JHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 04:07:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757165Ab1K3JHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 04:07:12 -0500
Date: Wed, 30 Nov 2011 11:08:40 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH-RFC 1/2 v2] tile: don't panic on iomap
Message-ID: <20111130090839.GA20062@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3bc9cb56040258dabc7b466ea217f4515b68b7d.1322592495.git.mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think panic on iomap is there just for debugging.
If we return NULL instead, the generic pci_iomap will
do the same thing as the custom one that tile currently has
(that is, return NULL on an IO BAR)
so tile won't need to roll its own anymore.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Note: the other patch in the series is unchanged.
Changes from v1:
  - tweaked pr_info message

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
1.7.5.53.gc233e
