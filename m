Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2CHV05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:26:57 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53357 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab2CHV04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:26:56 -0500
From: Fabio Estevam <festevam@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, kernel@pengutronix.de,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] dma: imx-dma: Fix build by including <linux/module.h>
Date: Thu,  8 Mar 2012 18:26:45 -0300
Message-Id: <1331242005-15533-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 13ae246 (includecheck: delete any duplicate instances of module.) removed
a duplicated module.h inclusion from imx-dma.c.

,and commit 865d9438 (drivers/dma: linux/module.h included twice) did the same.

Let one linux/module.h be included so that it can be built again.

This fix the following error:

C      drivers/dma/imx-dma.o
drivers/dma/imx-dma.c:658: error: expected declaration specifiers or '...' before string constant
drivers/dma/imx-dma.c:658: warning: data definition has no type or storage class
drivers/dma/imx-dma.c:658: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/dma/imx-dma.c:658: warning: function declaration isn't a prototype
drivers/dma/imx-dma.c:659: error: expected declaration specifiers or '...' before string constant
drivers/dma/imx-dma.c:659: warning: data definition has no type or storage class
drivers/dma/imx-dma.c:659: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/dma/imx-dma.c:659: warning: function declaration isn't a prototype
drivers/dma/imx-dma.c:660: error: expected declaration specifiers or '...' before string constant
drivers/dma/imx-dma.c:660: warning: data definition has no type or storage class
drivers/dma/imx-dma.c:660: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/dma/imx-dma.c:660: warning: function declaration isn't a prototype

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/imx-dma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index ca78fca..7be8d1f 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/dmaengine.h>
+#include <linux/module.h>
 
 #include <asm/irq.h>
 #include <mach/dma-v1.h>
-- 
1.7.1

