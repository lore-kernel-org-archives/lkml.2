Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab2LFSnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 13:43:18 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:48306
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab2LFSnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 13:43:15 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: balloon: Fix a bug in the definition of struct dm_info_msg
Date: Thu,  6 Dec 2012 11:06:54 -0800
Message-Id: <1354820814-5631-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is bug in the definition of struct dm_info_msg. This patch fixes
the definition of this structure and makes the corresponding adjustments.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv_balloon.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 0ce08c4..00c8447 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -402,7 +402,7 @@ struct dm_info_header {
  */
 
 struct dm_info_msg {
-	struct dm_info_header header;
+	struct dm_header hdr;
 	__u32 reserved;
 	__u32 info_size;
 	__u8  info[];
@@ -502,13 +502,17 @@ static void hot_add_req(struct hv_dynmem_device *dm, struct dm_hot_add *msg)
 
 static void process_info(struct hv_dynmem_device *dm, struct dm_info_msg *msg)
 {
-	switch (msg->header.type) {
+	struct dm_info_header *info_hdr;
+
+	info_hdr = (struct dm_info_header *)msg->info;
+
+	switch (info_hdr->type) {
 	case INFO_TYPE_MAX_PAGE_CNT:
 		pr_info("Received INFO_TYPE_MAX_PAGE_CNT\n");
-		pr_info("Data Size is %d\n", msg->header.data_size);
+		pr_info("Data Size is %d\n", info_hdr->data_size);
 		break;
 	default:
-		pr_info("Received Unknown type: %d\n", msg->header.type);
+		pr_info("Received Unknown type: %d\n", info_hdr->type);
 	}
 }
 
-- 
1.7.4.1

