Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2LRV4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:56:36 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:44022 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754569Ab2LRV4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:56:33 -0500
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 16:56:33 EST
From: Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de,
        Sebastian Wankerl 
	<sisewank@faui49man10.informatik.uni-erlangen.de>
Subject: [PATCH 1/3] wlan-ng/prism2mgmt.c: added parenthesis to macro
Date: Tue, 18 Dec 2012 22:47:14 +0100
Message-Id: <1355867234-1079-1-git-send-email-qi50dube@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20121217140004.GQ5083@mwanda>
References: <20121217140004.GQ5083@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Wankerl <sisewank@faui49man10.informatik.uni-erlangen.de>

Here the hopefully fixed version.

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
+		if (count >= N &&
+		    DOT11_RATE5_ISBASIC_GET(item->supprates[(N)-1])) { \
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
+	} \
+	} while (0)
 
 	REQSUPPRATE(1);
 	REQSUPPRATE(2);
-- 
1.7.10.4

