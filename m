Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934569Ab1ETAL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:11:28 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59903 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934039Ab1ETALY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:24 -0400
X-Sasl-enc: lUSetBsd+lnbjBAWm2TFgLik4Df9j/N8tHxMULah3GnU 1305850283
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jie Zhou <b30303@freescale.com>, Aisheng Dong <b29396@freescale.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/44] uio: clean uioinfo when uninstall uio driver
Date: Thu, 19 May 2011 17:10:29 -0700
Message-Id: <1305850262-9575-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Zhou <b30303@freescale.com>

The uioinfo should be cleaned up when uninstall, otherwise re-install
failure of uio_pdrv_genirq.ko will happen.

Signed-off-by: Jie Zhou <b30303@freescale.com>
Signed-off-by: Aisheng Dong <b29396@freescale.com>
Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.4.2

