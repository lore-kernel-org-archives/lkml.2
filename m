Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab0HBUPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:15:48 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37497 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab0HBUPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:15:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=yERnKhBAtWb8eBmpSI9vEpnjBxTk0JT2yL3dGORvQkd9KQrGhdZ+IAMCzPd6Qu6NI/
         WayS6evsWacU0EgphDUaEOBWqXU5DHkVgdBV6WMPi2e/eY50QDBsrCME6IqunBGwDglg
         /K1K7X6qFSRHshL/MB6wg7WDE9Wq+MZYJfT1k=
From: Edgardo Hames <ehames@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, ehames@gmail.com
Subject: [PATCH] Staging: wlan-ng: remove typedef in p80211hdr.h
Date: Mon,  2 Aug 2010 17:17:17 -0300
Message-Id: <1280780237-1982-1-git-send-email-ehames@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the only typedef in p80211hdr.h.

Signed-off-by: Edgardo Hames <ehames@gmail.com>
---
 drivers/staging/wlan-ng/cfg80211.c     |    2 +-
 drivers/staging/wlan-ng/p80211msg.h    |    4 ++--
 drivers/staging/wlan-ng/p80211netdev.h |    2 +-
 drivers/staging/wlan-ng/p80211req.c    |    6 +++---
 drivers/staging/wlan-ng/prism2fw.c     |    8 ++++----
 drivers/staging/wlan-ng/prism2sta.c    |    4 ++--
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index 53ca0ba..d32875a 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -311,7 +311,7 @@ int prism2_get_station(struct wiphy *wiphy, struct net_device *dev,
 	if (wlandev->mlmerequest == NULL)
 		return -EOPNOTSUPP;
 
-	result = wlandev->mlmerequest(wlandev, (p80211msg_t *) &quality);
+	result = wlandev->mlmerequest(wlandev, (struct p80211msg *) &quality);
 
 
 	if (result == 0) {
diff --git a/drivers/staging/wlan-ng/p80211msg.h b/drivers/staging/wlan-ng/p80211msg.h
index c691d3e..8e0f9a0 100644
--- a/drivers/staging/wlan-ng/p80211msg.h
+++ b/drivers/staging/wlan-ng/p80211msg.h
@@ -50,10 +50,10 @@
 
 #define WLAN_DEVNAMELEN_MAX	16
 
-typedef struct p80211msg {
+struct p80211msg {
 	u32 msgcode;
 	u32 msglen;
 	u8 devname[WLAN_DEVNAMELEN_MAX];
-} __attribute__ ((packed)) p80211msg_t;
+} __attribute__ ((packed));
 
 #endif /* _P80211MSG_H */
diff --git a/drivers/staging/wlan-ng/p80211netdev.h b/drivers/staging/wlan-ng/p80211netdev.h
index 3c72162..1ec3374 100644
--- a/drivers/staging/wlan-ng/p80211netdev.h
+++ b/drivers/staging/wlan-ng/p80211netdev.h
@@ -186,7 +186,7 @@ typedef struct wlandevice {
 	int (*txframe) (struct wlandevice *wlandev, struct sk_buff *skb,
 			union p80211_hdr *p80211_hdr,
 			struct p80211_metawep *p80211_wep);
-	int (*mlmerequest) (struct wlandevice *wlandev, p80211msg_t *msg);
+	int (*mlmerequest) (struct wlandevice *wlandev, struct p80211msg *msg);
 	int (*set_multicast_list) (struct wlandevice *wlandev,
 				   netdevice_t *dev);
 	void (*tx_timeout) (struct wlandevice *wlandev);
diff --git a/drivers/staging/wlan-ng/p80211req.c b/drivers/staging/wlan-ng/p80211req.c
index 83ae126..179194e 100644
--- a/drivers/staging/wlan-ng/p80211req.c
+++ b/drivers/staging/wlan-ng/p80211req.c
@@ -72,7 +72,7 @@
 #include "p80211metastruct.h"
 #include "p80211req.h"
 
-static void p80211req_handlemsg(wlandevice_t *wlandev, p80211msg_t *msg);
+static void p80211req_handlemsg(wlandevice_t *wlandev, struct p80211msg *msg);
 static int p80211req_mibset_mibget(wlandevice_t *wlandev,
 				   struct p80211msg_dot11req_mibget *mib_msg,
 				   int isget);
@@ -96,7 +96,7 @@ static int p80211req_mibset_mibget(wlandevice_t *wlandev,
 int p80211req_dorequest(wlandevice_t *wlandev, u8 *msgbuf)
 {
 	int result = 0;
-	p80211msg_t *msg = (p80211msg_t *) msgbuf;
+	struct p80211msg *msg = (struct p80211msg *) msgbuf;
 
 	/* Check to make sure the MSD is running */
 	if (!((wlandev->msdstate == WLAN_MSD_HWPRESENT &&
@@ -150,7 +150,7 @@ int p80211req_dorequest(wlandevice_t *wlandev, u8 *msgbuf)
 * Call context:
 *	Process thread
 ----------------------------------------------------------------*/
-static void p80211req_handlemsg(wlandevice_t *wlandev, p80211msg_t *msg)
+static void p80211req_handlemsg(wlandevice_t *wlandev, struct p80211msg *msg)
 {
 	switch (msg->msgcode) {
 
diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index 5b97c4a..fd5ddb2 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -983,7 +983,7 @@ int writeimage(wlandevice_t *wlandev, struct imgchunk *fchunk,
 	int result = 0;
 	struct p80211msg_p2req_ramdl_state rstatemsg;
 	struct p80211msg_p2req_ramdl_write rwritemsg;
-	p80211msg_t *msgp;
+	struct p80211msg *msgp;
 	u32 resultcode;
 	int i;
 	int j;
@@ -1029,7 +1029,7 @@ int writeimage(wlandevice_t *wlandev, struct imgchunk *fchunk,
 	rstatemsg.enable.data = P80211ENUM_truth_true;
 	rstatemsg.exeaddr.data = startaddr;
 
-	msgp = (p80211msg_t *) &rstatemsg;
+	msgp = (struct p80211msg *) &rstatemsg;
 	result = prism2mgmt_ramdl_state(wlandev, msgp);
 	if (result) {
 		printk(KERN_ERR
@@ -1070,7 +1070,7 @@ int writeimage(wlandevice_t *wlandev, struct imgchunk *fchunk,
 			    ("Sending xxxdl_write message addr=%06x len=%d.\n",
 			     currdaddr, currlen);
 
-			msgp = (p80211msg_t *) &rwritemsg;
+			msgp = (struct p80211msg *) &rwritemsg;
 			result = prism2mgmt_ramdl_write(wlandev, msgp);
 
 			/* Check the results */
@@ -1097,7 +1097,7 @@ int writeimage(wlandevice_t *wlandev, struct imgchunk *fchunk,
 	rstatemsg.enable.data = P80211ENUM_truth_false;
 	rstatemsg.exeaddr.data = 0;
 
-	msgp = (p80211msg_t *) &rstatemsg;
+	msgp = (struct p80211msg *) &rstatemsg;
 	result = prism2mgmt_ramdl_state(wlandev, msgp);
 	if (result) {
 		printk(KERN_ERR
diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index e5c5768..ed751f4 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -132,7 +132,7 @@ static void prism2sta_reset(wlandevice_t *wlandev);
 static int prism2sta_txframe(wlandevice_t *wlandev, struct sk_buff *skb,
 			     union p80211_hdr *p80211_hdr,
 			     struct p80211_metawep *p80211_wep);
-static int prism2sta_mlmerequest(wlandevice_t *wlandev, p80211msg_t *msg);
+static int prism2sta_mlmerequest(wlandevice_t *wlandev, struct p80211msg *msg);
 static int prism2sta_getcardinfo(wlandevice_t *wlandev);
 static int prism2sta_globalsetup(wlandevice_t *wlandev);
 static int prism2sta_setmulticast(wlandevice_t *wlandev, netdevice_t *dev);
@@ -309,7 +309,7 @@ static int prism2sta_txframe(wlandevice_t *wlandev, struct sk_buff *skb,
 * Call context:
 *	process thread
 ----------------------------------------------------------------*/
-static int prism2sta_mlmerequest(wlandevice_t *wlandev, p80211msg_t *msg)
+static int prism2sta_mlmerequest(wlandevice_t *wlandev, struct p80211msg *msg)
 {
 	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
 
-- 
1.7.0.4

