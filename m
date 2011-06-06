Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab1FFWkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:40:18 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:58061
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758193Ab1FFWfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:35:02 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 34/49] Staging: hv: vmbus: Embed the state needed to close the channel
Date: Mon,  6 Jun 2011 15:49:58 -0700
Message-Id: <1307400613-13234-34-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, embed the state needed to close the channel - so we would not have to
allocate memory in the channel close path.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/hyperv.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hyperv.h b/drivers/staging/hv/hyperv.h
index 93bbeab..1747a24 100644
--- a/drivers/staging/hv/hyperv.h
+++ b/drivers/staging/hv/hyperv.h
@@ -569,6 +569,11 @@ struct vmbus_channel_msginfo {
 	unsigned char msg[0];
 };
 
+struct vmbus_close_msg {
+	struct vmbus_channel_msginfo info;
+	struct vmbus_channel_close_channel msg;
+};
+
 struct vmbus_channel {
 	struct list_head listentry;
 
@@ -601,6 +606,8 @@ struct vmbus_channel {
 	spinlock_t inbound_lock;
 	struct workqueue_struct *controlwq;
 
+	struct vmbus_close_msg close_msg;
+
 	/* Channel callback are invoked in this workqueue context */
 	/* HANDLE dataWorkQueue; */
 
-- 
1.7.4.1

