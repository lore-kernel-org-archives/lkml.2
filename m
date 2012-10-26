Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab2JZAgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:36:23 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:39457 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab2JZAgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:36:20 -0400
Message-ID: <1351211773.6851.24.camel@lorien2>
Subject: [PATCH RFT] sparc: dma-mapping: support debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: davem@davemloft.net, kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        sam@ravnborg.org, arnd@arndb.de
Cc: sparclinux@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Thu, 25 Oct 2012 18:36:13 -0600
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9e8feb61482288c5a5dd609e0dd17c1a262a48a3 Mon Sep 17 00:00:00 2001
From: Shuah Khan <shuahkhan@gmail.com>
Date: Thu, 25 Oct 2012 18:31:42 -0600
Subject: [PATCH RFT] sparc: dma-mapping: support debug_dma_mapping_error

Add support for debug_dma_mapping_error() call to avoid warning from
debug_dma_unmap() interface when it checks for mapping error checked
status. Without this patch, device driver failed to check map error
warning is generated.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 arch/sparc/include/asm/dma-mapping.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/include/asm/dma-mapping.h b/arch/sparc/include/asm/dma-mapping.h
index 8493fd3..05fe53f 100644
--- a/arch/sparc/include/asm/dma-mapping.h
+++ b/arch/sparc/include/asm/dma-mapping.h
@@ -59,6 +59,7 @@ static inline void dma_free_attrs(struct device *dev, size_t size,
 
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
+	debug_dma_mapping_error(dev, dma_addr);
 	return (dma_addr == DMA_ERROR_CODE);
 }
 
-- 
1.7.9.5



