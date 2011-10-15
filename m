Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab1JOEIL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 00:08:11 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:46727
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750913Ab1JOEII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 00:08:08 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/2] Staging: hv: storvsc: Fix checkpatch warnings
Date: Fri, 14 Oct 2011 21:31:57 -0700
Message-Id: <1318653117-7154-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318653117-7154-1-git-send-email-kys@microsoft.com>
References: <1318653084-7115-1-git-send-email-kys@microsoft.com>
 <1318653117-7154-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warnings.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 1f9d23e..ae8c33e 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -522,8 +522,9 @@ static void storvsc_on_io_completion(struct hv_device *device,
 		if (vstor_packet->vm_srb.srb_status & 0x80) {
 			/* autosense data available */
 			dev_warn(&device->device,
-				 "storvsc pkt %p autosense data valid - len %d\n",
-				 request, vstor_packet->vm_srb.sense_info_length);
+				 "stor pkt %p autosense data valid - len %d\n",
+				 request,
+				 vstor_packet->vm_srb.sense_info_length);
 
 			memcpy(request->sense_buffer,
 			       vstor_packet->vm_srb.sense_data,
@@ -1128,13 +1129,13 @@ static bool storvsc_check_scsi_cmd(struct scsi_cmnd *scmnd)
 	u8 scsi_op = scmnd->cmnd[0];
 
 	switch (scsi_op) {
-		/* smartd sends this command, which will offline the device */
-		case SET_WINDOW:
-			scmnd->result = DID_ERROR << 16;
-			allowed = false;
-			break;
-		default:
-			break;
+	/* smartd sends this command, which will offline the device */
+	case SET_WINDOW:
+		scmnd->result = DID_ERROR << 16;
+		allowed = false;
+		break;
+	default:
+		break;
 	}
 	return allowed;
 }
-- 
1.7.4.1

