Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab1F2OX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:23:27 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:48348
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755935Ab1F2OWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 24/40] Staging: hv: storvsc: On I/O get the correct IDE device
Date: Wed, 29 Jun 2011 07:39:21 -0700
Message-Id: <1309358377-8537-24-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use the channel number to distinguish an IDE device managed by the
storvsc driver from scsi devices. Add code to get the correct
device pointer based on the channel number.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index cf659d7..fcc3f5d 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -517,6 +517,16 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	unsigned int sg_count = 0;
 	struct vmscsi_request *vm_srb;
 
+	if (scmnd->device->channel >= HV_IDE_BASE_CHANNEL) {
+		int channel = scmnd->device->channel;
+
+		/*
+		 * This is an IDE device; get the right dev.
+		 */
+
+		dev = ide_devices[channel - HV_IDE_BASE_CHANNEL];
+	}
+
 	/* If retrying, no need to prep the cmd */
 	if (scmnd->host_scribble) {
 
-- 
1.7.4.1

