Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab2ARKX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:23:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58769 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352Ab2ARKWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:22:24 -0500
Date: Wed, 18 Jan 2012 11:22:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 2/7] dma: shdma: prepare for simple DMA conversion
In-Reply-To: <Pine.LNX.4.64.1201181025280.28782@axis700.grange>
Message-ID: <Pine.LNX.4.64.1201181112170.28782@axis700.grange>
References: <Pine.LNX.4.64.1201181025280.28782@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:6vyNWy4kELJyAxYOMQJ0/Iyf8wwedI4bDN65XULvqsI
 8ylbN/JDQFlJO3waobigNB8TZ80Hl/aqGMjWq3bAQ0RpRqMitP
 azYG3iLl2Xk/hBCxvbRFNS6SL2ixJA3fepb+Wx+EtMYICj53J+
 YiTKtoyJKrbghBgRgmNmHyjDzAa+n3xPkG7pjzPMBFrszGV5S9
 MDucyAQ4dnkH6JlKH0/wHjup7K8ANRTiYASPEJG8XvARizsmfb
 VkgGnJHmppmdkqXu4zzdMELT9CGEqzuFyIgTEljZjbZ6PlhUa+
 ixk+7C7Cp8HQ6DdUCSxdD4MBXE+jjIMYAYlyladyrCbBAu4teA
 fNWY7UDGsuEHWAkqN8kNGlR6PI6hEAjslWE61EXoMcZOEUAOmm
 6tQhGGGLwSdlw==
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
index db637b9..1b14cf4 100644
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

