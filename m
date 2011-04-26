Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab1DZQMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:12:23 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:33025
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754258Ab1DZQIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:08:11 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 17/25] Staging: hv: Make event_dpc a global variable
Date: Tue, 26 Apr 2011 09:20:34 -0700
Message-Id: <1303834842-5022-17-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303834842-5022-1-git-send-email-kys@microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for getting rid of struct hv_bus, Make event_dpc a
global variable.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 028051d..a3a7741 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -43,11 +43,11 @@
 static struct pci_dev *hv_pci_dev;
 
 static struct tasklet_struct msg_dpc;
+static struct tasklet_struct event_dpc;
 
 /* Main vmbus driver data structure */
 struct hv_bus {
 	struct bus_type bus;
-	struct tasklet_struct event_dpc;
 };
 
 unsigned int vmbus_loglevel = (ALL_MODULES << 16 | INFO_LVL);
@@ -521,7 +521,7 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 			tasklet_schedule(&msg_dpc);
 
 		if (test_bit(1, (unsigned long *)&ret))
-			tasklet_schedule(&hv_bus.event_dpc);
+			tasklet_schedule(&event_dpc);
 
 		return IRQ_HANDLED;
 	} else {
@@ -554,7 +554,7 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 
 	/* Initialize the bus context */
 	tasklet_init(&msg_dpc, vmbus_on_msg_dpc, 0);
-	tasklet_init(&hv_bus.event_dpc, vmbus_on_event, 0);
+	tasklet_init(&event_dpc, vmbus_on_event, 0);
 
 	/* Now, register the bus  with LDM */
 	ret = bus_register(&hv_bus.bus);
-- 
1.7.4.1

