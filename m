Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835Ab2JZPXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:23:14 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:40972 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933738Ab2JZPXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:23:08 -0400
Message-ID: <1351264983.2712.14.camel@lorien2>
Subject: [PATCH linux-next] ARM64: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: tony@atomide.com, olof@lixom.net, santosh.shilimkar@ti.com,
        nico@linaro.org, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, shuahkhan@gmail.com
Date: Fri, 26 Oct 2012 09:23:03 -0600
In-Reply-To: <CAHkRjk6jDKsFMa1_Wapwr7y5n8Ut8xfNBKWniSfHN_01z7qWFQ@mail.gmail.com>
References: <1351205220.6851.3.camel@lorien2>
	 <CAHkRjk6jDKsFMa1_Wapwr7y5n8Ut8xfNBKWniSfHN_01z7qWFQ@mail.gmail.com>
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
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/dma-mapping.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
index 538f4b4..9947768 100644
--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -50,6 +50,7 @@ static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t dev_addr)
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dev_addr)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
+	debug_dma_mapping_error(dev, dev_addr);
 	return ops->mapping_error(dev, dev_addr);
 }
 
-- 
1.7.9.5



