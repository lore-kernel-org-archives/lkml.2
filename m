Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab2ELUlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 16:41:17 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:54184
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756320Ab2ELUlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 16:41:13 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/2] Drivers: hv: Get rid of an unnecessary check in vmbus_prep_negotiate_resp()
Date: Sat, 12 May 2012 13:44:57 -0700
Message-Id: <1336855498-3981-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1336855466-3942-1-git-send-email-kys@microsoft.com>
References: <1336855466-3942-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vmbus_prep_negotiate_resp() is only invoked when we are negotiating
the version; so the current check in vmbus_prep_negotiate_resp()
is unnecessary. Get rid of it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/channel_mgmt.c |   39 +++++++++++++++++++--------------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 9ffbfc5..6c8c4d3 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -56,30 +56,29 @@ struct vmbus_channel_message_table_entry {
 void vmbus_prep_negotiate_resp(struct icmsg_hdr *icmsghdrp,
 			       struct icmsg_negotiate *negop, u8 *buf)
 {
-	if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
-		icmsghdrp->icmsgsize = 0x10;
-
-		negop = (struct icmsg_negotiate *)&buf[
-			sizeof(struct vmbuspipe_hdr) +
-			sizeof(struct icmsg_hdr)];
-
-		if (negop->icframe_vercnt == 2 &&
-		   negop->icversion_data[1].major == 3) {
-			negop->icversion_data[0].major = 3;
-			negop->icversion_data[0].minor = 0;
-			negop->icversion_data[1].major = 3;
-			negop->icversion_data[1].minor = 0;
-		} else {
-			negop->icversion_data[0].major = 1;
-			negop->icversion_data[0].minor = 0;
-			negop->icversion_data[1].major = 1;
-			negop->icversion_data[1].minor = 0;
-		}
-
-		negop->icframe_vercnt = 1;
-		negop->icmsg_vercnt = 1;
+	icmsghdrp->icmsgsize = 0x10;
+
+	negop = (struct icmsg_negotiate *)&buf[
+		sizeof(struct vmbuspipe_hdr) +
+		sizeof(struct icmsg_hdr)];
+
+	if (negop->icframe_vercnt == 2 &&
+	   negop->icversion_data[1].major == 3) {
+		negop->icversion_data[0].major = 3;
+		negop->icversion_data[0].minor = 0;
+		negop->icversion_data[1].major = 3;
+		negop->icversion_data[1].minor = 0;
+	} else {
+		negop->icversion_data[0].major = 1;
+		negop->icversion_data[0].minor = 0;
+		negop->icversion_data[1].major = 1;
+		negop->icversion_data[1].minor = 0;
 	}
+
+	negop->icframe_vercnt = 1;
+	negop->icmsg_vercnt = 1;
 }
+
 EXPORT_SYMBOL_GPL(vmbus_prep_negotiate_resp);
 
 /*
-- 
1.7.4.1

