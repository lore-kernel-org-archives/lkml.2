Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948Ab2EIPLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:11:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55056 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759750Ab2EIPJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:09:30 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [PATCH 2/9 v3] dma: shdma: prepare for conversion to the shdma base library
Date: Wed,  9 May 2012 17:09:14 +0200
Message-Id: <1336576161-27082-3-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:RWGfuc8ereYRdFMhEoElXPKElUNCG0PY9O+6EulUWU+
 UBwsQGinL4nklkgR/wBPZa4fIlwtlCdCUU7/9pR6C7DADizKcX
 vKIjB8Bp5PPCKpv9nwvY0yKTT6v9gEwlryYzkuwTf/utN2IT3h
 Ld1+SZcLxn9ISCDOa1HmGLyqx0hDkD9lU2v70CSiGGbQsvotWr
 2RG4PI1J5dVri9irazUpu0qJbuc5HusIuJCz5xBiFbRsd+g2t4
 p4iq1/AEE/T26/JIAOJlGgQDAm2Sjcv0TzvbKO9j+FiwcyjTgT
 VWJNvrO6428dID2VB6TSF8V996DT6zU7XhPatX+0Ya27GGHFHK
 hWkA7PDYCQeQ0cVN0YKPrGRXvQmeYLI3DZXH631alJ2bp8B6i0
 viLlYzodKCxng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By placing an anonymous union at the top of struct sh_dmae_slave we can
transparently prepare all device and client drivers for the upcoming
shdma-base conversion.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/linux/sh_dma.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
index 425450b..e081e8e 100644
--- a/include/linux/sh_dma.h
+++ b/include/linux/sh_dma.h
@@ -10,12 +10,16 @@
 #ifndef SH_DMA_H
 #define SH_DMA_H
 
-#include <linux/list.h>
 #include <linux/dmaengine.h>
+#include <linux/list.h>
+#include <linux/shdma-base.h>
 
 /* Used by slave DMA clients to request DMA to/from a specific peripheral */
 struct sh_dmae_slave {
-	unsigned int			slave_id; /* Set by the platform */
+	union {
+		unsigned int		slave_id; /* Set by the platform */
+		struct shdma_slave	shdma_slave;
+	};
 	struct device			*dma_dev; /* Set by the platform */
 	const struct sh_dmae_slave_config	*config;  /* Set by the driver */
 };
-- 
1.7.2.5

