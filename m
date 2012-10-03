Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab2JCO4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:56:06 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47417 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab2JCOzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:55:16 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Sekhar Nori <nsekhar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: [PATCH v3 4/6] ARM: davinci: add platform hook to fetch the SRAM pool
Date: Wed,  3 Oct 2012 10:55:31 -0400
Message-Id: <1349276133-26408-5-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276133-26408-1-git-send-email-mporter@ti.com>
References: <1349276133-26408-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds sram_get_gen_pool() which allows platform code to get
the SRAM gen_pool for purposes of providing it in platform
data for driver genalloc use.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/mach-davinci/include/mach/sram.h |    3 +++
 arch/arm/mach-davinci/sram.c              |    5 +++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/mach-davinci/include/mach/sram.h b/arch/arm/mach-davinci/include/mach/sram.h
index 111f7cc..4e5db56 100644
--- a/arch/arm/mach-davinci/include/mach/sram.h
+++ b/arch/arm/mach-davinci/include/mach/sram.h
@@ -24,4 +24,7 @@
 extern void *sram_alloc(size_t len, dma_addr_t *dma);
 extern void sram_free(void *addr, size_t len);
 
+/* Get the struct gen_pool * for use in platform data */
+extern struct gen_pool *sram_get_gen_pool(void);
+
 #endif /* __MACH_SRAM_H */
diff --git a/arch/arm/mach-davinci/sram.c b/arch/arm/mach-davinci/sram.c
index 0e8ca4f..b47b64d 100644
--- a/arch/arm/mach-davinci/sram.c
+++ b/arch/arm/mach-davinci/sram.c
@@ -18,6 +18,11 @@
 
 static struct gen_pool *sram_pool;
 
+struct gen_pool *sram_get_gen_pool(void)
+{
+	return sram_pool;
+}
+
 void *sram_alloc(size_t len, dma_addr_t *dma)
 {
 	unsigned long vaddr;
-- 
1.7.9.5

