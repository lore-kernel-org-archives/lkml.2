Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab2GICyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:54:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46209 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab2GICyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 22:54:15 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: andriy.shevchenko@linux.intel.com, jj@chaosbits.net,
        forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 1/6] staging: vt6655: Remove all "if 0" blocks from driver
Date: Sun,  8 Jul 2012 23:51:21 -0300
Message-Id: <1341802286-28281-2-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341802286-28281-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341802286-28281-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit removes code that will never be executed by vt6655 driver.

Was the forgotten-macros tool(https://github.com/marcosps/forgotten_macros)
who reported these blocks for us.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/vt6655/device_main.c |   33 --------------------------
 drivers/staging/vt6655/iwctl.c       |   36 -----------------------------
 drivers/staging/vt6655/rf.c          |   42 ----------------------------------
 drivers/staging/vt6655/wcmd.c        |   24 -------------------
 4 files changed, 135 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 3e8283c..d0fefb1 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1086,15 +1086,6 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
         device_free_info(pDevice);
         return -ENODEV;
     }
-//2008-07-21-01<Add>by MikeLiu
-//register wpadev
-#if 0
-   if(wpa_set_wpadev(pDevice, 1)!=0) {
-     printk("Fail to Register WPADEV?\n");
-        unregister_netdev(pDevice->dev);
-        free_netdev(dev);
-   }
-#endif
     device_print_info(pDevice);
     pci_set_drvdata(pcid, pDevice);
     return 0;
@@ -1948,15 +1939,6 @@ device_init_rd0_ring(pDevice);
 
 
 
-#if 0
-	pDevice->MLMEThr_pid = kernel_thread(MlmeThread, pDevice, CLONE_VM);
-	if (pDevice->MLMEThr_pid <0 )
-	{
-		printk("unable start thread MlmeThread\n");
-		return -1;
-	}
-#endif
-
 	//printk("thread id is %d\n",pDevice->MLMEThr_pid);
 	//printk("Create thread time is %x\n",jiffies);
 	//wait_for_completion(&pDevice->notify);
@@ -2493,21 +2475,6 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
                                 &(pDevice->byTopCCKBasicRate),
                                 &(pDevice->byTopOFDMBasicRate));
 
-#if 0
-printk("auto rate:Rate : %d,AckRate:%d,TopCCKRate:%d,TopOFDMRate:%d\n",
-pDevice->wCurrentRate,pDevice->byACKRate,
-pDevice->byTopCCKBasicRate,pDevice->byTopOFDMBasicRate);
-
-#endif
-
-#if 0
-
-	pDevice->wCurrentRate = 11;
-	pDevice->byACKRate = 8;
-	pDevice->byTopCCKBasicRate = 3;
-	pDevice->byTopOFDMBasicRate = 8;
-#endif
-
 
 		}
     }
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 87288db..77aad7f 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -84,24 +84,6 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 
 	pDevice->wstats.status = pDevice->eOPMode;
 	#ifdef Calcu_LinkQual
-	 #if 0
-	  if(pDevice->byBBType == BB_TYPE_11B) {
-	     if(pDevice->byCurrSQ > 120)
-                  pDevice->scStatistic.LinkQuality = 100;
-	     else
-		 pDevice->scStatistic.LinkQuality = pDevice->byCurrSQ*100/120;
-	    }
-	  else if(pDevice->byBBType == BB_TYPE_11G) {
-                if(pDevice->byCurrSQ < 20)
-		   pDevice->scStatistic.LinkQuality = 100;
-	       else if(pDevice->byCurrSQ >96)
-		   pDevice->scStatistic.LinkQuality  = 0;
-	       else
-		   pDevice->scStatistic.LinkQuality = (96-pDevice->byCurrSQ)*100/76;
-	   }
-	   if(pDevice->bLinkPass !=true)
-	       pDevice->scStatistic.LinkQuality = 0;
-	  #endif
 	   if(pDevice->scStatistic.LinkQuality > 100)
    	       pDevice->scStatistic.LinkQuality = 100;
                pDevice->wstats.qual.qual =(unsigned char) pDevice->scStatistic.LinkQuality;
@@ -2004,24 +1986,6 @@ param->u.wpa_key.key = (u8 *)key_array;
 param->u.wpa_key.seq = (u8 *)seq;
 param->u.wpa_key.seq_len = seq_len;
 
-#if 0
-printk("param->u.wpa_key.alg_name =%d\n",param->u.wpa_key.alg_name);
-printk(KERN_DEBUG "param->addr=%pM\n", param->addr);
-printk("param->u.wpa_key.set_tx =%d\n",param->u.wpa_key.set_tx);
-printk("param->u.wpa_key.key_index =%d\n",param->u.wpa_key.key_index);
-printk("param->u.wpa_key.key_len =%d\n",param->u.wpa_key.key_len);
-printk("param->u.wpa_key.key =");
-for(ii=0;ii<param->u.wpa_key.key_len;ii++)
-	printk("%02x:",param->u.wpa_key.key[ii]);
-         printk("\n");
-printk("param->u.wpa_key.seq_len =%d\n",param->u.wpa_key.seq_len);
-printk("param->u.wpa_key.seq =");
-for(ii=0;ii<param->u.wpa_key.seq_len;ii++)
-	printk("%02x:",param->u.wpa_key.seq[ii]);
-         printk("\n");
-
-printk("...........\n");
-#endif
 //****set if current action is Network Manager count??
 //****this method is so foolish,but there is no other way???
 if(param->u.wpa_key.alg_name == WPA_ALG_NONE) {
diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index b8ec783..a2db0ff 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -1067,48 +1067,6 @@ unsigned char byPwrdBm = 0;
 		break;
     }
 
-#if 0
-
-    // 802.11h TPC
-    if (pDevice->bLinkPass == true) {
-        // do not over local constraint
-        if (byPwrdBm > pDevice->abyLocalPwr[uCH]) {
-            pDevice->byCurPwrdBm = pDevice->abyLocalPwr[uCH];
-            byDec = byPwrdBm - pDevice->abyLocalPwr[uCH];
-            if (pDevice->byRFType == RF_UW2452) {
-                byDec *= 3;
-            } else {
-                byDec <<= 1;
-            }
-            if (byPwr > byDec) {
-                byPwr -= byDec;
-            } else {
-                byPwr = 0;
-            }
-        } else {
-            pDevice->byCurPwrdBm = byPwrdBm;
-        }
-    } else {
-        // do not over regulatory constraint
-        if (byPwrdBm > pDevice->abyRegPwr[uCH]) {
-            pDevice->byCurPwrdBm = pDevice->abyRegPwr[uCH];
-            byDec = byPwrdBm - pDevice->abyRegPwr[uCH];
-            if (pDevice->byRFType == RF_UW2452) {
-                byDec *= 3;
-            } else {
-                byDec <<= 1;
-            }
-            if (byPwr > byDec) {
-                byPwr -= byDec;
-            } else {
-                byPwr = 0;
-            }
-        } else {
-            pDevice->byCurPwrdBm = byPwrdBm;
-        }
-    }
-#endif
-
 //    if (pDevice->byLocalID <= REV_ID_VT3253_B1) {
     if (pDevice->byCurPwr == byPwr) {
         return true;
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index bab3b01..7b5b99c 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -684,18 +684,6 @@ printk("chester-abyDesireSSID=%s\n",((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->abySS
 	       return;
 	   }
 	          pDevice->byLinkWaitCount = 0;
-		 #if 0
-                     #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-                    // if(pDevice->bWPASuppWextEnabled == true)
-                        {
-                  	union iwreq_data  wrqu;
-                  	memset(&wrqu, 0, sizeof (wrqu));
-                          wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-                  	printk("wireless_send_event--->SIOCGIWAP(disassociated:AUTHENTICATE_WAIT_timeout)\n");
-                  	wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
-                       }
-                    #endif
-	         #endif
             s_bCommandComplete(pDevice);
             break;
 
@@ -748,18 +736,6 @@ printk("chester-abyDesireSSID=%s\n",((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->abySS
 	       return;
 	   }
 	          pDevice->byLinkWaitCount = 0;
-		#if 0
-                     #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-                    // if(pDevice->bWPASuppWextEnabled == true)
-                        {
-                  	union iwreq_data  wrqu;
-                  	memset(&wrqu, 0, sizeof (wrqu));
-                          wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-                  	printk("wireless_send_event--->SIOCGIWAP(disassociated:ASSOCIATE_WAIT_timeout)\n");
-                  	wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
-                       }
-                    #endif
-		#endif
 
             s_bCommandComplete(pDevice);
             break;
-- 
1.7.10.4

