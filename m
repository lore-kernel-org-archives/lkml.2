Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab0K3VmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:42:14 -0500
Received: from mail.perches.com ([173.55.12.10]:2036 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab0K3VmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:42:13 -0500
From: Joe Perches <joe@perches.com>
To: Christian Lamparter <chunkeey@web.de>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: [PATCH 2/2] wireless: Remove unnecessary casts of usb_get_intfdata
Date: Tue, 30 Nov 2010 13:42:08 -0800
Message-Id: <cc6f3ee4ad9b301a00c0de89e7adcedda4d3674f.1291153099.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <ce546290dcd54062fa8cda575ab3d6e7d806c52f.1291153099.git.joe@perches.com>
References: <ce546290dcd54062fa8cda575ab3d6e7d806c52f.1291153099.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/ar9170/usb.c    |    6 ++----
 drivers/net/wireless/ath/ath9k/hif_usb.c |   13 +++++--------
 drivers/net/wireless/ath/carl9170/usb.c  |    3 +--
 drivers/net/wireless/p54/p54usb.c        |    2 +-
 drivers/net/wireless/zd1201.c            |    2 +-
 5 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index 5dbb536..d3be6f9 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -161,8 +161,7 @@ static void ar9170_usb_submit_urb(struct ar9170_usb *aru)
 static void ar9170_usb_tx_urb_complete_frame(struct urb *urb)
 {
 	struct sk_buff *skb = urb->context;
-	struct ar9170_usb *aru = (struct ar9170_usb *)
-	      usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
+	struct ar9170_usb *aru = usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
 
 	if (unlikely(!aru)) {
 		dev_kfree_skb_irq(skb);
@@ -219,8 +218,7 @@ free:
 static void ar9170_usb_rx_completed(struct urb *urb)
 {
 	struct sk_buff *skb = urb->context;
-	struct ar9170_usb *aru = (struct ar9170_usb *)
-		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
+	struct ar9170_usb *aru = usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
 	int err;
 
 	if (!aru)
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index ae842db..beb750e 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -471,7 +471,7 @@ err:
 static void ath9k_hif_usb_rx_cb(struct urb *urb)
 {
 	struct sk_buff *skb = (struct sk_buff *) urb->context;
-	struct hif_device_usb *hif_dev = (struct hif_device_usb *)
+	struct hif_device_usb *hif_dev =
 		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
 	int ret;
 
@@ -518,7 +518,7 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 {
 	struct sk_buff *skb = (struct sk_buff *) urb->context;
 	struct sk_buff *nskb;
-	struct hif_device_usb *hif_dev = (struct hif_device_usb *)
+	struct hif_device_usb *hif_dev =
 		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
 	int ret;
 
@@ -993,8 +993,7 @@ static void ath9k_hif_usb_reboot(struct usb_device *udev)
 static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
 {
 	struct usb_device *udev = interface_to_usbdev(interface);
-	struct hif_device_usb *hif_dev =
-		(struct hif_device_usb *) usb_get_intfdata(interface);
+	struct hif_device_usb *hif_dev = usb_get_intfdata(interface);
 
 	if (hif_dev) {
 		ath9k_htc_hw_deinit(hif_dev->htc_handle,
@@ -1016,8 +1015,7 @@ static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
 static int ath9k_hif_usb_suspend(struct usb_interface *interface,
 				 pm_message_t message)
 {
-	struct hif_device_usb *hif_dev =
-		(struct hif_device_usb *) usb_get_intfdata(interface);
+	struct hif_device_usb *hif_dev = usb_get_intfdata(interface);
 
 	ath9k_hif_usb_dealloc_urbs(hif_dev);
 
@@ -1026,8 +1024,7 @@ static int ath9k_hif_usb_suspend(struct usb_interface *interface,
 
 static int ath9k_hif_usb_resume(struct usb_interface *interface)
 {
-	struct hif_device_usb *hif_dev =
-		(struct hif_device_usb *) usb_get_intfdata(interface);
+	struct hif_device_usb *hif_dev = usb_get_intfdata(interface);
 	struct htc_target *htc_handle = hif_dev->htc_handle;
 	int ret;
 
diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index a268053..2d947a3 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -160,8 +160,7 @@ err_acc:
 
 static void carl9170_usb_tx_data_complete(struct urb *urb)
 {
-	struct ar9170 *ar = (struct ar9170 *)
-	      usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
+	struct ar9170 *ar = usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
 
 	if (WARN_ON_ONCE(!ar)) {
 		dev_kfree_skb_irq(urb->context);
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index d5bc21e..dd4d8fc 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -183,7 +183,7 @@ static void p54u_rx_cb(struct urb *urb)
 static void p54u_tx_cb(struct urb *urb)
 {
 	struct sk_buff *skb = urb->context;
-	struct ieee80211_hw *dev = (struct ieee80211_hw *)
+	struct ieee80211_hw *dev =
 		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
 
 	p54_free_skb(dev, skb);
diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
index b97aa9c..415eec4 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -1830,7 +1830,7 @@ err_zd:
 
 static void zd1201_disconnect(struct usb_interface *interface)
 {
-	struct zd1201 *zd=(struct zd1201 *)usb_get_intfdata(interface);
+	struct zd1201 *zd = usb_get_intfdata(interface);
 	struct hlist_node *node, *node2;
 	struct zd1201_frag *frag;
 
-- 
1.7.3.2.245.g03276.dirty

