Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab2JZAQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:16:37 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:9040 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab2JZAQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:16:33 -0400
Message-ID: <1351210584.6851.21.camel@lorien2>
Subject: [PATCH RFT] powerpc: dma-mapping: support debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: benh@kernel.crashing.org, paulus@samba.org, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com, david@gibson.dropbear.id.au, arnd@arndb.de,
        andrzej.p@samsung.com
Cc: linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Thu, 25 Oct 2012 18:16:24 -0600
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
 arch/powerpc/include/asm/dma-mapping.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index 7816087..e27e9ad 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -172,6 +172,7 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
+	debug_dma_mapping_error(dev, dma_addr);
 	if (dma_ops->mapping_error)
 		return dma_ops->mapping_error(dev, dma_addr);
 
-- 
1.7.9.5



