Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab1JATXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:23:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61139 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604Ab1JATW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:22:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 08/11] ARM: add io{read,write}{16,32}be functions
Date: Sat,  1 Oct 2011 21:21:57 +0200
Message-Id: <1317496920-7764-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317496920-7764-1-git-send-email-arnd@arndb.de>
References: <1317496920-7764-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:/NaH4NmOSJwpWvFCiJRfeccxwli1QZuYaBFyHTLDLAe
 Tdy35jfk11JJLbDrXgUCoe4KwJ4d9lRaje/1+lZwZ/PlYfoKIq
 6q33N4UGgvltnFMBtYMWsiDAUoAJW5BtSUi6/H26JAKjs9l+ZY
 6c5wj3Flz/mlXVKtR1q3/NZ05HZs28xLuH4ofKLWFqNPyySnh6
 00Xc2eCmyANe/DZSnv/ziyKYDlZj7bzudiIPcUlTTqc+srC0xB
 6jBZPIB773PK4D50goaFDc4upmoSTFLLaDP/AZKVdpzfLAdYc6
 0SvTKkLsV4YQqqUDxr/AnONOYeKVHTiSzuQ19cu881psm3OAk7
 Tyh70E5yCIbfLRiTL2ZZRcRNRm+V5wzsdFvUnsRvk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are used in some PCI drivers with big-endian
MMIO space, and they are trivial to add here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/io.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index d66605d..bad7bfb 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -260,10 +260,16 @@ extern void _memset_io(volatile void __iomem *, int, size_t);
 #define ioread16(p)	({ unsigned int __v = le16_to_cpu((__force __le16)__raw_readw(p)); __iormb(); __v; })
 #define ioread32(p)	({ unsigned int __v = le32_to_cpu((__force __le32)__raw_readl(p)); __iormb(); __v; })
 
+#define ioread16be(p)	({ unsigned int __v = be16_to_cpu((__force __be16)__raw_readw(p)); __iormb(); __v; })
+#define ioread32be(p)	({ unsigned int __v = be32_to_cpu((__force __be32)__raw_readl(p)); __iormb(); __v; })
+
 #define iowrite8(v,p)	({ __iowmb(); (void)__raw_writeb(v, p); })
 #define iowrite16(v,p)	({ __iowmb(); (void)__raw_writew((__force __u16)cpu_to_le16(v), p); })
 #define iowrite32(v,p)	({ __iowmb(); (void)__raw_writel((__force __u32)cpu_to_le32(v), p); })
 
+#define iowrite16be(v,p) ({ __iowmb(); (void)__raw_writew((__force __u16)cpu_to_be16(v), p); })
+#define iowrite32be(v,p) ({ __iowmb(); (void)__raw_writel((__force __u32)cpu_to_be32(v), p); })
+
 #define ioread8_rep(p,d,c)	__raw_readsb(p,d,c)
 #define ioread16_rep(p,d,c)	__raw_readsw(p,d,c)
 #define ioread32_rep(p,d,c)	__raw_readsl(p,d,c)
-- 
1.7.5.4

