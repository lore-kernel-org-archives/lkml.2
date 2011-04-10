Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab1DJVcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 17:32:11 -0400
Received: from mail.perches.com ([173.55.12.10]:4624 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758025Ab1DJVbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 17:31:36 -0400
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging: Remove unnecessary semicolons when if (foo) {...};
Date: Sun, 10 Apr 2011 14:31:32 -0700
Message-Id: <f88eae25fbfdc7d29e6e96041342d570165e195c.1302470807.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1302470807.git.joe@perches.com>
References: <cover.1302470807.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done via perl script:

$ cat remove_semi_if.pl
my $match_balanced_parentheses = qr/(\((?:[^\(\)]++|(?-1))*\))/;
my $match_balanced_braces      = qr/(\{(?:[^\{\}]++|(?-1))*\})/;

foreach my $file (@ARGV) {
    my $f;
    my $text;
    my $oldtext;

    next if ((-d $file));

    open($f, '<', $file)
	or die "$P: Can't open $file for read\n";
    $oldtext = do { local($/) ; <$f> };
    close($f);

    next if ($oldtext eq "");

    $text = $oldtext;

    my $count = 0;
    do {
	$count = 0;
	$count += $text =~ s@\b(if\s*${match_balanced_parentheses}\s*)${match_balanced_braces}\s*;@"$1$3"@egx;
    } while ($count > 0);

    if ($text ne $oldtext) {
	my $newfile = $file;

	open($f, '>', $newfile)
	    or die "$P: Can't open $newfile for write\n";
	print $f $text;
	close($f);
    }
}

$

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/intel_sst/intel_sst_pvt.c |    2 +-
 drivers/staging/vt6655/bssdb.c            |    8 ++--
 drivers/staging/vt6655/device_main.c      |   14 ++++----
 drivers/staging/vt6655/dpc.c              |   10 +++---
 drivers/staging/vt6655/ioctl.c            |   38 ++++++++++++------------
 drivers/staging/vt6655/power.c            |    2 +-
 drivers/staging/vt6655/rxtx.c             |    4 +-
 drivers/staging/vt6655/wcmd.c             |   14 ++++----
 drivers/staging/vt6655/wmgr.c             |   44 ++++++++++++++--------------
 drivers/staging/vt6655/wpactl.c           |    4 +-
 drivers/staging/vt6656/bssdb.c            |    8 ++--
 drivers/staging/vt6656/dpc.c              |   10 +++---
 drivers/staging/vt6656/ioctl.c            |   38 ++++++++++++------------
 drivers/staging/vt6656/main_usb.c         |    4 +-
 drivers/staging/vt6656/rxtx.c             |    4 +-
 drivers/staging/vt6656/wcmd.c             |    8 ++--
 drivers/staging/vt6656/wmgr.c             |   46 ++++++++++++++--------------
 drivers/staging/vt6656/wpactl.c           |    4 +-
 18 files changed, 131 insertions(+), 131 deletions(-)

diff --git a/drivers/staging/intel_sst/intel_sst_pvt.c b/drivers/staging/intel_sst/intel_sst_pvt.c
index 01f8c3b..e034bea 100644
--- a/drivers/staging/intel_sst/intel_sst_pvt.c
+++ b/drivers/staging/intel_sst/intel_sst_pvt.c
@@ -203,7 +203,7 @@ int sst_create_large_msg(struct ipc_post **arg)
 		kfree(msg);
 		pr_err("kzalloc mailbox_data failed");
 		return -ENOMEM;
-	};
+	}
 	*arg = msg;
 	return 0;
 }
diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.c
index 57c1cc9..577599e 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -1289,7 +1289,7 @@ start:
              memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
              netif_rx(pDevice->skb);
              pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-         };
+         }
    #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
   // if(pDevice->bWPASuppWextEnabled == true)
       {
@@ -1489,7 +1489,7 @@ BSSvUpdateNodeTxCounter(
                     }
                 }
             }
-        };
+        }
 
         if ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) ||
             (pMgmt->eCurrMode == WMAC_MODE_ESS_AP)) {
@@ -1543,9 +1543,9 @@ BSSvUpdateNodeTxCounter(
                         }
                     }
                 }
-            };
+            }
         }
-    };
+    }
 
     return;
 
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index efaf19b..a946a69 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -900,7 +900,7 @@ static bool device_release_WPADEV(PSDevice pDevice)
 	        if(ii>20)
 		  break;
               }
-           };
+           }
     return true;
 }
 
@@ -1446,7 +1446,7 @@ static void device_init_defrag_cb(PSDevice pDevice) {
         if (!device_alloc_frag_buf(pDevice, pDeF)) {
             DBG_PRT(MSG_LEVEL_ERR,KERN_ERR "%s: can not alloc frag bufs\n",
                 pDevice->dev->name);
-        };
+        }
     }
     pDevice->cbDFCB = CB_MAX_RX_FRAG;
     pDevice->cbFreeDFCB = pDevice->cbDFCB;
@@ -2104,7 +2104,7 @@ static int device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev) {
         dev_kfree_skb_irq(skb);
         spin_unlock_irq(&pDevice->lock);
         return 0;
-    };
+    }
 
     cbMPDULen = skb->len;
     pbMPDU = skb->data;
@@ -2136,7 +2136,7 @@ bool device_dma0_xmit(PSDevice pDevice, struct sk_buff *skb, unsigned int uNodeI
     if (pDevice->bStopTx0Pkt == true) {
         dev_kfree_skb_irq(skb);
         return false;
-    };
+    }
 
     if (AVAIL_TD(pDevice, TYPE_TXDMA0) <= 0) {
         dev_kfree_skb_irq(skb);
@@ -2865,7 +2865,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
             pDevice->bBeaconSent = false;
             if (pDevice->bEnablePSMode) {
                 PSbIsNextTBTTWakeUp((void *)pDevice);
-            };
+            }
 
             if ((pDevice->eOPMode == OP_MODE_AP) ||
                 (pDevice->eOPMode == OP_MODE_ADHOC)) {
@@ -2876,7 +2876,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 
             if (pDevice->eOPMode == OP_MODE_ADHOC && pDevice->pMgmt->wCurrATIMWindow > 0) {
                 // todo adhoc PS mode
-            };
+            }
 
         }
 
@@ -2885,7 +2885,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
             if (pDevice->eOPMode == OP_MODE_ADHOC) {
                 pDevice->bIsBeaconBufReadySet = false;
                 pDevice->cbBeaconBufReadySetCnt = 0;
-            };
+            }
 
             if (pDevice->eOPMode == OP_MODE_AP) {
                 if(pMgmt->byDTIMCount > 0) {
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 1513073..cf0deac 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -700,7 +700,7 @@ device_receive_frame (
                 pDevice->pMgmt->bInTIMWake = false;
             }
         }
-    };
+    }
 
     // Now it only supports 802.11g Infrastructure Mode, and support rate must up to 54 Mbps
     if (pDevice->bDiversityEnable && (FrameSize>50) &&
@@ -884,7 +884,7 @@ device_receive_frame (
                      memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
                      netif_rx(pDevice->skb);
                      pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-                 };
+                 }
 
                 return false;
 
@@ -1049,7 +1049,7 @@ static bool s_bAPModeRxCtl (
                                          );
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: send vMgrDeAuthenBeginSta 1\n");
                     return true;
-                };
+                }
                 if (pMgmt->sNodeDBTable[iSANodeIndex].eNodeState < NODE_ASSOC) {
                     // send deassoc notification
                     // reason = (7) class 3 received from nonassoc sta
@@ -1061,7 +1061,7 @@ static bool s_bAPModeRxCtl (
                                          );
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: send vMgrDisassocBeginSta 2\n");
                     return true;
-                };
+                }
 
                 if (pMgmt->sNodeDBTable[iSANodeIndex].bPSEnable) {
                     // delcare received ps-poll event
@@ -1486,7 +1486,7 @@ static bool s_bAPModeRxData (
                     bRelayOnly = true;
                 }
             }
-        };
+        }
     }
 
     if (bRelayOnly || bRelayAndForward) {
diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index 5624a41..a74833d 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -91,7 +91,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sScanCmd, pReq->data, sizeof(SCmdScan))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 
         pItemSSID = (PWLAN_IE_SSID)sScanCmd.ssid;
         if (pItemSSID->len != 0) {
@@ -128,7 +128,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sZoneTypeCmd, pReq->data, sizeof(SCmdZoneTypeSet))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 
           if(sZoneTypeCmd.bWrite==true) {
 	  //////write zonetype
@@ -167,7 +167,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 	   if (copy_to_user(pReq->data, &sZoneTypeCmd, sizeof(SCmdZoneTypeSet))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 	}
 
 	     break;
@@ -186,7 +186,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sJoinCmd, pReq->data, sizeof(SCmdBSSJoin))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 
         pItemSSID = (PWLAN_IE_SSID)sJoinCmd.ssid;
         memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
@@ -234,7 +234,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sWEPCmd, pReq->data, sizeof(SCmdSetWEP))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 	    if (sWEPCmd.bEnableWep != true) {
             pDevice->bEncryptionEnable = false;
             pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
@@ -300,7 +300,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_to_user(pReq->data, &sLinkStatus, sizeof(SCmdLinkStatus))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 
         break;
 
@@ -317,7 +317,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_to_user(pReq->data, &sList, sizeof(SBSSIDList))) {
 			result = -EFAULT;
 			break;
-		};
+		}
         pReq->wResult = 0;
         break;
 
@@ -325,7 +325,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sList, pReq->data, sizeof(SBSSIDList))) {
 			result = -EFAULT;
 			break;
-		};
+		}
         pList = (PSBSSIDList)kmalloc(sizeof(SBSSIDList) + (sList.uItem * sizeof(SBSSIDItem)), (int)GFP_ATOMIC);
         if (pList == NULL) {
             result = -ENOMEM;
@@ -367,7 +367,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_to_user(pReq->data, pList, sizeof(SBSSIDList) + (sList.uItem * sizeof(SBSSIDItem)))) {
 			result = -EFAULT;
 			break;
-		};
+		}
         kfree(pList);
         pReq->wResult = 0;
         break;
@@ -376,14 +376,14 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_to_user(pReq->data, &(pDevice->s802_11Counter), sizeof(SDot11MIBCount))) {
 			result = -EFAULT;
 			break;
-		};
+		}
         break;
 
     case WLAN_CMD_GET_STAT:
         if (copy_to_user(pReq->data, &(pDevice->scStatistic), sizeof(SStatCounter))) {
 			result = -EFAULT;
 			break;
-		};
+		}
         break;
     case WLAN_CMD_STOP_MAC:
 
@@ -427,7 +427,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sValue, pReq->data, sizeof(SCmdValue))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 		if (sValue.dwValue == 1) {
             if (vt6655_hostap_set_hostapd(pDevice, 1, 1) == 0){
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable HOSTAP\n");
@@ -455,7 +455,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sValue, pReq->data, sizeof(SCmdValue))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 
 		if (sValue.dwValue == 1) {
             pDevice->bEnable8021x = true;
@@ -475,7 +475,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sValue, pReq->data, sizeof(SCmdValue))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 
 		if (sValue.dwValue == 1) {
             pDevice->bEnableHostWEP = true;
@@ -494,7 +494,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sValue, pReq->data, sizeof(SCmdValue))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 		if (sValue.dwValue == 1) {
                      DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "up wpadev\n");
 		   memcpy(pDevice->wpadev->dev_addr, pDevice->dev->dev_addr, ETH_ALEN);
@@ -519,7 +519,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sStartAPCmd, pReq->data, sizeof(SCmdStartAP))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 
 	    if (sStartAPCmd.wBSSType == AP) {
 	        pMgmt->eConfigMode = WMAC_CONFIG_AP;
@@ -612,7 +612,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_to_user(pReq->data, &sNodeList, sizeof(SNodeList))) {
 			result = -EFAULT;
 			break;
-		};
+		}
         pReq->wResult = 0;
         break;
 
@@ -621,7 +621,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sNodeList, pReq->data, sizeof(SNodeList))) {
 			result = -EFAULT;
 			break;
-		};
+		}
         pNodeList = (PSNodeList)kmalloc(sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)), (int)GFP_ATOMIC);
         if (pNodeList == NULL) {
             result = -ENOMEM;
@@ -661,7 +661,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_to_user(pReq->data, pNodeList, sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)))) {
 			result = -EFAULT;
 			break;
-		};
+		}
         kfree(pNodeList);
         pReq->wResult = 0;
         break;
diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index 7207aca..4c0b02e 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -221,7 +221,7 @@ PSbConsiderPowerDown(
         ((pDevice->dwIsr& ISR_RXDMA0) != 0) &&
         ((pDevice->dwIsr & ISR_RXDMA1) != 0)){
         return false;
-    };
+    }
 
     if (pMgmt->eCurrMode != WMAC_MODE_IBSS_STA) {
         if (bCheckCountToWakeUp &&
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index c920cf6..6935b37 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -2902,13 +2902,13 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
         if (pDevice->bEnableHostWEP) {
             uNodeIndex = 0;
             bNodeExist = true;
-        };
+        }
     }
     else {
         if (pDevice->bEnableHostWEP) {
             if (BSSDBbIsSTAInNodeDB(pDevice->pMgmt, (unsigned char *)(p80211Header->sA3.abyAddr1), &uNodeIndex))
                 bNodeExist = true;
-        };
+        }
         bNeedACK = true;
         pTxBufHead->wFIFOCtl |= FIFOCTL_NEEDACK;
     };
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index abd6745..24f1490 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -385,7 +385,7 @@ vCommandTimer (
                 spin_unlock_irq(&pDevice->lock);
                 vCommandTimerWait((void *)pDevice, 10);
                 return;
-            };
+            }
 
             if (pMgmt->uScanChannel == 0 ) {
                 pMgmt->uScanChannel = pDevice->byMinChannel;
@@ -519,7 +519,7 @@ vCommandTimer (
                 vCommandTimerWait((void *)pDevice, 10);
                 spin_unlock_irq(&pDevice->lock);
                 return;
-            };
+            }
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" CARDbRadioPowerOff\n");
 	//2008-09-02  <mark>	by chester
            // CARDbRadioPowerOff(pDevice);
@@ -532,7 +532,7 @@ vCommandTimer (
                 vCommandTimerWait((void *)pDevice, 10);
                 spin_unlock_irq(&pDevice->lock);
                 return;
-            };
+            }
 //2008-09-02  <mark> by chester
            // CARDbRadioPowerOff(pDevice);
             s_bCommandComplete(pDevice);
@@ -619,7 +619,7 @@ printk("chester-abyDesireSSID=%s\n",((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->abySS
                     vMgrCreateOwnIBSS((void *)pDevice, &Status);
                     if (Status != CMD_STATUS_SUCCESS){
                         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " WLAN_CMD_IBSS_CREATE fail ! \n");
-                    };
+                    }
                     BSSvAddMulticastNode(pDevice);
                 }
             }
@@ -631,7 +631,7 @@ printk("chester-abyDesireSSID=%s\n",((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->abySS
                     vMgrCreateOwnIBSS((void *)pDevice, &Status);
                     if (Status != CMD_STATUS_SUCCESS){
                         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" WLAN_CMD_IBSS_CREATE fail ! \n");
-                    };
+                    }
                     BSSvAddMulticastNode(pDevice);
                     if (netif_queue_stopped(pDevice->dev)){
                         netif_wake_queue(pDevice->dev);
@@ -783,7 +783,7 @@ printk("chester-abyDesireSSID=%s\n",((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->abySS
                 vMgrCreateOwnIBSS((void *)pDevice, &Status);
                 if (Status != CMD_STATUS_SUCCESS){
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " vMgrCreateOwnIBSS fail ! \n");
-                };
+                }
                 // alway turn off unicast bit
                 MACvRegBitsOff(pDevice->PortOffset, MAC_REG_RCR, RCR_UNICAST);
                 pDevice->byRxMode &= ~RCR_UNICAST;
@@ -814,7 +814,7 @@ printk("chester-abyDesireSSID=%s\n",((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->abySS
                     }
                     pMgmt->sNodeDBTable[0].wEnQueueCnt--;
                 }
-            };
+            }
 
             // PS nodes tx
             for (ii = 1; ii < (MAX_NODE_NUM + 1); ii++) {
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index e540110..71f7726 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -661,7 +661,7 @@ vMgrDisassocBeginSta(
     if (*pStatus == CMD_STATUS_PENDING) {
         pMgmt->eCurrState = WMAC_STATE_IDLE;
         *pStatus = CMD_STATUS_SUCCESS;
-    };
+    }
 
     return;
 }
@@ -1019,7 +1019,7 @@ s_vMgrRxAssocResponse(
             (sFrame.pSuppRates == 0)){
             DBG_PORT80(0xCC);
             return;
-        };
+        }
 
         pMgmt->sAssocInfo.AssocInfo.ResponseFixedIEs.Capabilities = *(sFrame.pwCapInfo);
         pMgmt->sAssocInfo.AssocInfo.ResponseFixedIEs.StatusCode = *(sFrame.pwStatus);
@@ -1039,7 +1039,7 @@ s_vMgrRxAssocResponse(
             if ( (pMgmt->wCurrAID >> 14) != (BIT0 | BIT1) )
             {
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "AID from AP, has two msb clear.\n");
-            };
+            }
             DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Association Successful, AID=%d.\n", pMgmt->wCurrAID & ~(BIT14|BIT15));
             pMgmt->eCurrState = WMAC_STATE_ASSOC;
             BSSvUpdateAPNode((void *)pDevice, sFrame.pwCapInfo, sFrame.pSuppRates, sFrame.pExtSuppRates);
@@ -1692,7 +1692,7 @@ s_vMgrRxDisassociation(
         //try to send associate packet again because of inactivity timeout
       //  if (pMgmt->eCurrState == WMAC_STATE_ASSOC) {
        //     vMgrReAssocBeginSta((PSDevice)pDevice, pMgmt, &CmdStatus);
-      //  };
+      //  }
         if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
              wpahdr = (viawget_wpa_header *)pDevice->skb->data;
              wpahdr->type = VIAWGET_DISASSOC_MSG;
@@ -1707,7 +1707,7 @@ s_vMgrRxDisassociation(
              memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
              netif_rx(pDevice->skb);
              pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-         };
+         }
 
  #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
   // if(pDevice->bWPASuppWextEnabled == true)
@@ -1778,7 +1778,7 @@ s_vMgrRxDeauthentication(
                     netif_stop_queue(pDevice->dev);
                     pDevice->bLinkPass = false;
                 }
-            };
+            }
 
             if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
                  wpahdr = (viawget_wpa_header *)pDevice->skb->data;
@@ -1793,7 +1793,7 @@ s_vMgrRxDeauthentication(
                  memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
                  netif_rx(pDevice->skb);
                  pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-           };
+           }
 
    #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
   // if(pDevice->bWPASuppWextEnabled == true)
@@ -1912,7 +1912,7 @@ s_vMgrRxBeacon(
         (sFrame.pSuppRates == 0) ) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rx beacon frame error\n");
         return;
-    };
+    }
 
 
     if (sFrame.pDSParms != NULL) {
@@ -2054,7 +2054,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                    sFrame.pSSID->len
                    ) == 0) {
             bIsSSIDEqual = true;
-        };
+        }
     }
 
     if ((WLAN_GET_CAP_INFO_ESS(*sFrame.pwCapInfo)== true) &&
@@ -2138,8 +2138,8 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
     if (WLAN_GET_CAP_INFO_ESS(*sFrame.pwCapInfo)) {
         if (sFrame.pCFParms->wCFPDurRemaining > 0) {
             // TODO: deal with CFP period to set NAV
-        };
-    };
+        }
+    }
 
     HIDWORD(qwTimestamp) = cpu_to_le32(HIDWORD(*sFrame.pqwTimestamp));
     LODWORD(qwTimestamp) = cpu_to_le32(LODWORD(*sFrame.pqwTimestamp));
@@ -2160,7 +2160,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
     }
     else if (HIDWORD(qwTimestamp) < HIDWORD(qwLocalTSF)) {
         bTSFOffsetPostive = false;
-    };
+    }
 
     if (bTSFOffsetPostive) {
         qwTSFOffset = CARDqGetTSFOffset(pRxPacket->byRxRate, (qwTimestamp), (qwLocalTSF));
@@ -2218,7 +2218,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                 if (pMgmt->bInTIM) {
                     PSvSendPSPOLL((PSDevice)pDevice);
 //                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN:PS-POLL sent..\n");
-                };
+                }
 
             }
             else {
@@ -2231,7 +2231,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                 }
                 if(PSbConsiderPowerDown(pDevice, false, false)) {
                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN: Power down now...\n");
-                };
+                }
             }
 
         }
@@ -2316,7 +2316,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                 pMgmt->sNodeDBTable[0].bActive = true;
                 pMgmt->sNodeDBTable[0].uInActiveCount = 0;
 
-            };
+            }
         }
         else if (bIsSSIDEqual) {
 
@@ -2356,9 +2356,9 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                      // Prepare beacon frame
                      bMgrPrepareBeaconToSend((void *)pDevice, pMgmt);
               //  }
-            };
+            }
         }
-    };
+    }
     // endian issue ???
     // Update TSF
     if (bUpdateTSF) {
@@ -2590,7 +2590,7 @@ vMgrCreateOwnIBSS(
             pMgmt->byCSSPK = KEY_CTL_WEP;
             pMgmt->byCSSGK = KEY_CTL_WEP;
         }
-    };
+    }
 
     pMgmt->byERPContext = 0;
 
@@ -2683,7 +2683,7 @@ vMgrJoinBSSBegin(
        *pStatus = CMD_STATUS_RESOURCES;
         DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "BSS finding:BSS list is empty.\n");
        return;
-    };
+    }
 
     // memset(pMgmt->abyDesireBSSID, 0,  WLAN_BSSID_LEN);
     // Search known BSS list for prefer BSSID or SSID
@@ -2699,7 +2699,7 @@ vMgrJoinBSSBegin(
        pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
        DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Scanning [%s] not found, disconnected !\n", pItemSSID->abySSID);
        return;
-    };
+    }
 
     DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "AP(BSS) finding:Found a AP(BSS)..\n");
     if (WLAN_GET_CAP_INFO_ESS(cpu_to_le16(pCurr->wCapInfo))){
@@ -4343,7 +4343,7 @@ s_vMgrRxProbeResponse(
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe resp:Fail addr:[%p] \n", pRxPacket->p80211Header);
         DBG_PORT80(0xCC);
         return;
-    };
+    }
 
     if(sFrame.pSSID->len == 0)
        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rx Probe resp: SSID len = 0 \n");
@@ -4625,7 +4625,7 @@ vMgrRxManagePacket(
             //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx beacon\n");
             if (pMgmt->eScanState != WMAC_NO_SCANNING) {
                 bInScan = true;
-            };
+            }
             s_vMgrRxBeacon(pDevice, pMgmt, pRxPacket, bInScan);
             break;
 
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index fbae16d..78e326c 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -723,7 +723,7 @@ static int wpa_get_scan(PSDevice pDevice,
 
     if (copy_to_user(param->u.scan_results.buf, pBuf, sizeof(struct viawget_scan_result) * count)) {
 		ret = -EFAULT;
-	};
+	}
 	param->u.scan_results.scan_count = count;
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " param->u.scan_results.scan_count = %d\n", count)
 
@@ -875,7 +875,7 @@ if (!((pMgmt->eAuthenMode == WMAC_AUTH_SHAREKEY) ||
     if (pCurr == NULL){
     printk("wpa_set_associate---->hidden mode site survey before associate.......\n");
     bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, pMgmt->abyDesireSSID);
-  };
+  }
 }
 /****************************************************************/
     bScheduleCommand((void *) pDevice, WLAN_CMD_SSID, NULL);
diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 2bdd0a2..af006df 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -1192,7 +1192,7 @@ if((pMgmt->eCurrState!=WMAC_STATE_ASSOC) &&
              memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
              netif_rx(pDevice->skb);
              pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-         };
+         }
    #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
   // if(pDevice->bWPASuppWextEnabled == TRUE)
       {
@@ -1416,7 +1416,7 @@ void BSSvUpdateNodeTxCounter(void *hDeviceContext,
 			}
                 }
             }
-        };
+        }
 
 	if ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) ||
             (pMgmt->eCurrMode == WMAC_MODE_ESS_AP)) {
@@ -1472,9 +1472,9 @@ void BSSvUpdateNodeTxCounter(void *hDeviceContext,
 		      }
                     }
                 }
-            };
+            }
         }
-    };
+    }
 
     return;
 
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index f4fb0c6..cb817ce 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -730,7 +730,7 @@ RXbBulkInProcessData (
                 pMgmt->bInTIMWake = FALSE;
             }
         }
-    };
+    }
 
     // Now it only supports 802.11g Infrastructure Mode, and support rate must up to 54 Mbps
     if (pDevice->bDiversityEnable && (FrameSize>50) &&
@@ -913,7 +913,7 @@ RXbBulkInProcessData (
                      memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
                      netif_rx(pDevice->skb);
                      pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-                 };
+                 }
 
                 return FALSE;
 
@@ -1045,7 +1045,7 @@ static BOOL s_bAPModeRxCtl (
                                          );
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: send vMgrDeAuthenBeginSta 1\n");
                     return TRUE;
-                };
+                }
                 if (pMgmt->sNodeDBTable[iSANodeIndex].eNodeState < NODE_ASSOC) {
                     // send deassoc notification
                     // reason = (7) class 3 received from nonassoc sta
@@ -1057,7 +1057,7 @@ static BOOL s_bAPModeRxCtl (
                                          );
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: send vMgrDisassocBeginSta 2\n");
                     return TRUE;
-                };
+                }
 
                 if (pMgmt->sNodeDBTable[iSANodeIndex].bPSEnable) {
                     // delcare received ps-poll event
@@ -1488,7 +1488,7 @@ static BOOL s_bAPModeRxData (
                     bRelayOnly = TRUE;
                 }
             }
-        };
+        }
     }
 
     if (bRelayOnly || bRelayAndForward) {
diff --git a/drivers/staging/vt6656/ioctl.c b/drivers/staging/vt6656/ioctl.c
index 2fe071c..12be316 100644
--- a/drivers/staging/vt6656/ioctl.c
+++ b/drivers/staging/vt6656/ioctl.c
@@ -90,7 +90,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sScanCmd, pReq->data, sizeof(SCmdScan))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 
         pItemSSID = (PWLAN_IE_SSID)sScanCmd.ssid;
         if (pItemSSID->len != 0) {
@@ -124,7 +124,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sZoneTypeCmd, pReq->data, sizeof(SCmdZoneTypeSet))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 
           if(sZoneTypeCmd.bWrite==TRUE) {
 	  //////write zonetype
@@ -163,7 +163,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 	   if (copy_to_user(pReq->data, &sZoneTypeCmd, sizeof(SCmdZoneTypeSet))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 	}
 
 	     break;
@@ -173,7 +173,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sJoinCmd, pReq->data, sizeof(SCmdBSSJoin))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 
         pItemSSID = (PWLAN_IE_SSID)sJoinCmd.ssid;
         memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
@@ -223,7 +223,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sWEPCmd, pReq->data, sizeof(SCmdSetWEP))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 	    if (sWEPCmd.bEnableWep != TRUE) {
 	        int uu;
 
@@ -295,7 +295,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_to_user(pReq->data, &sLinkStatus, sizeof(SCmdLinkStatus))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 
         break;
 
@@ -312,7 +312,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_to_user(pReq->data, &sList, sizeof(SBSSIDList))) {
 			result = -EFAULT;
 			break;
-		};
+		}
         pReq->wResult = 0;
         break;
 
@@ -320,7 +320,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sList, pReq->data, sizeof(SBSSIDList))) {
 			result = -EFAULT;
 			break;
-		};
+		}
         pList = (PSBSSIDList)kmalloc(sizeof(SBSSIDList) + (sList.uItem * sizeof(SBSSIDItem)), (int)GFP_ATOMIC);
         if (pList == NULL) {
             result = -ENOMEM;
@@ -362,7 +362,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_to_user(pReq->data, pList, sizeof(SBSSIDList) + (sList.uItem * sizeof(SBSSIDItem)))) {
 			result = -EFAULT;
 			break;
-		};
+		}
         kfree(pList);
         pReq->wResult = 0;
         break;
@@ -371,14 +371,14 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_to_user(pReq->data, &(pDevice->s802_11Counter), sizeof(SDot11MIBCount))) {
 			result = -EFAULT;
 			break;
-		};
+		}
         break;
 
     case WLAN_CMD_GET_STAT:
         if (copy_to_user(pReq->data, &(pDevice->scStatistic), sizeof(SStatCounter))) {
 			result = -EFAULT;
 			break;
-		};
+		}
         break;
     case WLAN_CMD_STOP_MAC:
 
@@ -415,7 +415,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sValue, pReq->data, sizeof(SCmdValue))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 		if (sValue.dwValue == 1) {
             if (vt6656_hostap_set_hostapd(pDevice, 1, 1) == 0){
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable HOSTAP\n");
@@ -443,7 +443,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sValue, pReq->data, sizeof(SCmdValue))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 
 		if (sValue.dwValue == 1) {
             pDevice->bEnable8021x = TRUE;
@@ -463,7 +463,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sValue, pReq->data, sizeof(SCmdValue))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 
 		if (sValue.dwValue == 1) {
             pDevice->bEnableHostWEP = TRUE;
@@ -482,7 +482,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sValue, pReq->data, sizeof(SCmdValue))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 		if (sValue.dwValue == 1) {
                      DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "up wpadev\n");
 		   memcpy(pDevice->wpadev->dev_addr,
@@ -507,7 +507,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sStartAPCmd, pReq->data, sizeof(SCmdStartAP))) {
 			result = -EFAULT;
 			break;
-		};
+		}
 
 	    if (sStartAPCmd.wBSSType == AP) {
 	        pMgmt->eConfigMode = WMAC_CONFIG_AP;
@@ -600,7 +600,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_to_user(pReq->data, &sNodeList, sizeof(SNodeList))) {
 			result = -EFAULT;
 			break;
-		};
+		}
         pReq->wResult = 0;
         break;
 
@@ -609,7 +609,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_from_user(&sNodeList, pReq->data, sizeof(SNodeList))) {
 			result = -EFAULT;
 			break;
-		};
+		}
         pNodeList = (PSNodeList)kmalloc(sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)), (int)GFP_ATOMIC);
         if (pNodeList == NULL) {
             result = -ENOMEM;
@@ -649,7 +649,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         if (copy_to_user(pReq->data, pNodeList, sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)))) {
 			result = -EFAULT;
 			break;
-		};
+		}
         kfree(pNodeList);
         pReq->wResult = 0;
         break;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index af14ab0..9a8eaf1 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -709,7 +709,7 @@ static BOOL device_release_WPADEV(PSDevice pDevice)
 	        if(ii>20)
 		  break;
               }
-           };
+           }
     return TRUE;
 }
 
@@ -995,7 +995,7 @@ static BOOL device_init_defrag_cb(PSDevice pDevice) {
             DBG_PRT(MSG_LEVEL_ERR,KERN_ERR "%s: can not alloc frag bufs\n",
                 pDevice->dev->name);
             goto free_frag;
-        };
+        }
     }
     pDevice->cbDFCB = CB_MAX_RX_FRAG;
     pDevice->cbFreeDFCB = pDevice->cbDFCB;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 8f18578..ffd4454 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -2441,13 +2441,13 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb) {
         if (pDevice->bEnableHostWEP) {
             uNodeIndex = 0;
             bNodeExist = TRUE;
-        };
+        }
     }
     else {
         if (pDevice->bEnableHostWEP) {
             if (BSSbIsSTAInNodeDB(pDevice, (PBYTE)(p80211Header->sA3.abyAddr1), &uNodeIndex))
                 bNodeExist = TRUE;
-        };
+        }
         bNeedACK = TRUE;
         pTxBufHead->wFIFOCtl |= FIFOCTL_NEEDACK;
     };
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index b83b660..c158ced 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -642,7 +642,7 @@ void vRunCommand(void *hDeviceContext)
                     if (Status != CMD_STATUS_SUCCESS){
 			DBG_PRT(MSG_LEVEL_DEBUG,
 				KERN_INFO "WLAN_CMD_IBSS_CREATE fail!\n");
-                    };
+                    }
                     BSSvAddMulticastNode(pDevice);
                 }
                 s_bClearBSSID_SCAN(pDevice);
@@ -658,7 +658,7 @@ void vRunCommand(void *hDeviceContext)
                     if (Status != CMD_STATUS_SUCCESS){
 			DBG_PRT(MSG_LEVEL_DEBUG,
 				KERN_INFO "WLAN_CMD_IBSS_CREATE fail!\n");
-                    };
+                    }
                     BSSvAddMulticastNode(pDevice);
                     s_bClearBSSID_SCAN(pDevice);
 /*
@@ -793,7 +793,7 @@ void vRunCommand(void *hDeviceContext)
 		if (Status != CMD_STATUS_SUCCESS) {
 			DBG_PRT(MSG_LEVEL_DEBUG,
 				KERN_INFO "vMgrCreateOwnIBSS fail!\n");
-                };
+                }
                 // alway turn off unicast bit
                 MACvRegBitsOff(pDevice, MAC_REG_RCR, RCR_UNICAST);
                 pDevice->byRxMode &= ~RCR_UNICAST;
@@ -827,7 +827,7 @@ void vRunCommand(void *hDeviceContext)
 
                     pMgmt->sNodeDBTable[0].wEnQueueCnt--;
                 }
-            };
+            }
 
             // PS nodes tx
             for (ii = 1; ii < (MAX_NODE_NUM + 1); ii++) {
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 2ec200d..938e582 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -593,7 +593,7 @@ void vMgrDisassocBeginSta(void *hDeviceContext,
     if (*pStatus == CMD_STATUS_PENDING) {
         pMgmt->eCurrState = WMAC_STATE_IDLE;
         *pStatus = CMD_STATUS_SUCCESS;
-    };
+    }
 
     return;
 }
@@ -942,7 +942,7 @@ s_vMgrRxAssocResponse(
 	    || (sFrame.pSuppRates == NULL)) {
 		DBG_PORT80(0xCC);
 		return;
-        };
+        }
 
         pMgmt->sAssocInfo.AssocInfo.ResponseFixedIEs.Capabilities = *(sFrame.pwCapInfo);
         pMgmt->sAssocInfo.AssocInfo.ResponseFixedIEs.StatusCode = *(sFrame.pwStatus);
@@ -962,7 +962,7 @@ s_vMgrRxAssocResponse(
             if ( (pMgmt->wCurrAID >> 14) != (BIT0 | BIT1) )
             {
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "AID from AP, has two msb clear.\n");
-            };
+            }
             DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Association Successful, AID=%d.\n", pMgmt->wCurrAID & ~(BIT14|BIT15));
             pMgmt->eCurrState = WMAC_STATE_ASSOC;
 	    BSSvUpdateAPNode((void *) pDevice,
@@ -1621,7 +1621,7 @@ s_vMgrRxDisassociation(
              memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
              netif_rx(pDevice->skb);
              pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-         };
+         }
 
         //TODO: do something let upper layer know or
         //try to send associate packet again because of inactivity timeout
@@ -1636,7 +1636,7 @@ s_vMgrRxDisassociation(
 		  pDevice->byReAssocCount ++;
 		  return;       //mike add: you'll retry for many times, so it cann't be regarded as disconnected!
               }
-        };
+        }
 
    #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
   // if(pDevice->bWPASuppWextEnabled == TRUE)
@@ -1710,7 +1710,7 @@ s_vMgrRxDeauthentication(
                     pDevice->bLinkPass = FALSE;
                     ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
                 }
-            };
+            }
 
             if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
                  wpahdr = (viawget_wpa_header *)pDevice->skb->data;
@@ -1725,7 +1725,7 @@ s_vMgrRxDeauthentication(
                  memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
                  netif_rx(pDevice->skb);
                  pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-           };
+           }
 
    #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
   // if(pDevice->bWPASuppWextEnabled == TRUE)
@@ -1845,7 +1845,7 @@ s_vMgrRxBeacon(
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rx beacon frame error\n");
 	return;
-    };
+    }
 
     if( byCurrChannel > CB_MAX_CHANNEL_24G )
     {
@@ -1974,7 +1974,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
                    sFrame.pSSID->len
                    ) == 0) {
             bIsSSIDEqual = TRUE;
-        };
+        }
     }
 
     if ((WLAN_GET_CAP_INFO_ESS(*sFrame.pwCapInfo)== TRUE) &&
@@ -2074,8 +2074,8 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
     if (WLAN_GET_CAP_INFO_ESS(*sFrame.pwCapInfo)) {
         if (sFrame.pCFParms->wCFPDurRemaining > 0) {
             // TODO: deal with CFP period to set NAV
-        };
-    };
+        }
+    }
 
     HIDWORD(qwTimestamp) = cpu_to_le32(HIDWORD(*sFrame.pqwTimestamp));
     LODWORD(qwTimestamp) = cpu_to_le32(LODWORD(*sFrame.pqwTimestamp));
@@ -2096,7 +2096,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
     }
     else if (HIDWORD(qwTimestamp) < HIDWORD(qwLocalTSF)) {
         bTSFOffsetPostive = FALSE;
-    };
+    }
 
     if (bTSFOffsetPostive) {
         qwTSFOffset = CARDqGetTSFOffset(pRxPacket->byRxRate, (qwTimestamp), (qwLocalTSF));
@@ -2154,7 +2154,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
                 if (pMgmt->bInTIM) {
                     PSvSendPSPOLL((PSDevice)pDevice);
 //                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN:PS-POLL sent..\n");
-                };
+                }
 
             }
             else {
@@ -2167,7 +2167,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
                 }
                 if(PSbConsiderPowerDown(pDevice, FALSE, FALSE)) {
                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN: Power down now...\n");
-                };
+                }
             }
 
         }
@@ -2247,7 +2247,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
                 pMgmt->sNodeDBTable[0].bActive = TRUE;
                 pMgmt->sNodeDBTable[0].uInActiveCount = 0;
 
-            };
+            }
         }
         else if (bIsSSIDEqual) {
 
@@ -2292,9 +2292,9 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
                      // Prepare beacon frame
 			bMgrPrepareBeaconToSend((void *) pDevice, pMgmt);
               //  }
-            };
+            }
         }
-    };
+    }
     // endian issue ???
     // Update TSF
     if (bUpdateTSF) {
@@ -2556,7 +2556,7 @@ void vMgrCreateOwnIBSS(void *hDeviceContext,
             pMgmt->byCSSPK = KEY_CTL_WEP;
             pMgmt->byCSSGK = KEY_CTL_WEP;
         }
-    };
+    }
 
     pMgmt->byERPContext = 0;
 
@@ -2614,7 +2614,7 @@ void vMgrJoinBSSBegin(void *hDeviceContext, PCMD_STATUS pStatus)
        *pStatus = CMD_STATUS_RESOURCES;
         DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "BSS finding:BSS list is empty.\n");
        return;
-    };
+    }
 
     // memset(pMgmt->abyDesireBSSID, 0,  WLAN_BSSID_LEN);
     // Search known BSS list for prefer BSSID or SSID
@@ -2630,7 +2630,7 @@ void vMgrJoinBSSBegin(void *hDeviceContext, PCMD_STATUS pStatus)
        pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
        DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Scanning [%s] not found, disconnected !\n", pItemSSID->abySSID);
        return;
-    };
+    }
 
     DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "AP(BSS) finding:Found a AP(BSS)..\n");
 
@@ -3061,7 +3061,7 @@ s_vMgrSynchBSS (
         MACvRegBitsOn(pDevice, MAC_REG_RCR, RCR_BSSID);
         pDevice->byRxMode |= RCR_BSSID;
         pMgmt->bCurrBSSIDFilterOn = TRUE;
-    };
+    }
 
     if (pDevice->byBBType == BB_TYPE_11A) {
         memcpy(pMgmt->abyCurrSuppRates, &abyCurrSuppRatesA[0], sizeof(abyCurrSuppRatesA));
@@ -4209,7 +4209,7 @@ s_vMgrRxProbeResponse(
 		pRxPacket->p80211Header);
 	DBG_PORT80(0xCC);
 	return;
-    };
+    }
 
     if(sFrame.pSSID->len == 0)
        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rx Probe resp: SSID len = 0 \n");
@@ -4491,7 +4491,7 @@ void vMgrRxManagePacket(void *hDeviceContext,
             //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx beacon\n");
             if (pMgmt->eScanState != WMAC_NO_SCANNING) {
                 bInScan = TRUE;
-            };
+            }
             s_vMgrRxBeacon(pDevice, pMgmt, pRxPacket, bInScan);
             break;
 
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index 8752736..dabcb6e 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -729,7 +729,7 @@ static int wpa_get_scan(PSDevice pDevice,
 
     if (copy_to_user(param->u.scan_results.buf, pBuf, sizeof(struct viawget_scan_result) * count)) {
 		ret = -EFAULT;
-	};
+	}
 	param->u.scan_results.scan_count = count;
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " param->u.scan_results.scan_count = %d\n", count)
 
@@ -886,7 +886,7 @@ static int wpa_set_associate(PSDevice pDevice,
     bScheduleCommand((void *) pDevice,
 		     WLAN_CMD_BSSID_SCAN,
 		     pMgmt->abyDesireSSID);
-  };
+  }
 }
 /****************************************************************/
 
-- 
1.7.4.2.g597a6.dirty

