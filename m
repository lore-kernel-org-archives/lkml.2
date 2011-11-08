Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab1KHQhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:37:42 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:55522
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754415Ab1KHQg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:36:26 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 05/11] Staging: hv: storvsc: Use the accessor function shost_priv()
Date: Tue,  8 Nov 2011 09:01:44 -0800
Message-Id: <1320771710-29139-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1320771710-29139-1-git-send-email-kys@microsoft.com>
References: <1320771677-29095-1-git-send-email-kys@microsoft.com>
 <1320771710-29139-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the accessor function shost_priv().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index a145245..b21e85f 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -968,8 +968,7 @@ static int storvsc_remove(struct hv_device *dev)
 {
 	struct storvsc_device *stor_device = hv_get_drvdata(dev);
 	struct Scsi_Host *host = stor_device->host;
-	struct hv_host_device *host_dev =
-			(struct hv_host_device *)host->hostdata;
+	struct hv_host_device *host_dev = shost_priv(host);
 
 	scsi_remove_host(host);
 
@@ -1057,8 +1056,7 @@ static int storvsc_host_reset(struct hv_device *device)
  */
 static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 {
-	struct hv_host_device *host_dev =
-		(struct hv_host_device *)scmnd->device->host->hostdata;
+	struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
 	struct hv_device *dev = host_dev->dev;
 
 	return storvsc_host_reset(dev);
@@ -1073,8 +1071,7 @@ static void storvsc_command_completion(struct hv_storvsc_request *request)
 	struct storvsc_cmd_request *cmd_request =
 		(struct storvsc_cmd_request *)request->context;
 	struct scsi_cmnd *scmnd = cmd_request->cmd;
-	struct hv_host_device *host_dev =
-		(struct hv_host_device *)scmnd->device->host->hostdata;
+	struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
 	void (*scsi_done_fn)(struct scsi_cmnd *);
 	struct scsi_sense_hdr sense_hdr;
 	struct vmscsi_request *vm_srb;
@@ -1144,8 +1141,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 				void (*done)(struct scsi_cmnd *))
 {
 	int ret;
-	struct hv_host_device *host_dev =
-		(struct hv_host_device *)scmnd->device->host->hostdata;
+	struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
 	struct hv_device *dev = host_dev->dev;
 	struct hv_storvsc_request *request;
 	struct storvsc_cmd_request *cmd_request;
@@ -1359,7 +1355,7 @@ static int storvsc_probe(struct hv_device *device,
 	if (!host)
 		return -ENOMEM;
 
-	host_dev = (struct hv_host_device *)host->hostdata;
+	host_dev = shost_priv(host);
 	memset(host_dev, 0, sizeof(struct hv_host_device));
 
 	host_dev->port = host->host_no;
-- 
1.7.4.1

