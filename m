Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab2BXBjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 20:39:36 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60391 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2BXBjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 20:39:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of djpohly@gmail.com designates 10.229.77.66 as permitted sender) smtp.mail=djpohly@gmail.com; dkim=pass header.i=djpohly@gmail.com
From: "Devin J. Pohly" <djpohly@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, "Devin J. Pohly" <djpohly@gmail.com>
Subject: [PATCH 9/9] mei: reduce indentation in read_bus_message
Date: Thu, 23 Feb 2012 20:38:56 -0500
Message-Id: <1330047536-3827-10-git-send-email-djpohly@gmail.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
References: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Devin J. Pohly" <djpohly@gmail.com>

A chunk of code can be deindented by checking conditions early.

Signed-off-by: Devin J. Pohly <djpohly@gmail.com>
---
 drivers/staging/mei/interrupt.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index f2c864e..c2800ba 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -621,21 +621,7 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 	switch (*(u8 *) mei_msg) {
 	case HOST_START_RES_CMD:
 		version_res = (struct hbm_host_version_response *) mei_msg;
-		if (version_res->host_version_supported) {
-			dev->version.major_version = HBM_MAJOR_VERSION;
-			dev->version.minor_version = HBM_MINOR_VERSION;
-			if (dev->mei_state == MEI_INIT_CLIENTS &&
-					dev->init_clients_state ==
-					MEI_START_MESSAGE) {
-				dev->init_clients_timer = 0;
-				mei_host_enum_clients_message(dev);
-			} else {
-				dev->recvd_msg = false;
-				dev_dbg(&dev->pdev->dev, "IMEI reset due to received host start response bus message.\n");
-				mei_reset(dev, 1);
-				return;
-			}
-		} else {
+		if (!version_res->host_version_supported) {
 			dev->version = version_res->me_max_version;
 			/* send stop message */
 			mei_hdr->host_addr = 0;
@@ -657,6 +643,19 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 			return;
 		}
 
+		dev->version.major_version = HBM_MAJOR_VERSION;
+		dev->version.minor_version = HBM_MINOR_VERSION;
+		if (dev->mei_state != MEI_INIT_CLIENTS ||
+					dev->init_clients_state !=
+					MEI_START_MESSAGE) {
+			dev->recvd_msg = false;
+			dev_dbg(&dev->pdev->dev, "IMEI reset due to received host start response bus message.\n");
+			mei_reset(dev, 1);
+			return;
+		}
+		dev->init_clients_timer = 0;
+		mei_host_enum_clients_message(dev);
+
 		dev->recvd_msg = true;
 		dev_dbg(&dev->pdev->dev, "host start response message received.\n");
 		break;
-- 
1.7.9.2

