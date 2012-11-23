Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab2KWVcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 16:32:14 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:39240 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378Ab2KWVcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 16:32:12 -0500
Message-ID: <1353706326.5270.97.camel@lorien2>
Subject: [PATCH 2/9] c6x: dma_debug: add debug_dma_mapping_error support
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Joerg Roedel <joro@8bytes.org>, a-jacquiot@ti.com, fenghua.yu@intel.com,
        catalin.marinas@arm.com, lethal@linux-sh.org, benh@kernel.crashing.org,
        ralf@linux-mips.org, tony.luck@intel.com, davem@davemloft.net,
        m.szyprowski@samsung.com, msalter@redhat.com, monstr@monstr.eu,
        Ming Lei <ming.lei@canonical.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org,
        linux-ia64@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
        shuahkhan@gmail.com, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 23 Nov 2012 14:32:06 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dma-debug interface debug_dma_mapping_error() to debug drivers that fail
to check dma mapping errors on addresses returned by dma_map_single() and
dma_map_page() interfaces.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Acked-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/dma-mapping.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/c6x/include/asm/dma-mapping.h b/arch/c6x/include/asm/dma-mapping.h
index 03579fd..3c69406 100644
--- a/arch/c6x/include/asm/dma-mapping.h
+++ b/arch/c6x/include/asm/dma-mapping.h
@@ -32,6 +32,7 @@ static inline int dma_set_mask(struct device *dev, u64 dma_mask)
  */
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
+	debug_dma_mapping_error(dev, dma_addr);
 	return dma_addr == ~0;
 }
 
-- 
1.7.9.5





