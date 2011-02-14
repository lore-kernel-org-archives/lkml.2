Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab1BNSeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:34:12 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42336
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751395Ab1BNSeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:34:11 -0500
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Feb 2011 13:34:11 EST
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, haiyangz@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        "K.Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH] Staging: hv: Use list_entry for msg_info and remove associated comment
Date: Mon, 14 Feb 2011 10:35:37 -0800
Message-Id: <1297708537-15981-1-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change code to use list_entry api. And removed comment
suggesting that change.

Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: K.Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel_mgmt.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index a9c9d49..6c497e9 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -580,8 +580,9 @@ static void vmbus_onopen_result(struct vmbus_channel_message_header *hdr)
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 
 	list_for_each(curr, &vmbus_connection.chn_msg_list) {
-/* FIXME: this should probably use list_entry() instead */
-		msginfo = (struct vmbus_channel_msginfo *)curr;
+		msginfo = list_entry(curr, struct vmbus_channel_msginfo,
+				msglistentry);
+
 		requestheader =
 			(struct vmbus_channel_message_header *)msginfo->msg;
 
@@ -628,8 +629,8 @@ static void vmbus_ongpadl_created(struct vmbus_channel_message_header *hdr)
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 
 	list_for_each(curr, &vmbus_connection.chn_msg_list) {
-/* FIXME: this should probably use list_entry() instead */
-		msginfo = (struct vmbus_channel_msginfo *)curr;
+		msginfo = list_entry(curr, struct vmbus_channel_msginfo,
+				msglistentry);
 		requestheader =
 			(struct vmbus_channel_message_header *)msginfo->msg;
 
@@ -676,8 +677,8 @@ static void vmbus_ongpadl_torndown(
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 
 	list_for_each(curr, &vmbus_connection.chn_msg_list) {
-/* FIXME: this should probably use list_entry() instead */
-		msginfo = (struct vmbus_channel_msginfo *)curr;
+		msginfo = list_entry(curr, struct vmbus_channel_msginfo,
+				msglistentry);
 		requestheader =
 			(struct vmbus_channel_message_header *)msginfo->msg;
 
@@ -718,8 +719,8 @@ static void vmbus_onversion_response(
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 
 	list_for_each(curr, &vmbus_connection.chn_msg_list) {
-/* FIXME: this should probably use list_entry() instead */
-		msginfo = (struct vmbus_channel_msginfo *)curr;
+		msginfo = list_entry(curr, struct vmbus_channel_msginfo,
+				msglistentry);
 		requestheader =
 			(struct vmbus_channel_message_header *)msginfo->msg;
 
-- 
1.6.0.2

