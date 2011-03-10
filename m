Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1CJV4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:56:30 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:33080
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751601Ab1CJV4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:56:30 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 05/21] Staging: hv: Change the signature for vmbus_on_isr()
Date: Thu, 10 Mar 2011 14:06:06 -0800
Message-Id: <1299794766-1006-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of getting getting rid of the  hv_driver object from
vmbus_driver_context, change the signature for vmbus_on_isr.
Note that the argument to vmbus_on_isr() is not used.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 4b4483b..8e8a408 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -258,7 +258,7 @@ static void vmbus_on_msg_dpc(unsigned long data)
 /*
  * vmbus_on_isr - ISR routine
  */
-static int vmbus_on_isr(struct hv_driver *drv)
+static int vmbus_on_isr(void)
 {
 	int ret = 0;
 	int cpu = smp_processor_id();
@@ -989,8 +989,7 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 {
 	int ret;
 
-	/* Call to bus driver to handle interrupt */
-	ret = vmbus_on_isr(NULL);
+	ret = vmbus_on_isr();
 
 	/* Schedules a dpc if necessary */
 	if (ret > 0) {
-- 
1.5.5.6

