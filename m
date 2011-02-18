Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab1BRUbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 15:31:41 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:55811
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751319Ab1BRUbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 15:31:39 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, haiyangz@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K.Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH] Staging: hv: Fixed FIXME comments by using list_for_each_entry
Date: Fri, 18 Feb 2011 12:39:57 -0800
Message-Id: <1298061597-22305-1-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed FIXME requests in channel_mgmt.c by using 
list_for_each_entry.

Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: K.Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/channel_mgmt.c |   24 ++++++++----------------
 1 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 325e0bc..0781c0e 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -567,7 +567,6 @@ static void vmbus_onoffers_delivered(
 static void vmbus_onopen_result(struct vmbus_channel_message_header *hdr)
 {
 	struct vmbus_channel_open_result *result;
-	struct list_head *curr;
 	struct vmbus_channel_msginfo *msginfo;
 	struct vmbus_channel_message_header *requestheader;
 	struct vmbus_channel_open_channel *openmsg;
@@ -581,9 +580,8 @@ static void vmbus_onopen_result(struct vmbus_channel_message_header *hdr)
 	 */
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 
-	list_for_each(curr, &vmbus_connection.chn_msg_list) {
-/* FIXME: this should probably use list_entry() instead */
-		msginfo = (struct vmbus_channel_msginfo *)curr;
+	list_for_each_entry(msginfo, &vmbus_connection.chn_msg_list,
+				msglistentry) {
 		requestheader =
 			(struct vmbus_channel_message_header *)msginfo->msg;
 
@@ -614,7 +612,6 @@ static void vmbus_onopen_result(struct vmbus_channel_message_header *hdr)
 static void vmbus_ongpadl_created(struct vmbus_channel_message_header *hdr)
 {
 	struct vmbus_channel_gpadl_created *gpadlcreated;
-	struct list_head *curr;
 	struct vmbus_channel_msginfo *msginfo;
 	struct vmbus_channel_message_header *requestheader;
 	struct vmbus_channel_gpadl_header *gpadlheader;
@@ -630,9 +627,8 @@ static void vmbus_ongpadl_created(struct vmbus_channel_message_header *hdr)
 	 */
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 
-	list_for_each(curr, &vmbus_connection.chn_msg_list) {
-/* FIXME: this should probably use list_entry() instead */
-		msginfo = (struct vmbus_channel_msginfo *)curr;
+	list_for_each_entry(msginfo, &vmbus_connection.chn_msg_list,
+				msglistentry) {
 		requestheader =
 			(struct vmbus_channel_message_header *)msginfo->msg;
 
@@ -666,7 +662,6 @@ static void vmbus_ongpadl_torndown(
 			struct vmbus_channel_message_header *hdr)
 {
 	struct vmbus_channel_gpadl_torndown *gpadl_torndown;
-	struct list_head *curr;
 	struct vmbus_channel_msginfo *msginfo;
 	struct vmbus_channel_message_header *requestheader;
 	struct vmbus_channel_gpadl_teardown *gpadl_teardown;
@@ -679,9 +674,8 @@ static void vmbus_ongpadl_torndown(
 	 */
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 
-	list_for_each(curr, &vmbus_connection.chn_msg_list) {
-/* FIXME: this should probably use list_entry() instead */
-		msginfo = (struct vmbus_channel_msginfo *)curr;
+	list_for_each_entry(msginfo, &vmbus_connection.chn_msg_list,
+				msglistentry) {
 		requestheader =
 			(struct vmbus_channel_message_header *)msginfo->msg;
 
@@ -712,7 +706,6 @@ static void vmbus_ongpadl_torndown(
 static void vmbus_onversion_response(
 		struct vmbus_channel_message_header *hdr)
 {
-	struct list_head *curr;
 	struct vmbus_channel_msginfo *msginfo;
 	struct vmbus_channel_message_header *requestheader;
 	struct vmbus_channel_initiate_contact *initiate;
@@ -722,9 +715,8 @@ static void vmbus_onversion_response(
 	version_response = (struct vmbus_channel_version_response *)hdr;
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 
-	list_for_each(curr, &vmbus_connection.chn_msg_list) {
-/* FIXME: this should probably use list_entry() instead */
-		msginfo = (struct vmbus_channel_msginfo *)curr;
+	list_for_each_entry(msginfo, &vmbus_connection.chn_msg_list,
+				msglistentry) {
 		requestheader =
 			(struct vmbus_channel_message_header *)msginfo->msg;
 
-- 
1.6.0.2

