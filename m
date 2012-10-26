Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965097Ab2JZQBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 12:01:43 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:9302 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964880Ab2JZQBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 12:01:42 -0400
Message-ID: <1351267298.4013.12.camel@lorien2>
Subject: [PATCH RFT RESEND linux-next] mips: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: ralf@linux-mips.org, kyungmin.park@samsung.com, arnd@arndb.de,
        andrzej.p@samsung.com, m.szyprowski@samsung.com
Cc: linux-mips@linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Fri, 26 Oct 2012 10:01:38 -0600
In-Reply-To: <1351208193.6851.17.camel@lorien2>
References: <1351208193.6851.17.camel@lorien2>
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
 arch/mips/include/asm/dma-mapping.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/include/asm/dma-mapping.h b/arch/mips/include/asm/dma-mapping.h
index be39a12..006b43e 100644
--- a/arch/mips/include/asm/dma-mapping.h
+++ b/arch/mips/include/asm/dma-mapping.h
@@ -40,6 +40,8 @@ static inline int dma_supported(struct device *dev, u64 mask)
 static inline int dma_mapping_error(struct device *dev, u64 mask)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	debug_dma_mapping_error(dev, mask);
 	return ops->mapping_error(dev, mask);
 }
 
-- 
1.7.9.5



