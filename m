Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab2JYXB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 19:01:26 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:40870 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab2JYXBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 19:01:25 -0400
Message-ID: <1351206082.6851.6.camel@lorien2>
Subject: [PATCH RFT] c6x: dma-mapping: support debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: msalter@redhat.com, a-jacquiot@ti.com
Cc: linux-c6x-dev@linux-c6x.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Thu, 25 Oct 2012 17:01:22 -0600
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



