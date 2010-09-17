Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab0IQIZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:25:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63753 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0IQIZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:25:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gCNKScT0Do4IUvlIVbKumjXGisTXFZDx7v9upFduGleqA9geDRuq7V/v0k8d5Im1m3
         WCZmEG7JZc7anJEdumBspILD6lg2n19fwD/UTEU0+B5AcowuKxeDuIN1p14dun8ye8+j
         2SYZg0jr0azse19W7Y/qF5ps13l5Rgh2tbeSg=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 2/9] staging: ath6kl: '&pointer[0]' to 'pointer' fix
Date: Fri, 17 Sep 2010 11:24:44 +0300
Message-Id: <d7dfa375994251f9eb73274aa815ae9d84200ed7.1284711623.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <20100916225346.GA14448@kroah.com>
References: <20100916225346.GA14448@kroah.com>
In-Reply-To: <668ce39e9bd64e2a285367e2cc0963d678d1b501.1284711623.git.andy.shevchenko@gmail.com>
References: <668ce39e9bd64e2a285367e2cc0963d678d1b501.1284711623.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    4 ++--
 drivers/staging/ath6kl/os/linux/cfg80211.c   |    4 ++--
 drivers/staging/ath6kl/wmi/wmi.c             |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index c2947bc..c7922c9 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -959,7 +959,7 @@ ar6000_softmac_update(AR_SOFTC_T *ar, A_UCHAR *eeprom_data, size_t size)
 	AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Invalid Target Type\n"));
         return;
     }
-	printk(KERN_DEBUG "MAC from EEPROM %pM\n", &ptr_mac[0]);
+	printk(KERN_DEBUG "MAC from EEPROM %pM\n", ptr_mac);
 
     /* create a random MAC in case we cannot read file from system */
     ptr_mac[0] = 0;
@@ -988,7 +988,7 @@ ar6000_softmac_update(AR_SOFTC_T *ar, A_UCHAR *eeprom_data, size_t size)
         }
         A_RELEASE_FIRMWARE(softmac_entry);
     }
-	printk(KERN_DEBUG "MAC from %s %pM\n", source, &ptr_mac[0]);
+	printk(KERN_DEBUG "MAC from %s %pM\n", source, ptr_mac);
    calculate_crc(ar->arTargetType, eeprom_data);
 }
 #endif /* SOFTMAC_FILE_USED */
diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index d5890d4..a8b9241 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -546,7 +546,7 @@ ar6k_cfg80211_connect_event(AR_SOFTC_T *ar, A_UINT16 channel,
 
 	AR_DEBUG_PRINTF(ATH_DEBUG_INFO,
 		("%s: inform bss with bssid %pM channel %d beaconInterval %d "
-			"capability 0x%x\n", __func__, &mgmt->bssid[0],
+			"capability 0x%x\n", __func__, mgmt->bssid,
 			ibss_channel->hw_value, beaconInterval, capability));
 
         bss = cfg80211_inform_bss_frame(ar->wdev->wiphy,
@@ -714,7 +714,7 @@ ar6k_cfg80211_scan_node(void *arg, bss_t *ni)
 
 	AR_DEBUG_PRINTF(ATH_DEBUG_INFO,
 		("%s: bssid %pM channel %d freq %d size %d\n", __func__,
-			&mgmt->bssid[0], channel->hw_value, freq, size));
+			mgmt->bssid, channel->hw_value, freq, size));
     cfg80211_inform_bss_frame(wiphy, channel, mgmt,
                               le16_to_cpu(size),
                               signal, GFP_KERNEL);
diff --git a/drivers/staging/ath6kl/wmi/wmi.c b/drivers/staging/ath6kl/wmi/wmi.c
index 9811ce7..7800778 100644
--- a/drivers/staging/ath6kl/wmi/wmi.c
+++ b/drivers/staging/ath6kl/wmi/wmi.c
@@ -1458,7 +1458,7 @@ wmi_bssInfo_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
 
 	A_DPRINTF(DBG_WMI2, (DBGFMT "bssInfo event - ch %u, rssi %02x, "
 		"bssid \"%pM\"\n", DBGARG, bih->channel,
-		(unsigned char) bih->rssi, i&bih->bssid[0]));
+		(unsigned char) bih->rssi, bih->bssid));
 
     if(wps_enable && (bih->frameType == PROBERESP_FTYPE) ) {
         wmi_node_return(wmip, bss);
-- 
1.7.2.2

