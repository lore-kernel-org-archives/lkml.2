Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534Ab0FEOMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 10:12:48 -0400
Received: from outbound-mail02.westnet.com.au ([203.10.1.243]:25121 "EHLO
	outbound-mail02.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933458Ab0FEOMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 10:12:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlJPAA74CUw6B9wNPGdsb2JhbACHb5ZlDAEBAQE1LbAXjTGFFwSDSA
X-IronPort-AV: E=Sophos;i="4.53,366,1272816000"; 
   d="scan'208";a="82293885"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <kernel.online@gilksonline.com>
Subject: [PATCH 06/13] fixed checkpatch.pl issues to line 300
Date: Sat,  5 Jun 2010 22:12:30 +0800
Message-Id: <1275747158-31375-7-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275747158-31375-6-git-send-email-mike.kernel@gilksonline.com>
References: <1275747158-31375-1-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-2-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-3-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-4-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-5-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-6-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Gilks <kernel.online@gilksonline.com>

---
 drivers/staging/rtl8192u/r8192U_core.c |   56 +++++++++++++-------------------
 1 files changed, 23 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 7bfbbfe..ac620a5 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -236,7 +236,7 @@ static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv *priv)
 				if (ChannelPlan[channel_plan].Channel[i] <
 					min_chan || ChannelPlan[channel_plan].
 							Channel[i] > max_chan)
-				break;
+					break;
 			GET_DOT11D_INFO(ieee)->channel_map[ChannelPlan
 						[channel_plan].Channel[i]] = 1;
 			}
@@ -268,7 +268,7 @@ static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv *priv)
 		_pdrvinfo->RxRate == DESC90_RATE2M ||\
 		_pdrvinfo->RxRate == DESC90_RATE5_5M ||\
 		_pdrvinfo->RxRate == DESC90_RATE11M) &&\
-		!_pdrvinfo->RxHT\
+		!_pdrvinfo->RxHT
 
 
 void CamResetAllEntry(struct net_device *dev)
@@ -285,8 +285,7 @@ void CamResetAllEntry(struct net_device *dev)
 	 */
 	/* debug
 	 *DbgPrint("========================================\n");
-	 *DbgPrint("                            Call ResetAllEntry"
-	 *		"                                              \n");
+	 *DbgPrint("                            Call ResetAllEntry\n");
 	 *DbgPrint("========================================\n\n");
 	 */
 	ulcommand |= BIT31|BIT30;
@@ -297,12 +296,12 @@ void CamResetAllEntry(struct net_device *dev)
 void write_cam(struct net_device *dev, u8 addr, u32 data)
 {
 	write_nic_dword(dev, WCAMI, data);
-	write_nic_dword(dev, RWCAM, BIT31|BIT16|(addr&0xff) );
+	write_nic_dword(dev, RWCAM, BIT31|BIT16|(addr&0xff));
 }
 
 u32 read_cam(struct net_device *dev, u8 addr)
 {
-	write_nic_dword(dev, RWCAM, 0x80000000|(addr&0xff) );
+	write_nic_dword(dev, RWCAM, 0x80000000|(addr&0xff));
 	return read_nic_dword(dev, 0xa8);
 }
 
@@ -316,8 +315,7 @@ void write_nic_byte_E(struct net_device *dev, int indx, u8 data)
 			       RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
 			       indx|0xfe00, 0, &data, 1, HZ / 2);
 
-	if (status < 0)
-	{
+	if (status < 0) {
 		printk("write_nic_byte_E TimeOut! status:%d\n", status);
 	}
 }
@@ -333,14 +331,14 @@ u8 read_nic_byte_E(struct net_device *dev, int indx)
 			       RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
 			       indx|0xfe00, 0, &data, 1, HZ / 2);
 
-	if (status < 0)
-	{
+	if (status < 0) {
 		printk("read_nic_byte_E TimeOut! status:%d\n", status);
 	}
 
 	return data;
 }
-//as 92U has extend page from 4 to 16, so modify functions below.
+
+/* as 92U has extend page from 4 to 16, so modify functions below. */
 void write_nic_byte(struct net_device *dev, int indx, u8 data)
 {
 	int status;
@@ -350,20 +348,18 @@ void write_nic_byte(struct net_device *dev, int indx, u8 data)
 
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 			       RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
-			       (indx&0xff)|0xff00, (indx>>8)&0x0f, &data, 1, HZ / 2);
+				       (indx&0xff)|0xff00, (indx>>8)&0x0f,
+							&data, 1, HZ / 2);
 
-	if (status < 0)
-	{
+	if (status < 0) {
 		printk("write_nic_byte TimeOut! status:%d\n", status);
 	}
 
 
 }
 
-
 void write_nic_word(struct net_device *dev, int indx, u16 data)
 {
-
 	int status;
 
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
@@ -371,34 +367,30 @@ void write_nic_word(struct net_device *dev, int indx, u16 data)
 
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 			       RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
-			       (indx&0xff)|0xff00, (indx>>8)&0x0f, &data, 2, HZ / 2);
+					(indx&0xff)|0xff00, (indx>>8)&0x0f,
+							&data, 2, HZ / 2);
 
-	if (status < 0)
-	{
+	if (status < 0) {
 		printk("write_nic_word TimeOut! status:%d\n", status);
 	}
 
 }
 
-
 void write_nic_dword(struct net_device *dev, int indx, u32 data)
 {
-
 	int status;
 
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 	struct usb_device *udev = priv->udev;
 
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
-			       RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
-			       (indx&0xff)|0xff00, (indx>>8)&0x0f, &data, 4, HZ / 2);
+				RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
+					(indx&0xff)|0xff00, (indx>>8)&0x0f,
+							&data, 4, HZ / 2);
 
-
-	if (status < 0)
-	{
+	if (status < 0) {
 		printk("write_nic_dword TimeOut! status:%d\n", status);
 	}
-
 }
 
 
@@ -411,19 +403,17 @@ u8 read_nic_byte(struct net_device *dev, int indx)
 	struct usb_device *udev = priv->udev;
 
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
-			       RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
-			       (indx&0xff)|0xff00, (indx>>8)&0x0f, &data, 1, HZ / 2);
+				RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
+					(indx&0xff)|0xff00, (indx>>8)&0x0f,
+							&data, 1, HZ / 2);
 
-	if (status < 0)
-	{
+	if (status < 0) {
 		printk("read_nic_byte TimeOut! status:%d\n", status);
 	}
 
 	return data;
 }
 
-
-
 u16 read_nic_word(struct net_device *dev, int indx)
 {
 	u16 data;
-- 
1.6.3.3

