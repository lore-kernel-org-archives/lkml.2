Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2JYXVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 19:21:31 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:8539 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2JYXVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 19:21:30 -0400
Message-ID: <1351207286.6851.13.camel@lorien2>
Subject: [PATCH RFT] ia64: dma-mapping: support debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: tony.luck@intel.com, fenghua.yu@intel.com, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com, arnd@arndb.de, andrzej.p@samsung.com
Cc: linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Thu, 25 Oct 2012 17:21:26 -0600
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for debug_dma_mapping_error() call to avoid warning from
debug_dma_unmap() interface when it checks for mapping error checked
status. Without this patch, device driver failed to check map error
warning is generated.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 arch/ia64/include/asm/dma-mapping.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index 4f5e814..cf3ab7e 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -58,6 +58,7 @@ static inline void dma_free_attrs(struct device *dev, size_t size,
 static inline int dma_mapping_error(struct device *dev, dma_addr_t daddr)
 {
 	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	debug_dma_mapping_error(dev, daddr);
 	return ops->mapping_error(dev, daddr);
 }
 
-- 
1.7.9.5



