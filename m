Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab2KWVgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 16:36:42 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:39882 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab2KWVgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 16:36:40 -0500
Message-ID: <1353706593.5270.103.camel@lorien2>
Subject: [PATCH 7/9] sh: dma_debug: add debug_dma_mapping_error support
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
Date: Fri, 23 Nov 2012 14:36:33 -0700
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
---
 arch/sh/include/asm/dma-mapping.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sh/include/asm/dma-mapping.h b/arch/sh/include/asm/dma-mapping.h
index 8bd965e..b437f2c 100644
--- a/arch/sh/include/asm/dma-mapping.h
+++ b/arch/sh/include/asm/dma-mapping.h
@@ -46,6 +46,7 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
+	debug_dma_mapping_error(dev, dma_addr);
 	if (ops->mapping_error)
 		return ops->mapping_error(dev, dma_addr);
 
-- 
1.7.9.5




