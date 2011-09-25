Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab1IYHjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 03:39:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36496 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1IYHjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 03:39:04 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 2/4] staging: wlags49_h2: Stop playing with length in GIWESSID handler
Date: Sun, 25 Sep 2011 08:30:19 +0100
Message-Id: <1316935821-6980-3-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316935821-6980-1-git-send-email-kilroyd@googlemail.com>
References: <1316935821-6980-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WE21 clarified that ESSID should not be NULL terminated.
The existing code didn't NULL terminate, but did play with length
and then reset it again. Just stop it.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/wl_wext.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_wext.c b/drivers/staging/wlags49_h2/wl_wext.c
index 80bd938..1f6b4dc 100644
--- a/drivers/staging/wlags49_h2/wl_wext.c
+++ b/drivers/staging/wlags49_h2/wl_wext.c
@@ -1042,9 +1042,6 @@ static int wireless_get_essid(struct net_device *dev, struct iw_request_info *in
 		/* Copy the information into the user buffer */
 		data->length = pName->length;
 
-		/* NOTE: Null terminating is necessary for proper display of the SSID in
-		   the wireless tools */
-		data->length = pName->length + 1;
 		if( pName->length < HCF_MAX_NAME_LEN ) {
 			pName->name[pName->length] = '\0';
 		}
@@ -1070,11 +1067,7 @@ static int wireless_get_essid(struct net_device *dev, struct iw_request_info *in
 				pName->length = CNV_LITTLE_TO_INT( pName->length );
 
 				/* Copy the information into the user buffer */
-				data->length = pName->length + 1;
-				if( pName->length < HCF_MAX_NAME_LEN ) {
-					pName->name[pName->length] = '\0';
-				}
-
+				data->length = pName->length;
 				data->flags = 1;
 			} else {
 				ret = -EFAULT;
@@ -1084,8 +1077,6 @@ static int wireless_get_essid(struct net_device *dev, struct iw_request_info *in
 
 #endif // HCF_STA
 
-		data->length--;
-
 		if (pName->length > IW_ESSID_MAX_SIZE) {
 			ret = -EFAULT;
 			goto out_unlock;
-- 
1.7.4.1

