Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850Ab0FCKil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:38:41 -0400
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:7659 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933486Ab0FCKik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:38:40 -0400
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jun 2010 06:38:40 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlNEAMogB0w6B9wNPGdsb2JhbACHa5Y9DAEBAQE1LbB7jXWFFgSDRg
X-IronPort-AV: E=Sophos;i="4.53,353,1272816000"; 
   d="scan'208";a="43338096"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH 7/7] staging: rtl8192u: fix checkpatch.pl issues to line 514
Date: Thu,  3 Jun 2010 18:29:23 +0800
Message-Id: <1275560963-13060-1-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <r8192U_core.c patch01>
References: <r8192U_core.c patch01>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed most problems pointed out by checkpatch.pl in file r8192U_core.c
up to line 500

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |   73 ++++++++++++-------------------
 1 files changed, 28 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index ae388f7..09f5747 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -413,14 +413,12 @@ u16 read_nic_word(struct net_device *dev, int indx)
 	struct usb_device *udev = priv->udev;
 
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
-			       RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
-			       (indx&0xff)|0xff00, (indx>>8)&0x0f, &data, 2, HZ / 2);
+				       RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
+				       (indx&0xff)|0xff00, (indx>>8)&0x0f,
+							&data, 2, HZ / 2);
 
 	if (status < 0)
-	{
 		printk("read_nic_word TimeOut! status:%d\n", status);
-	}
-
 
 	return data;
 }
@@ -434,13 +432,10 @@ u16 read_nic_word_E(struct net_device *dev, int indx)
 
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 			       RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
-			       indx|0xfe00, 0, &data, 2, HZ / 2);
+				       indx|0xfe00, 0, &data, 2, HZ / 2);
 
 	if (status < 0)
-	{
 		printk("read_nic_word TimeOut! status:%d\n", status);
-	}
-
 
 	return data;
 }
@@ -449,31 +444,29 @@ u32 read_nic_dword(struct net_device *dev, int indx)
 {
 	u32 data;
 	int status;
-//	int result;
+	/* int result; */
 
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 	struct usb_device *udev = priv->udev;
 
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
-			       RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
-			       (indx&0xff)|0xff00, (indx>>8)&0x0f, &data, 4, HZ / 2);
-//	if(0 != result) {
-//	  printk(KERN_WARNING "read size of data = %d\, date = %d\n", result, data);
-//	}
+				       RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
+					(indx&0xff)|0xff00, (indx>>8)&0x0f,
+							&data, 4, HZ / 2);
+	/* if(0 != result) {
+	 *	printk(KERN_WARNING "read size of data = %d\, date = %d\n",
+	 *							 result, data);
+	 * }
+	 */
 
 	if (status < 0)
-	{
 		printk("read_nic_dword TimeOut! status:%d\n", status);
-	}
-
-
 
 	return data;
 }
 
-
-//u8 read_phy_cck(struct net_device *dev, u8 adr);
-//u8 read_phy_ofdm(struct net_device *dev, u8 adr);
+/* u8 read_phy_cck(struct net_device *dev, u8 adr); */
+/* u8 read_phy_ofdm(struct net_device *dev, u8 adr); */
 /* this might still called in what was the PHY rtl8185/rtl8192 common code
  * plans are to possibilty turn it again in one common code...
  */
@@ -481,26 +474,22 @@ inline void force_pci_posting(struct net_device *dev)
 {
 }
 
-
 static struct net_device_stats *rtl8192_stats(struct net_device *dev);
 void rtl8192_commit(struct net_device *dev);
-//void rtl8192_restart(struct net_device *dev);
+/* void rtl8192_restart(struct net_device *dev); */
 void rtl8192_restart(struct work_struct *work);
-//void rtl8192_rq_tx_ack(struct work_struct *work);
-
+/* void rtl8192_rq_tx_ack(struct work_struct *work); */
 void watch_dog_timer_callback(unsigned long data);
 
 /****************************************************************************
-   -----------------------------PROCFS STUFF-------------------------
-*****************************************************************************/
-
-static struct proc_dir_entry *rtl8192_proc = NULL;
-
+ *   -----------------------------PROCFS STUFF-------------------------
+*****************************************************************************
+ */
 
+static struct proc_dir_entry *rtl8192_proc;
 
-static int proc_get_stats_ap(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+static int proc_get_stats_ap(char *page, char **start, off_t offset, int count,
+							int *eof, void *data)
 {
 	struct net_device *dev = data;
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
@@ -511,18 +500,12 @@ static int proc_get_stats_ap(char *page, char **start,
 
 	list_for_each_entry(target, &ieee->network_list, list) {
 
-		len += snprintf(page + len, count - len,
-		"%s ", target->ssid);
-
-		if(target->wpa_ie_len>0 || target->rsn_ie_len>0){
-			len += snprintf(page + len, count - len,
-			"WPA\n");
-		}
-		else{
-			len += snprintf(page + len, count - len,
-			"non_WPA\n");
-		}
+		len += snprintf(page + len, count - len, "%s ", target->ssid);
 
+		if (target->wpa_ie_len > 0 || target->rsn_ie_len > 0)
+			len += snprintf(page + len, count - len, "WPA\n");
+		else
+			len += snprintf(page + len, count - len, "non_WPA\n");
 	}
 
 	*eof = 1;
-- 
1.6.3.3

