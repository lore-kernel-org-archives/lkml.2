Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab2JTHCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 03:02:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38409 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2JTHCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 03:02:39 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux-davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH] media: davinci: vpbe: fix build warning
Date: Sat, 20 Oct 2012 12:32:20 +0530
Message-Id: <1350716540-10638-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

Warnings were generated because of the following commit changed data type for
address pointer

195bbca ARM: 7500/1: io: avoid writeback addressing modes for __raw_ accessors
add  __iomem annotation to fix following warnings

drivers/media/platform/davinci/vpbe_osd.c: In function ‘osd_read’:
drivers/media/platform/davinci/vpbe_osd.c:49:2: warning: passing
 argument 1 of ‘__raw_readl’ makes pointer from integer without a cast [enabled by default]
arch/arm/include/asm/io.h:104:19: note: expected ‘const volatile
 void *’ but argument is of type ‘long unsigned int’

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/platform/davinci/vpbe_osd.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_osd.c b/drivers/media/platform/davinci/vpbe_osd.c
index bba299d..9ab9280 100644
--- a/drivers/media/platform/davinci/vpbe_osd.c
+++ b/drivers/media/platform/davinci/vpbe_osd.c
@@ -46,14 +46,14 @@ static inline u32 osd_read(struct osd_state *sd, u32 offset)
 {
 	struct osd_state *osd = sd;
 
-	return readl(osd->osd_base + offset);
+	return readl(IOMEM(osd->osd_base + offset));
 }
 
 static inline u32 osd_write(struct osd_state *sd, u32 val, u32 offset)
 {
 	struct osd_state *osd = sd;
 
-	writel(val, osd->osd_base + offset);
+	writel(val, IOMEM(osd->osd_base + offset));
 
 	return val;
 }
@@ -63,9 +63,9 @@ static inline u32 osd_set(struct osd_state *sd, u32 mask, u32 offset)
 	struct osd_state *osd = sd;
 
 	u32 addr = osd->osd_base + offset;
-	u32 val = readl(addr) | mask;
+	u32 val = readl(IOMEM(addr)) | mask;
 
-	writel(val, addr);
+	writel(val, IOMEM(addr));
 
 	return val;
 }
@@ -75,9 +75,9 @@ static inline u32 osd_clear(struct osd_state *sd, u32 mask, u32 offset)
 	struct osd_state *osd = sd;
 
 	u32 addr = osd->osd_base + offset;
-	u32 val = readl(addr) & ~mask;
+	u32 val = readl(IOMEM(addr)) & ~mask;
 
-	writel(val, addr);
+	writel(val, IOMEM(addr));
 
 	return val;
 }
@@ -88,9 +88,9 @@ static inline u32 osd_modify(struct osd_state *sd, u32 mask, u32 val,
 	struct osd_state *osd = sd;
 
 	u32 addr = osd->osd_base + offset;
-	u32 new_val = (readl(addr) & ~mask) | (val & mask);
+	u32 new_val = (readl(IOMEM(addr)) & ~mask) | (val & mask);
 
-	writel(new_val, addr);
+	writel(new_val, IOMEM(addr));
 
 	return new_val;
 }
-- 
1.7.4.1

