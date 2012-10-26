Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab2JZQs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 12:48:27 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:16962 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab2JZQsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 12:48:16 -0400
Message-ID: <1351270093.4013.29.camel@lorien2>
Subject: [PATCH RFT linux-next] frv: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: dhowells@redhat.com
Cc: LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Fri, 26 Oct 2012 10:48:13 -0600
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
 arch/frv/include/asm/dma-mapping.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/frv/include/asm/dma-mapping.h b/arch/frv/include/asm/dma-mapping.h
index dfb8110..d8a8aac 100644
--- a/arch/frv/include/asm/dma-mapping.h
+++ b/arch/frv/include/asm/dma-mapping.h
@@ -6,6 +6,7 @@
 #include <asm/cacheflush.h>
 #include <asm/scatterlist.h>
 #include <asm/io.h>
+#include <linux/dma-debug.h>
 
 /*
  * See Documentation/DMA-API.txt for the description of how the
@@ -97,6 +98,7 @@ void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nele
 static inline
 int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
+	debug_dma_mapping_error(dev, dma_addr);
 	return 0;
 }
 
-- 
1.7.9.5



