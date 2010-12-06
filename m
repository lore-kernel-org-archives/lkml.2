Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab0LFX1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:27:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27223 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab0LFXZ0 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:26 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, tony.luck@intel.com
Subject: [PATCH 19/23] ia64/sgi: fix compile error.
Date: Mon,  6 Dec 2010 18:24:31 -0500
Message-Id: <1291677875-30493-20-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I enabled CONFIG_IA64_SGI_NV2 and got these compile errors:

/linux/arch/ia64/sn/pci/pcibr/pcibr_dma.c:237: error: conflicting types for 'sn_dma_flush'
/linux/arch/ia64/include/asm/sn/io.h:21: note: previous declaration of 'sn_dma_flush' was here
/linux/arch/ia64/sn/pci/pcibr/pcibr_dma.c:412: error: conflicting types for 'sn_dma_flush'
/linux/arch/ia64/include/asm/sn/io.h:21: note: previous declaration of 'sn_dma_flush' was here

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: tony.luck@intel.com
---
 arch/ia64/include/asm/sn/io.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/ia64/include/asm/sn/io.h b/arch/ia64/include/asm/sn/io.h
index 41c73a7..238ee67 100644
--- a/arch/ia64/include/asm/sn/io.h
+++ b/arch/ia64/include/asm/sn/io.h
@@ -18,7 +18,7 @@ extern int num_cnodes;
 
 #define __sn_mf_a()   ia64_mfa()
 
-extern void sn_dma_flush(unsigned long);
+extern void sn_dma_flush(u64);
 
 #define __sn_inb ___sn_inb
 #define __sn_inw ___sn_inw
@@ -62,7 +62,7 @@ ___sn_inb (unsigned long port)
 	if ((addr = sn_io_addr(port))) {
 		ret = *addr;
 		__sn_mf_a();
-		sn_dma_flush((unsigned long)addr);
+		sn_dma_flush((u64)addr);
 	}
 	return ret;
 }
@@ -76,7 +76,7 @@ ___sn_inw (unsigned long port)
 	if ((addr = sn_io_addr(port))) {
 		ret = *addr;
 		__sn_mf_a();
-		sn_dma_flush((unsigned long)addr);
+		sn_dma_flush((u64)addr);
 	}
 	return ret;
 }
@@ -90,7 +90,7 @@ ___sn_inl (unsigned long port)
 	if ((addr = sn_io_addr(port))) {
 		ret = *addr;
 		__sn_mf_a();
-		sn_dma_flush((unsigned long)addr);
+		sn_dma_flush((u64)addr);
 	}
 	return ret;
 }
@@ -144,7 +144,7 @@ ___sn_readb (const volatile void __iomem *addr)
 
 	val = *(volatile unsigned char __force *)addr;
 	__sn_mf_a();
-	sn_dma_flush((unsigned long)addr);
+	sn_dma_flush((u64)addr);
         return val;
 }
 
@@ -155,7 +155,7 @@ ___sn_readw (const volatile void __iomem *addr)
 
 	val = *(volatile unsigned short __force *)addr;
 	__sn_mf_a();
-	sn_dma_flush((unsigned long)addr);
+	sn_dma_flush((u64)addr);
         return val;
 }
 
@@ -166,7 +166,7 @@ ___sn_readl (const volatile void __iomem *addr)
 
 	val = *(volatile unsigned int __force *)addr;
 	__sn_mf_a();
-	sn_dma_flush((unsigned long)addr);
+	sn_dma_flush((u64)addr);
         return val;
 }
 
@@ -177,7 +177,7 @@ ___sn_readq (const volatile void __iomem *addr)
 
 	val = *(volatile unsigned long __force *)addr;
 	__sn_mf_a();
-	sn_dma_flush((unsigned long)addr);
+	sn_dma_flush((u64)addr);
         return val;
 }
 
-- 
1.7.1

