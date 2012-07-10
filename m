Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab2GJCrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:47:55 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37340 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab2GJCr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:47:28 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lauri.hintsala@bluegiga.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 1/5] staging: csr: Remove dead code
Date: Mon,  9 Jul 2012 23:43:09 -0300
Message-Id: <1341888193-12182-2-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341888193-12182-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341888193-12182-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All this code is dead, so remove it.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/csr/monitor.c      |   57 ------------------------------------
 drivers/staging/csr/unifi_native.h |   19 ------------
 2 files changed, 76 deletions(-)

diff --git a/drivers/staging/csr/monitor.c b/drivers/staging/csr/monitor.c
index 7648d2b..8c35b7e 100644
--- a/drivers/staging/csr/monitor.c
+++ b/drivers/staging/csr/monitor.c
@@ -51,13 +51,6 @@ uf_start_sniff(unifi_priv_t *priv)
     req->Channel = priv->wext_conf.channel;
     req->ChannelStartingFactor = 0;
 
-#if 0
-    printk("SniffJoin: Ifindex=%d, Channel=%d, ChannelStartingFactor=%d\n",
-           req->Ifindex,
-           req->Channel,
-           req->ChannelStartingFactor);
-#endif
-
     signal.SignalPrimitiveHeader.SignalId = CSR_MLME_SNIFFJOIN_REQUEST_ID;
 
     r = unifi_mlme_blocking_request(priv, pcli, &signal, NULL, timeout);
@@ -198,11 +191,6 @@ netrx_radiotap(unifi_priv_t *priv,
     unifi_rt->rt_antenna = ind->AntennaId;
 
 
-#if 0
-    printk("skb datalen=%d\n", skb->len);
-    dump(skb->data, 48);
-#endif
-
     skb->dev = dev;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
     skb->mac_header = skb->data;
@@ -282,24 +270,6 @@ netrx_prism(unifi_priv_t *priv,
         return;
     }
 
-#if 0
-    printk("MA-SINFFDATA.ind: DataLen=%d bytes, TSF %02X %02X %02X %02X %02X %02X %02X %02X, Rate=%d, Antenna=%d\n",
-           ind->Data.DataLength,
-           ind->Timestamp.x[0],
-           ind->Timestamp.x[1],
-           ind->Timestamp.x[2],
-           ind->Timestamp.x[3],
-           ind->Timestamp.x[4],
-           ind->Timestamp.x[5],
-           ind->Timestamp.x[6],
-           ind->Timestamp.x[7],
-           ind->Rate,
-           ind->Antenna);
-
-    printk("payload, len %d\n", length);
-    dump((unsigned char *)payload, 32);
-#endif
-
     /*
      * Allocate a SKB for the received data packet, including radiotap
      * header.
@@ -341,11 +311,6 @@ netrx_prism(unifi_priv_t *priv,
     avs->encoding       = htonl(0); /* unknown */
 
 
-#if 0
-    printk("skb datalen=%d\n", skb->len);
-    dump(skb->data, 48);
-#endif
-
     skb->dev = dev;
     skb->mac.raw = skb->data;
     skb->pkt_type = PACKET_OTHERHOST;
@@ -402,33 +367,11 @@ ma_sniffdata_ind(void *ospriv,
     }
 
     skb->len = bulkdata->d[0].data_length;
-#if 0
-    printk("MA-SNIFFDATA.ind: DataLen=%d bytes, TSF %02X %02X %02X %02X %02X %02X %02X %02X, Rate=%d, Antenna=%d\n",
-           ind->Data.DataLength,
-           ind->Timestamp.x[0],
-           ind->Timestamp.x[1],
-           ind->Timestamp.x[2],
-           ind->Timestamp.x[3],
-           ind->Timestamp.x[4],
-           ind->Timestamp.x[5],
-           ind->Timestamp.x[6],
-           ind->Timestamp.x[7],
-           ind->Rate,
-           ind->AntennaId);
-
-    printk("payload, len %lu\n", bulkdata->d[0].data_length);
-    if (bulkdata->d[0].os_data_ptr && (bulkdata->d[0].data_length >= 32)) {
-        dump((unsigned char *)bulkdata->d[0].os_data_ptr, 32);
-    }
-#endif
 
     /* We only process data packets if the interface is open */
     if (unlikely(!netif_running(dev))) {
         priv->stats.rx_dropped++;
         priv->wext_conf.wireless_stats.discard.misc++;
-#if 0
-        printk("Dropping packet while interface is not up.\n");
-#endif
         dev_kfree_skb(skb);
         return;
     }
diff --git a/drivers/staging/csr/unifi_native.h b/drivers/staging/csr/unifi_native.h
index a480c9e..a73b38e 100644
--- a/drivers/staging/csr/unifi_native.h
+++ b/drivers/staging/csr/unifi_native.h
@@ -242,25 +242,6 @@ void uf_native_process_udi_signal(ul_client_t *pcli,
                                   const u8 *packed_signal,
                                   int packed_signal_len,
                                   const bulk_data_param_t *bulkdata, int dir);
-#if 0
-/*
- * Choose one of these if available in linux/if_arp.h:
- *  #define UNIFI_SNIFF_ARPHRD ARPHRD_IEEE80211_RADIOTAP
- *  #define UNIFI_SNIFF_ARPHRD ARPHRD_IEEE80211_PRISM
- *
- * Radiotap is the newer standard for softmac WLAN devices, it works with
- * Wireshark but not Ethereal (due to a bug in the Ethereal dissector).
- * Prism is an older (less desirable) format but it does work with Ethereal.
- */
-#ifdef ARPHRD_IEEE80211_RADIOTAP
-#define UNIFI_SNIFF_ARPHRD ARPHRD_IEEE80211_RADIOTAP
-#else
-#ifdef ARPHRD_IEEE80211_PRISM
-#define UNIFI_SNIFF_ARPHRD ARPHRD_IEEE80211_PRISM
-#endif
-#endif
-#endif
-
 #ifdef UNIFI_SNIFF_ARPHRD
 /*
  * monitor.c
-- 
1.7.10.4

