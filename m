Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1IFWun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 18:50:43 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:34894
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753461Ab1IFWui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 18:50:38 -0400
From: Mike Sterling <mike.sterling@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Mike Sterling <mike.sterling@microsoft.com>
Subject: [PATCH 1/1] Staging: hv: Add support for >2 TB LUN in storage driver.
Date: Tue,  6 Sep 2011 16:10:55 -0700
Message-Id: <1315350655-17349-1-git-send-email-mike.sterling@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Sterling <mike.sterling@microsoft.com> 

If a LUN larger than 2 TB is attached to a Linux VM on Hyper-V, we currently
report a maximum size of 2 TB. This patch resolves the issue in hv_storvsc.
Thanks to Robert Scheck <robert.scheck@etes.de> for reporting the issue.

Reported-by: Robert Scheck <robert.scheck@etes.de>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: K.Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 3686d10..b0c4e56 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -232,6 +232,7 @@ struct vstor_packet {
 #define STORVSC_MAX_LUNS_PER_TARGET			64
 #define STORVSC_MAX_TARGETS				1
 #define STORVSC_MAX_CHANNELS				1
+#define STORVSC_MAX_CMD_LEN				16
 
 struct hv_storvsc_request;
 
@@ -1440,6 +1441,8 @@ static int storvsc_probe(struct hv_device *device)
 	host->max_id = STORVSC_MAX_TARGETS;
 	/* max # of channels */
 	host->max_channel = STORVSC_MAX_CHANNELS - 1;
+	/* max cmd length */
+	host->max_cmd_len = STORVSC_MAX_CMD_LEN;
 
 	/* Register the HBA and start the scsi bus scan */
 	ret = scsi_add_host(host, &device->device);
-- 
1.7.4.1

