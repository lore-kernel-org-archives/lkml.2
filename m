Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab0IMIk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:40:58 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49729 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab0IMIkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:40:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vKkJ3ZhvFNj5BIWeFuUbMUm/yOyqfcQnqaD+DyqUWhjABhWf7rBCAavvGSra9wrqZ4
         l9A566uCCFPMpgEHA20IGlT2kVmpQhFdE5hDEuqxBGoqJ+/QyHzyLjyeF08Kh2fRd8Ci
         ZfKoDUPlltiWkr4P9BAEmZWC+/C0t3ovHcrOA=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCHv2 02/10] staging: ath6kl: use '%pM' format to print MAC address
Date: Mon, 13 Sep 2010 11:40:26 +0300
Message-Id: <c25e54702c022f02a8a4d6061231aec9a4ff3cdf.1284316738.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
In-Reply-To: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |   10 +++-------
 drivers/staging/ath6kl/os/linux/cfg80211.c   |   20 +++++++-------------
 drivers/staging/ath6kl/wmi/wmi.c             |    8 +++-----
 3 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index ff7976e..64ba958 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -956,12 +956,10 @@ ar6000_softmac_update(AR_SOFTC_T *ar, A_UCHAR *eeprom_data, size_t size)
         ptr_mac = (A_UINT8 *)((A_UCHAR *)eeprom_data + AR6003_MAC_ADDRESS_OFFSET);
         break;
     default:
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Invalid Target Type \n"));
+	AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Invalid Target Type\n"));
         return;
     }
-    printk("MAC from EEPROM %02X:%02X:%02X:%02X:%02X:%02X\n", 
-            ptr_mac[0], ptr_mac[1], ptr_mac[2], 
-            ptr_mac[3], ptr_mac[4], ptr_mac[5]); 
+	printk(KERN_DEBUG "MAC from EEPROM %pM\n", ptr_mac);
 
     /* create a random MAC in case we cannot read file from system */
     ptr_mac[0] = 0;
@@ -990,9 +988,7 @@ ar6000_softmac_update(AR_SOFTC_T *ar, A_UCHAR *eeprom_data, size_t size)
         }
         A_RELEASE_FIRMWARE(softmac_entry);
     }
-    printk("MAC from %s %02X:%02X:%02X:%02X:%02X:%02X\n", source,
-            ptr_mac[0], ptr_mac[1], ptr_mac[2], 
-            ptr_mac[3], ptr_mac[4], ptr_mac[5]); 
+	printk(KERN_DEBUG "MAC from %s %pM\n", source, ptr_mac);
    calculate_crc(ar->arTargetType, eeprom_data);
 }
 #endif /* SOFTMAC_FILE_USED */
diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index 7a3784d..a8b9241 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -544,13 +544,10 @@ ar6k_cfg80211_connect_event(AR_SOFTC_T *ar, A_UINT16 channel,
 
         ibss_channel = ieee80211_get_channel(ar->wdev->wiphy, (int)channel);
 
-        AR_DEBUG_PRINTF(ATH_DEBUG_INFO,
-                        ("%s: inform bss with bssid %02x:%02x:%02x:%02x:%02x:%02x "\
-                         "channel %d beaconInterval %d capability 0x%x\n",
-                        __func__,
-                        mgmt->bssid[0], mgmt->bssid[1], mgmt->bssid[2],
-                        mgmt->bssid[3], mgmt->bssid[4], mgmt->bssid[5],
-                        ibss_channel->hw_value, beaconInterval, capability));
+	AR_DEBUG_PRINTF(ATH_DEBUG_INFO,
+		("%s: inform bss with bssid %pM channel %d beaconInterval %d "
+			"capability 0x%x\n", __func__, mgmt->bssid,
+			ibss_channel->hw_value, beaconInterval, capability));
 
         bss = cfg80211_inform_bss_frame(ar->wdev->wiphy,
                                         ibss_channel, mgmt,
@@ -715,12 +712,9 @@ ar6k_cfg80211_scan_node(void *arg, bss_t *ni)
     channel = ieee80211_get_channel(wiphy, freq);
     signal  = ni->ni_snr * 100;
 
-    AR_DEBUG_PRINTF(ATH_DEBUG_INFO,
-                    ("%s: bssid %02x:%02x:%02x:%02x:%02x:%02x channel %d freq %d size %d\n",
-                   __func__,
-                   mgmt->bssid[0], mgmt->bssid[1], mgmt->bssid[2],
-                   mgmt->bssid[3], mgmt->bssid[4], mgmt->bssid[5],
-                   channel->hw_value, freq, size));
+	AR_DEBUG_PRINTF(ATH_DEBUG_INFO,
+		("%s: bssid %pM channel %d freq %d size %d\n", __func__,
+			mgmt->bssid, channel->hw_value, freq, size));
     cfg80211_inform_bss_frame(wiphy, channel, mgmt,
                               le16_to_cpu(size),
                               signal, GFP_KERNEL);
diff --git a/drivers/staging/ath6kl/wmi/wmi.c b/drivers/staging/ath6kl/wmi/wmi.c
index d14bad2..7800778 100644
--- a/drivers/staging/ath6kl/wmi/wmi.c
+++ b/drivers/staging/ath6kl/wmi/wmi.c
@@ -1456,11 +1456,9 @@ wmi_bssInfo_event_rx(struct wmi_t *wmip, A_UINT8 *datap, int len)
     buf = datap + sizeof(WMI_BSS_INFO_HDR);
     len -= sizeof(WMI_BSS_INFO_HDR);
 
-    A_DPRINTF(DBG_WMI2, (DBGFMT "bssInfo event - ch %u, rssi %02x, "
-              "bssid \"%02x:%02x:%02x:%02x:%02x:%02x\"\n", DBGARG,
-              bih->channel, (unsigned char) bih->rssi, bih->bssid[0],
-              bih->bssid[1], bih->bssid[2], bih->bssid[3], bih->bssid[4],
-              bih->bssid[5]));
+	A_DPRINTF(DBG_WMI2, (DBGFMT "bssInfo event - ch %u, rssi %02x, "
+		"bssid \"%pM\"\n", DBGARG, bih->channel,
+		(unsigned char) bih->rssi, bih->bssid));
 
     if(wps_enable && (bih->frameType == PROBERESP_FTYPE) ) {
         wmi_node_return(wmip, bss);
-- 
1.7.2.2

