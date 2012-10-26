Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964967Ab2JZPxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:53:40 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:6178 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964887Ab2JZPxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:53:38 -0400
Message-ID: <1351266812.4013.8.camel@lorien2>
Subject: [PATCH v2 linux-next] microblaze: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: monstr@monstr.eu
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com, arnd@arndb.de,
        andrzej.p@samsung.com, microblaze-uclinux@itee.uq.edu.au,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Fri, 26 Oct 2012 09:53:32 -0600
In-Reply-To: <1351263531.2712.3.camel@lorien2>
References: <1351207747.6851.15.camel@lorien2> <508A49D3.2080303@monstr.eu>
	 <1351263531.2712.3.camel@lorien2>
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
Acked-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/dma-mapping.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/microblaze/include/asm/dma-mapping.h b/arch/microblaze/include/asm/dma-mapping.h
index 01d2282..46460f1 100644
--- a/arch/microblaze/include/asm/dma-mapping.h
+++ b/arch/microblaze/include/asm/dma-mapping.h
@@ -114,6 +114,8 @@ static inline void __dma_sync(unsigned long paddr,
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	debug_dma_mapping_error(dev, dma_addr);
 	if (ops->mapping_error)
 		return ops->mapping_error(dev, dma_addr);
 
-- 
1.7.9.5



