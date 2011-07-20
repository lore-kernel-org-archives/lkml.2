Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab1GTNfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:35:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:25229 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab1GTNfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:35:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,235,1309762800"; 
   d="scan'208";a="30208145"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] wireless: mwifiex: print hw address via %pM
Date: Wed, 20 Jul 2011 16:34:31 +0300
Message-Id: <8f12d3ad71585e863084560b227534a4b9e4af54.1311162926.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <fddeabc04a1b81a5c1f51a4164d93366dccf5f8e.1311162926.git.andriy.shevchenko@linux.intel.com>
References: <fddeabc04a1b81a5c1f51a4164d93366dccf5f8e.1311162926.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <fddeabc04a1b81a5c1f51a4164d93366dccf5f8e.1311162926.git.andriy.shevchenko@linux.intel.com>
References: <fddeabc04a1b81a5c1f51a4164d93366dccf5f8e.1311162926.git.andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/debugfs.c |   33 +++++++------------------------
 1 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 1bcf9ea..d26a78b 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -216,28 +216,19 @@ mwifiex_info_read(struct file *file, char __user *ubuf,
 	p += sprintf(p, "bss_mode=\"%s\"\n", bss_modes[info.bss_mode]);
 	p += sprintf(p, "media_state=\"%s\"\n",
 		     (!priv->media_connected ? "Disconnected" : "Connected"));
-	p += sprintf(p, "mac_address=\"%02x:%02x:%02x:%02x:%02x:%02x\"\n",
-		     netdev->dev_addr[0], netdev->dev_addr[1],
-		     netdev->dev_addr[2], netdev->dev_addr[3],
-		     netdev->dev_addr[4], netdev->dev_addr[5]);
+	p += sprintf(p, "mac_address=\"%pM\"\n", netdev->dev_addr);
 
 	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) {
 		p += sprintf(p, "multicast_count=\"%d\"\n",
 			     netdev_mc_count(netdev));
 		p += sprintf(p, "essid=\"%s\"\n", info.ssid.ssid);
-		p += sprintf(p, "bssid=\"%02x:%02x:%02x:%02x:%02x:%02x\"\n",
-			     info.bssid[0], info.bssid[1],
-			     info.bssid[2], info.bssid[3],
-			     info.bssid[4], info.bssid[5]);
+		p += sprintf(p, "bssid=\"%pM\"\n", info.bssid);
 		p += sprintf(p, "channel=\"%d\"\n", (int) info.bss_chan);
 		p += sprintf(p, "region_code = \"%02x\"\n", info.region_code);
 
 		netdev_for_each_mc_addr(ha, netdev)
-			p += sprintf(p, "multicast_address[%d]="
-				     "\"%02x:%02x:%02x:%02x:%02x:%02x\"\n", i++,
-				     ha->addr[0], ha->addr[1],
-				     ha->addr[2], ha->addr[3],
-				     ha->addr[4], ha->addr[5]);
+			p += sprintf(p, "multicast_address[%d]=\"%pM\"\n",
+					i++, ha->addr);
 	}
 
 	p += sprintf(p, "num_tx_bytes = %lu\n", priv->stats.tx_bytes);
@@ -451,26 +442,18 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 	if (info.tx_tbl_num) {
 		p += sprintf(p, "Tx BA stream table:\n");
 		for (i = 0; i < info.tx_tbl_num; i++)
-			p += sprintf(p, "tid = %d, "
-				     "ra = %02x:%02x:%02x:%02x:%02x:%02x\n",
-				     info.tx_tbl[i].tid, info.tx_tbl[i].ra[0],
-				     info.tx_tbl[i].ra[1], info.tx_tbl[i].ra[2],
-				     info.tx_tbl[i].ra[3], info.tx_tbl[i].ra[4],
-				     info.tx_tbl[i].ra[5]);
+			p += sprintf(p, "tid = %d, ra = %pM\n",
+				     info.tx_tbl[i].tid, info.tx_tbl[i].ra);
 	}
 
 	if (info.rx_tbl_num) {
 		p += sprintf(p, "Rx reorder table:\n");
 		for (i = 0; i < info.rx_tbl_num; i++) {
-
-			p += sprintf(p, "tid = %d, "
-				     "ta = %02x:%02x:%02x:%02x:%02x:%02x, "
+			p += sprintf(p, "tid = %d, ta = %pM, "
 				     "start_win = %d, "
 				     "win_size = %d, buffer: ",
 				     info.rx_tbl[i].tid,
-				     info.rx_tbl[i].ta[0], info.rx_tbl[i].ta[1],
-				     info.rx_tbl[i].ta[2], info.rx_tbl[i].ta[3],
-				     info.rx_tbl[i].ta[4], info.rx_tbl[i].ta[5],
+				     info.rx_tbl[i].ta,
 				     info.rx_tbl[i].start_win,
 				     info.rx_tbl[i].win_size);
 
-- 
1.7.5.4

