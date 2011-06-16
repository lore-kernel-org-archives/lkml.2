Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab1FPUCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:02:21 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42382
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758488Ab1FPUB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:01:57 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 10/77] Staging: hv: storvsc: Use the newly introduced vmbus ID in storvsc driver
Date: Thu, 16 Jun 2011 13:16:43 -0700
Message-Id: <1308255470-3826-10-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308255470-3826-1-git-send-email-kys@microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup the newly introduced id_table for the storvsc driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 7effaf3..b71764d 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -646,6 +646,10 @@ static struct scsi_host_template scsi_driver = {
 	.dma_boundary =		PAGE_SIZE-1,
 };
 
+static const struct hv_vmbus_device_id id_table[] = {
+	{ "hv_scsi" },
+	{ "" }
+};
 
 /*
  * storvsc_probe - Add a new device for this driver
@@ -720,6 +724,7 @@ static int storvsc_probe(struct hv_device *device)
 /* The one and only one */
 
 static struct hv_driver storvsc_drv = {
+	.id_table = id_table,
 	.probe = storvsc_probe,
 	.remove = storvsc_remove,
 };
-- 
1.7.4.1

