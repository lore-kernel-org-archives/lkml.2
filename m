Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965172Ab2JZQGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 12:06:00 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:6420 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964985Ab2JZQF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 12:05:59 -0400
Message-ID: <1351267555.4013.15.camel@lorien2>
Subject: [PATCH RFT RESEND linux-next] openrisc: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: jonas@southpole.se
Cc: linux@openrisc.net, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Fri, 26 Oct 2012 10:05:55 -0600
In-Reply-To: <1351208548.6851.19.camel@lorien2>
References: <1351208548.6851.19.camel@lorien2>
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
 arch/openrisc/include/asm/dma-mapping.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/openrisc/include/asm/dma-mapping.h b/arch/openrisc/include/asm/dma-mapping.h
index fab8628..f12de49 100644
--- a/arch/openrisc/include/asm/dma-mapping.h
+++ b/arch/openrisc/include/asm/dma-mapping.h
@@ -95,6 +95,7 @@ static inline int dma_supported(struct device *dev, u64 dma_mask)
 
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
+	debug_dma_mapping_error(dev, dma_addr);
 	return 0;
 }
 
-- 
1.7.9.5



