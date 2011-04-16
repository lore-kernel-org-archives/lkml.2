Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab1DPQvZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 12:51:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:50047 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab1DPQux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 12:50:53 -0400
Message-Id: <20110416165047.129643033@aepfle.de>
User-Agent: quilt/0.47-15.10
Date: Sat, 16 Apr 2011 18:50:41 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 3/5] hv: pass integer to tasklet_init()                                                                                                                                                               
References: <20110416165038.986214764@aepfle.de>
Content-Disposition: inline; filename=bug679942-tasklet_init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tasklet_init() takes an integer, so use one right away.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
compile tested

 drivers/staging/hv/vmbus_drv.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-next/drivers/staging/hv/vmbus_drv.c
===================================================================
--- linux-next.orig/drivers/staging/hv/vmbus_drv.c
+++ linux-next/drivers/staging/hv/vmbus_drv.c
@@ -578,10 +578,8 @@ static int vmbus_bus_init(struct pci_dev
 	hv_bus.bus.name = driver_name;
 
 	/* Initialize the bus context */
-	tasklet_init(&hv_bus.msg_dpc, vmbus_on_msg_dpc,
-		     (unsigned long)NULL);
-	tasklet_init(&hv_bus.event_dpc, vmbus_on_event,
-		     (unsigned long)NULL);
+	tasklet_init(&hv_bus.msg_dpc, vmbus_on_msg_dpc, 0);
+	tasklet_init(&hv_bus.event_dpc, vmbus_on_event, 0);
 
 	/* Now, register the bus  with LDM */
 	ret = bus_register(&hv_bus.bus);

