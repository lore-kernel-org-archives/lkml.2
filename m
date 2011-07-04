Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab1GDIMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 04:12:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54435 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab1GDIMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 04:12:32 -0400
Subject: [PATCH] ARM: DMA: Silence declared inside parameter list warning
 for !CONFIG_MMU
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jul 2011 16:12:21 +0800
Message-ID: <1309767141.3964.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below warning, the struct dma_coherent_area takes no space if !CONFIG_MMU.

  CC      arch/arm/mm/dma-mapping.o
arch/arm/mm/dma-mapping.c:309: warning: 'struct dma_coherent_area' declared inside parameter list
arch/arm/mm/dma-mapping.c:309: warning: its scope is only this definition or declaration, which is probably not what you want
arch/arm/mm/dma-mapping.c:334: warning: 'struct dma_coherent_area' declared inside parameter list
arch/arm/mm/dma-mapping.c:374: warning: 'struct dma_coherent_area' declared inside parameter list

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mm/dma-mapping.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 8089499..da3b33a 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -297,6 +297,8 @@ static void dma_free_area(void *cpu_addr, size_t size, struct dma_coherent_area
 #define coherent_wc_area NULL
 #define coherent_dma_area NULL
 
+struct dma_coherent_area { };
+
 void dma_coherent_reserve(void)
 {
 }
-- 
1.7.4.1



