Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965294Ab2JZQUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 12:20:09 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:2263 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965226Ab2JZQUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 12:20:07 -0400
Message-ID: <1351268403.4013.24.camel@lorien2>
Subject: [PATCH RFT linux-next] sh: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: lethal@linux-sh.org, kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        arnd@arndb.de, andrzej.p@samsung.com
Cc: linux-sh@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Fri, 26 Oct 2012 10:20:03 -0600
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



