Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab1IAV53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 17:57:29 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:50130
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932109Ab1IAV52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 17:57:28 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Sep 2011 17:57:28 EDT
From: Mike Sterling <mike.sterling@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Mike Sterling <mike.sterling@microsoft.com>
Subject: [PATCH 1/1] staging: hv: Add support for >2 TB LUN in storage driver.
Date: Thu,  1 Sep 2011 15:11:09 -0700
Message-Id: <1314915069-1796-1-git-send-email-mike.sterling@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a LUN larger than 2 TB is attached to a Linux VM on Hyper-V, we currently 
report a maximum size of 2 TB. This patch resolves the issue in hv_storvsc. 
Thanks to Robert Scheck <robert.scheck@etes.de> for reporting the issue.

Reported-by: Robert Scheck <robert.scheck@etes.de>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: K.Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hyperv_storage.h |    1 +
 drivers/staging/hv/storvsc_drv.c    |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hyperv_storage.h b/drivers/staging/hv/hyperv_storage.h
index a01f9a0..5af82f4 100644
--- a/drivers/staging/hv/hyperv_storage.h
+++ b/drivers/staging/hv/hyperv_storage.h
@@ -218,6 +218,7 @@ struct vstor_packet {
 #define STORVSC_MAX_LUNS_PER_TARGET			64
 #define STORVSC_MAX_TARGETS				1
 #define STORVSC_MAX_CHANNELS				1
+#define STORVSC_MAX_CMD_LEN				16
 
 struct hv_storvsc_request;
 
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 7effaf3..26983ac 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -701,6 +701,8 @@ static int storvsc_probe(struct hv_device *device)
 	host->max_id = STORVSC_MAX_TARGETS;
 	/* max # of channels */
 	host->max_channel = STORVSC_MAX_CHANNELS - 1;
+	/* max cmd length */
+	host->max_cmd_len = STORVSC_MAX_CMD_LEN;
 
 	/* Register the HBA and start the scsi bus scan */
 	ret = scsi_add_host(host, &device->device);
-- 
1.7.1

