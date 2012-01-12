Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab2ALUf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:35:27 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:51442
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755350Ab2ALUfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:35:23 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 07/15] Staging: hv: storvsc: Add a comment to explain life-cycle management
Date: Thu, 12 Jan 2012 12:38:00 -0800
Message-Id: <1326400688-13544-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1326400688-13544-1-git-send-email-kys@microsoft.com>
References: <1326400637-13494-1-git-send-email-kys@microsoft.com>
 <1326400688-13544-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a comment to explain life-cycle management and fix format issue.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index e0e471c..204b3ca 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -375,6 +375,21 @@ done:
 	kfree(wrk);
 }
 
+/*
+ * We can get incoming messages from the host that are not in response to
+ * messages that we have sent out. An example of this would be messages
+ * received by the guest to notify dynamic addition/removal of LUNs. To
+ * deal with potential race conditions where the driver may be in the
+ * midst of being unloaded when we might receive an unsolicited message
+ * from the host, we have implemented a mechanism to gurantee sequential
+ * consistency:
+ *
+ * 1) Once the device is marked as being destroyed, we will fail all
+ *    outgoing messages.
+ * 2) We permit incoming messages when the device is being destroyed,
+ *    only to properly account for messages already sent out.
+ */
+
 static inline struct storvsc_device *get_out_stor_device(
 					struct hv_device *device)
 {
@@ -569,7 +584,7 @@ static void storvsc_on_io_completion(struct hv_device *device,
 	 */
 
 	if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
-		(stor_pkt->vm_srb.cdb[0] == MODE_SENSE)) {
+	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE)) {
 		vstor_packet->vm_srb.scsi_status = 0;
 		vstor_packet->vm_srb.srb_status = SRB_STATUS_SUCCESS;
 	}
-- 
1.7.4.1

