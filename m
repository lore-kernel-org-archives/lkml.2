Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1EIV4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:56:52 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54275
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754987Ab1EIVou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:50 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 079/206] Staging: hv: Get rid of some unnecessary code in rndis_filter.c
Date: Mon,  9 May 2011 14:56:01 -0700
Message-Id: <1304978288-22999-79-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have gotten rid of the indirection; get rid
of some unnecessary code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/rndis_filter.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index f9c18fa..ee74cd1 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -606,19 +606,12 @@ int rndis_filter_init(struct netvsc_driver *drv)
 	rndisDriver->OnLinkStatusChanged = Driver->OnLinkStatusChanged;*/
 
 	/* Save the original dispatch handlers before we override it */
-	rndis_filter.inner_drv.base.dev_add = drv->base.dev_add;
-	rndis_filter.inner_drv.base.dev_rm =
-					drv->base.dev_rm;
-	rndis_filter.inner_drv.base.cleanup = drv->base.cleanup;
-
 	rndis_filter.inner_drv.send = drv->send;
 	rndis_filter.inner_drv.recv_cb = drv->recv_cb;
 	rndis_filter.inner_drv.link_status_change =
 					drv->link_status_change;
 
 	/* Override */
-	drv->base.dev_add = rndis_filte_device_add;
-	drv->base.dev_rm = rndis_filter_device_remove;
 	drv->send = rndis_filter_send;
 	drv->recv_cb = rndis_filter_receive;
 
-- 
1.7.4.1

