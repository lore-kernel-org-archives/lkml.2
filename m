Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab2JVJUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:20:22 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39053 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2JVJUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:20:21 -0400
MIME-Version: 1.0
Date: Mon, 22 Oct 2012 17:20:20 +0800
Message-ID: <CAPgLHd8spXSn7D6EppZEr2=8+7idUYa_+Qvb+mzmB3Hw2KWDdg@mail.gmail.com>
Subject: [PATCH] Drivers: hv: remove unused variable from channel_mgmt.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: kys@microsoft.com, haiyangz@microsoft.com
Cc: yongjun_wei@trendmicro.com.cn, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variables guidtype, guidinstance and initiate are initialized but
never used otherwise, so remove the unused variables.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/hv/channel_mgmt.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 2b8b8d4..2f84c5c 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -265,14 +265,9 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 {
 	struct vmbus_channel_offer_channel *offer;
 	struct vmbus_channel *newchannel;
-	uuid_le *guidtype;
-	uuid_le *guidinstance;
 
 	offer = (struct vmbus_channel_offer_channel *)hdr;
 
-	guidtype = &offer->offer.if_type;
-	guidinstance = &offer->offer.if_instance;
-
 	/* Allocate the channel object and save this offer. */
 	newchannel = alloc_channel();
 	if (!newchannel) {
@@ -470,7 +465,6 @@ static void vmbus_onversion_response(
 {
 	struct vmbus_channel_msginfo *msginfo;
 	struct vmbus_channel_message_header *requestheader;
-	struct vmbus_channel_initiate_contact *initiate;
 	struct vmbus_channel_version_response *version_response;
 	unsigned long flags;
 
@@ -484,8 +478,6 @@ static void vmbus_onversion_response(
 
 		if (requestheader->msgtype ==
 		    CHANNELMSG_INITIATE_CONTACT) {
-			initiate =
-			(struct vmbus_channel_initiate_contact *)requestheader;
 			memcpy(&msginfo->response.version_response,
 			      version_response,
 			      sizeof(struct vmbus_channel_version_response));


