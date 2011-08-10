Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1HJPH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:07:59 -0400
Received: from service87.mimecast.com ([94.185.240.25]:41438 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753162Ab1HJPD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:03:57 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v7 02/16] ARM: LPAE: Cast the dma_addr_t argument to unsigned long in dma_to_virt
Date: Wed, 10 Aug 2011 16:03:25 +0100
Message-Id: <1312988619-16804-3-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 10 Aug 2011 15:03:50.0944 (UTC) FILETIME=[B6A8DA00:01CC576E]
X-MC-Unique: 111081016035405001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p7AF8Bdl003981

This is to avoid a compiler warning when invoking the __bus_to_virt()
macro. The dma_to_virt() function gets addresses within the 32-bit
range.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/dma-mapping.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 7a21d0b..28b7ee8 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -32,7 +32,7 @@ static inline unsigned long dma_to_pfn(struct device *dev, dma_addr_t addr)
 
 static inline void *dma_to_virt(struct device *dev, dma_addr_t addr)
 {
-	return (void *)__bus_to_virt(addr);
+	return (void *)__bus_to_virt((unsigned long)addr);
 }
 
 static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)

