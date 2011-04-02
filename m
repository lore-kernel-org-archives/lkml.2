Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab1DBIwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 04:52:11 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:53597
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754803Ab1DBIwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 04:52:09 -0400
X-SpamScore: 4
X-BigFish: VS4(zf6cizzz1202h1082kzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Aisheng Dong <b29396@freescale.com>
To: <hjk@hansjkoch.de>, <greg@kroah.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] uio: clean uioinfo when uninstall uio driver
Date: Sat, 2 Apr 2011 16:55:23 +0800
Message-ID: <1301734523-27933-1-git-send-email-b29396@freescale.com>
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
 drivers/uio/uio_pdrv_genirq.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 7174d51..e669a2c 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -189,6 +189,12 @@ static int uio_pdrv_genirq_remove(struct platform_device *pdev)
 
 	uio_unregister_device(priv->uioinfo);
 	pm_runtime_disable(&pdev->dev);
+
+	priv->uioinfo->irq_flags = 0;
+	priv->uioinfo->handler = NULL;
+	priv->uioinfo->irqcontrol = NULL;
+	priv->uioinfo->priv = NULL;
+
 	kfree(priv);
 	return 0;
 }
-- 
1.7.0.4


