Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1DFGi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 02:38:26 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.184]:59054
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861Ab1DFGiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 02:38:25 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Aisheng Dong <b29396@freescale.com>
To: <hjk@hansjkoch.de>, <greg@kroah.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 1/1] uio: clean uioinfo when uninstall uio driver
Date: Wed, 6 Apr 2011 14:42:40 +0800
Message-ID: <1302072160-6483-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Zhou <b30303@freescale.com>

The uioinfo should be cleaned up when uninstall, otherwise re-install
failure of uio_pdrv_genirq.ko will happen.

Signed-off-by: Jie Zhou <b30303@freescale.com>
Signed-off-by: Aisheng Dong <b29396@freescale.com>

---
Changes for v2:
 Address the comments from Hans:
   - The uioinfo->irq_flags and uioinfo->priv do not have to be cleaned
---
 drivers/uio/uio_pdrv_genirq.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 7174d51..0f424af 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -189,6 +189,10 @@ static int uio_pdrv_genirq_remove(struct platform_device *pdev)
 
 	uio_unregister_device(priv->uioinfo);
 	pm_runtime_disable(&pdev->dev);
+
+	priv->uioinfo->handler = NULL;
+	priv->uioinfo->irqcontrol = NULL;
+
 	kfree(priv);
 	return 0;
 }
-- 
1.7.0.4


