Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab1CVVI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 17:08:57 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:11027 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab1CVVIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 17:08:55 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmxtMZ80VwmRVV7cZ5
X-RZG-CLASS-ID: mo00
Date: Tue, 22 Mar 2011 22:08:50 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] hv: pass integer to tasklet_init()
Message-ID: <20110322210850.GC17724@aepfle.de>
References: <20110322210207.GA17724@aepfle.de>
 <20110322210627.GB17724@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110322210627.GB17724@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tasklet_init() takes an integer, so use one right away.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 drivers/staging/hv/vmbus_drv.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/staging/hv/vmbus_drv.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/vmbus_drv.c
+++ linux-2.6/drivers/staging/hv/vmbus_drv.c
@@ -454,10 +454,8 @@ static int vmbus_bus_init(void)
 	vmbus_drv_ctx->bus.name = driver_name;
 
 	/* Initialize the bus context */
-	tasklet_init(&vmbus_drv_ctx->msg_dpc, vmbus_on_msg_dpc,
-		     (unsigned long)NULL);
-	tasklet_init(&vmbus_drv_ctx->event_dpc, vmbus_on_event,
-		     (unsigned long)NULL);
+	tasklet_init(&vmbus_drv_ctx->msg_dpc, vmbus_on_msg_dpc, 0);
+	tasklet_init(&vmbus_drv_ctx->event_dpc, vmbus_on_event, 0);
 
 	/* Now, register the bus  with LDM */
 	ret = bus_register(&vmbus_drv_ctx->bus);
