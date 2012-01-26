Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab2AZO4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:56:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64400 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab2AZO4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:56:34 -0500
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 2/7 v2] dma: shdma: prepare for simple DMA conversion
Date: Thu, 26 Jan 2012 15:56:19 +0100
Message-Id: <1327589784-4287-3-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:uwhtcbCGY2AO1CBJFucslRqPfdSxRY6VUIkiOPFqpBf
 x0aCqxP8GjQte5g/8F2R5kmp4Vwod7sq2PaZS0pC9c4Tjvmk/a
 E+eSGbBIhUfpJU8HiMvd+HoWYbdVwYVjLpJ+rgQ5DNHuqFE3dc
 jUkcVokJS2gfBptPO1CLay9IcWVuOW9PJz6VxHBsAHyRHtDMxC
 hhrZ5K6fIvWyoYzY3KQeCc9dbhfTLo6kisFPA2jbRfh7i9cbI9
 IIH3pxNI9DXb4PMQ7e28OYNkYBFslECta0q2K2JqIdxEsa2Tko
 4cRMHUueiOIewjy1wGeWzg62gVtbb4L/k6QKcHXuS9+tgqIGCJ
 4Al2XQE2Os/SU1rKmMk+Q6kXmdij08CC+4a0sA65KMebaL4zrW
 Iejfx7nohzRcA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By placing an anonymous union at the top of struct sh_dmae_slave we can
transparently prepare all drivers for the upcoming simple DMA conversion.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/linux/sh_dma.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
index 425450b..ed2aa1e 100644
--- a/include/linux/sh_dma.h
+++ b/include/linux/sh_dma.h
@@ -10,12 +10,16 @@
 #ifndef SH_DMA_H
 #define SH_DMA_H
 
-#include <linux/list.h>
+#include <linux/dma-simple.h>
 #include <linux/dmaengine.h>
+#include <linux/list.h>
 
 /* Used by slave DMA clients to request DMA to/from a specific peripheral */
 struct sh_dmae_slave {
-	unsigned int			slave_id; /* Set by the platform */
+	union {
+		unsigned int		slave_id; /* Set by the platform */
+		struct dma_simple_slave	simple_slave;
+	};
 	struct device			*dma_dev; /* Set by the platform */
 	const struct sh_dmae_slave_config	*config;  /* Set by the driver */
 };
-- 
1.7.2.5

