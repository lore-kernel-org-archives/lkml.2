Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab2FKSLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 14:11:11 -0400
Received: from smtp-out-208.synserver.de ([212.40.185.208]:1327 "EHLO
	smtp-out-199.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752068Ab2FKSLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 14:11:09 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31470
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Vinod Koul <vinod.koul@intel.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mika Westerberg <mika.westerberg@iki.fi>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 1/3] dmaengine: Add wrapper for device_tx_status callback
Date: Mon, 11 Jun 2012 20:11:40 +0200
Message-Id: <1339438302-12417-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a small inline wrapper for the devivce_tx_status callback of a
dma device. This makes the source code of users of this function a bit more
compact and a bit more legible.

E.g.:
-status = chan->device->device_tx_status(chan, cookie, &state)
+status = dmaengine_tx_status(chan, cookie, &state)

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
No changes since v1

---
 include/linux/dmaengine.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 56377df..cc0756a 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -670,6 +670,12 @@ static inline int dmaengine_resume(struct dma_chan *chan)
 	return dmaengine_device_control(chan, DMA_RESUME, 0);
 }
 
+static inline enum dma_status dmaengine_tx_status(struct dma_chan *chan,
+	dma_cookie_t cookie, struct dma_tx_state *state)
+{
+	return chan->device->device_tx_status(chan, cookie, state);
+}
+
 static inline dma_cookie_t dmaengine_submit(struct dma_async_tx_descriptor *desc)
 {
 	return desc->tx_submit(desc);
-- 
1.7.10

