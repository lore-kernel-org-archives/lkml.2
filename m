Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab2HPPIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:08:04 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39731
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754354Ab2HPPIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:08:00 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, jagrelo@cisco.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: Explicitly size elements of protocol structures
Date: Thu, 16 Aug 2012 08:23:20 -0700
Message-Id: <1345130600-2862-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use explicitly sized types in data structures defining the host/guest
protocol. I would like to thank Juan Sanchez-Agrelo  <jagrelo@cisco.com> 
for reporting this.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 include/linux/hyperv.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 588d8f2..e73b852 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -489,7 +489,7 @@ struct vmtransfer_page_range {
 struct vmtransfer_page_packet_header {
 	struct vmpacket_descriptor d;
 	u16 xfer_pageset_id;
-	bool sender_owns_set;
+	u8  sender_owns_set;
 	u8 reserved;
 	u32 range_cnt;
 	struct vmtransfer_page_range ranges[1];
@@ -643,7 +643,7 @@ struct vmbus_channel_query_vmbus_version {
 /* VMBus Version Supported parameters */
 struct vmbus_channel_version_supported {
 	struct vmbus_channel_message_header header;
-	bool version_supported;
+	u8 version_supported;
 } __packed;
 
 /* Offer Channel parameters */
@@ -652,7 +652,7 @@ struct vmbus_channel_offer_channel {
 	struct vmbus_channel_offer offer;
 	u32 child_relid;
 	u8 monitorid;
-	bool monitor_allocated;
+	u8 monitor_allocated;
 } __packed;
 
 /* Rescind Offer parameters */
@@ -788,7 +788,7 @@ struct vmbus_channel_initiate_contact {
 
 struct vmbus_channel_version_response {
 	struct vmbus_channel_message_header header;
-	bool version_supported;
+	u8 version_supported;
 } __packed;
 
 enum vmbus_channel_state {
-- 
1.7.4.1

