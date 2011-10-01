Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab1JATYj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:24:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63249 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab1JATXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:23:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 11/11] ARM: common/vic: use proper __iomem annotations
Date: Sat,  1 Oct 2011 21:22:00 +0200
Message-Id: <1317496920-7764-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317496920-7764-1-git-send-email-arnd@arndb.de>
References: <1317496920-7764-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:k0kSWzv+sMSrX5jLmVsArb2QEl+GL+Vk8rn9zuOKguF
 YykEZBycRW69M8i8CqyWl2xA/fKIvvKEElwp0lsVl5Vl+1kz+7
 sKEP02RYAMrSeEmaT4X3wWfbAU7G0gocoAP6/N1VKjKwHy66xg
 g5YzwluzmOD82680H+/qr6+BgJ3YoKiXHnUV7jHoTyW3VPlso4
 1fKnvuHB3hpqbthjG/rU53y/jPA1pf3gLFPHKoaUwY9j4924WH
 nbWJVHtf+jMfmKCXiq7xYJ5yUKDROpUX0z07gDFUR5pIeCajox
 fRTmRlmoHfuxBB5ePRJn7iEH7FQXiU8RTfOUEXS8x0WpL29n7U
 82XsOGoYBmufZrCf3Cdhtpef+xS2N8rACSjMicZxj5XB6Dcsy6
 yNYWUBvu3jnAQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In vic_init, we pass addr into readl, so it needs to be a
pointer, not a u32 address.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/common/vic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/common/vic.c b/arch/arm/common/vic.c
index 7aa4262..adccf6d 100644
--- a/arch/arm/common/vic.c
+++ b/arch/arm/common/vic.c
@@ -347,7 +347,8 @@ void __init vic_init(void __iomem *base, unsigned int irq_start,
 
 	/* Identify which VIC cell this one is, by reading the ID */
 	for (i = 0; i < 4; i++) {
-		u32 addr = ((u32)base & PAGE_MASK) + 0xfe0 + (i * 4);
+		void __iomem *addr;
+		addr = (void __iomem *)((u32)base & PAGE_MASK) + 0xfe0 + (i * 4);
 		cellid |= (readl(addr) & 0xff) << (8 * i);
 	}
 	vendor = (cellid >> 12) & 0xff;
-- 
1.7.5.4

