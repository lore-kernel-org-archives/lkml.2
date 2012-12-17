Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab2LQNqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:46:36 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:59155 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752605Ab2LQNqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:46:35 -0500
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2012 08:46:34 EST
From: Sebastian Wankerl <sisewank@cip.cs.fau.de>
To: linux-kernel@i4.informatik.uni-erlangen.de
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Sebastian Wankerl 
	<sisewank@faui49man10.informatik.uni-erlangen.de>
Subject: [PATCH 1/3] wlan-ng/prism2mgmt.c: added parenthesis to macro
Date: Mon, 17 Dec 2012 14:38:01 +0100
Message-Id: <1355751483-7059-1-git-send-email-sisewank@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Wankerl <sisewank@faui49man10.informatik.uni-erlangen.de>

Signed-off-by: Sebastian Wankerl <sisewank@cip.cs.fau.de> 
Signed-off-by: Sebastian Ehrenfels <qi50dube@cip.cs.fau.de> 

---
 drivers/staging/wlan-ng/prism2mgmt.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
index 4efa9bc..62b94b0 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -415,11 +415,14 @@ int prism2mgmt_scan_results(wlandevice_t *wlandev, void *msgp)
 			break;
 
 #define REQBASICRATE(N) \
-	if ((count >= N) && DOT11_RATE5_ISBASIC_GET(item->supprates[(N)-1])) { \
-		req->basicrate ## N .data = item->supprates[(N)-1]; \
-		req->basicrate ## N .status = \
-			P80211ENUM_msgitem_status_data_ok; \
-	}
+	do { \
+		if ((count >= N) && DOT11_RATE5_ISBASIC_GET( \
+			item->supprates[(N)-1])) { \
+			req->basicrate ## N .data = item->supprates[(N)-1]; \
+			req->basicrate ## N .status = \
+				P80211ENUM_msgitem_status_data_ok; \
+		} \
+	} while (0)
 
 	REQBASICRATE(1);
 	REQBASICRATE(2);
@@ -431,11 +434,13 @@ int prism2mgmt_scan_results(wlandevice_t *wlandev, void *msgp)
 	REQBASICRATE(8);
 
 #define REQSUPPRATE(N) \
-	if (count >= N) { \
-		req->supprate ## N .data = item->supprates[(N)-1]; \
-		req->supprate ## N .status = \
-			P80211ENUM_msgitem_status_data_ok; \
-	}
+	do { \
+		if (count >= N) { \
+			req->supprate ## N .data = item->supprates[(N)-1]; \
+			req->supprate ## N .status = \
+				P80211ENUM_msgitem_status_data_ok; \
+		} \
+	} while (0)
 
 	REQSUPPRATE(1);
 	REQSUPPRATE(2);
-- 
1.7.10.4

