Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab2GEK3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:29:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57307 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab2GEK3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:29:48 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7 v2] dmaengine: shdma: (cosmetic) simplify a static function
Date: Thu,  5 Jul 2012 12:29:37 +0200
Message-Id: <1341484183-10757-2-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:Hi7dh7V5hoTBZq1DkIUuqVpoEbO9p02vZm9eHa3YcKW
 wzmiC2C1GboRWd2sl1xoZl8aPOucoDYGj3f8O/85z6eWJ/dByP
 0AapffwmIB68/NsNh7esPY8UDnLActvP7TVMuIcfSWlkmYo7fO
 7veUeHhc9hLMDVUEil1bfjEUWaZ4ywYBzWMxQmguv26q2PRhKW
 +GMslvUThLCh5Gx9REniYuLGBsjb93jqUX+I7BdTmovRyXCsND
 Wpa6vNcY+Jt0t5OCutH1q7Ew3xvq/a36lEqmlxaecxGu6MGuRI
 SD/0JuROx/akOuUaO4JGw9+nOtGlT/lrm4k/Vx+KhCmP6/PcVf
 Un48sEQ2duAOT9AuOIeBQlKKq/GqPoLXvtJ02yteSDIrS495Fs
 Q1+3orAr/5qjQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmae_find_slave() needs only the slave_id field from the slave object, no
need to pass the pointer to the object, pass the slave_id directly.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/dma/sh/shdma.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
index c393b35..f06906f 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -304,18 +304,18 @@ static void sh_dmae_setup_xfer(struct shdma_chan *schan,
 }
 
 static const struct sh_dmae_slave_config *dmae_find_slave(
-	struct sh_dmae_chan *sh_chan, struct sh_dmae_slave *slave)
+	struct sh_dmae_chan *sh_chan, unsigned int slave_id)
 {
 	struct sh_dmae_device *shdev = to_sh_dev(sh_chan);
 	struct sh_dmae_pdata *pdata = shdev->pdata;
 	const struct sh_dmae_slave_config *cfg;
 	int i;
 
-	if (slave->shdma_slave.slave_id >= SH_DMA_SLAVE_NUMBER)
+	if (slave_id >= SH_DMA_SLAVE_NUMBER)
 		return NULL;
 
 	for (i = 0, cfg = pdata->slave; i < pdata->slave_num; i++, cfg++)
-		if (cfg->slave_id == slave->shdma_slave.slave_id)
+		if (cfg->slave_id == slave_id)
 			return cfg;
 
 	return NULL;
@@ -328,7 +328,7 @@ static int sh_dmae_set_slave(struct shdma_chan *schan,
 						    shdma_chan);
 	struct sh_dmae_slave *slave = container_of(sslave, struct sh_dmae_slave,
 						   shdma_slave);
-	const struct sh_dmae_slave_config *cfg = dmae_find_slave(sh_chan, slave);
+	const struct sh_dmae_slave_config *cfg = dmae_find_slave(sh_chan, sslave->slave_id);
 	if (!cfg)
 		return -ENODEV;
 
-- 
1.7.2.5

