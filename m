Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab2DFOeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 10:34:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38121 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab2DFOeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 10:34:03 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] staging: Fix typo in multiple files
Date: Fri,  6 Apr 2012 23:33:52 +0900
Message-Id: <1333722832-8278-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10.rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Collect spelling typo in multiple files within staging directory.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/bcm/Misc.c                              |    2 +-
 drivers/staging/comedi/drivers/dt9812.c                 |    2 +-
 drivers/staging/comedi/drivers/rtd520.c                 |    8 ++++----
 drivers/staging/media/go7007/README                     |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c |    2 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c     |    2 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c          |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c       |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c  |    2 +-
 drivers/staging/tidspbridge/core/io_sm.c                |    2 +-
 drivers/staging/tidspbridge/core/ue_deh.c               |    2 +-
 drivers/staging/usbip/usbip_protocol.txt                |    2 +-
 drivers/staging/vme/devices/vme_pio2_gpio.c             |    2 +-
 13 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
index c7725e1..8223a69 100644
--- a/drivers/staging/bcm/Misc.c
+++ b/drivers/staging/bcm/Misc.c
@@ -835,7 +835,7 @@ int reset_card_proc(PMINI_ADAPTER ps_adapter)
 	Bcm_kill_all_URBs(psIntfAdapter);
 	/* Reset the UMA-B Device */
 	if (ps_adapter->chip_id >= T3LPB) {
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Reseting UMA-B\n");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Resetting UMA-B\n");
 		retval = usb_reset_device(psIntfAdapter->udev);
 		psIntfAdapter->psAdapter->StopAllXaction = FALSE;
 
diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index e86ab58..53953c2 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -715,7 +715,7 @@ static int dt9812_probe(struct usb_interface *interface,
 	iface_desc = interface->cur_altsetting;
 
 	if (iface_desc->desc.bNumEndpoints != 5) {
-		err("Wrong number of endpints.");
+		err("Wrong number of endpoints.");
 		retval = -ENODEV;
 		goto error;
 	}
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 1384419..3b7393a 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -353,7 +353,7 @@ struct rtdPrivate {
 
 	unsigned long intCount;	/* interrupt count */
 	long aiCount;		/* total transfer size (samples) */
-	int transCount;		/* # to tranfer data. 0->1/2FIFO */
+	int transCount;		/* # to transfer data. 0->1/2FIFO */
 	int flags;		/* flag event modes */
 
 	/* PCI device info */
@@ -1989,7 +1989,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 			    (TRANS_TARGET_PERIOD * cmd->chanlist_len) /
 			    cmd->scan_begin_arg;
 			if (devpriv->transCount < cmd->chanlist_len) {
-				/* tranfer after each scan (and avoid 0) */
+				/* transfer after each scan (and avoid 0) */
 				devpriv->transCount = cmd->chanlist_len;
 			} else {	/* make a multiple of scan length */
 				devpriv->transCount =
@@ -2005,12 +2005,12 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 			devpriv->transCount = 0;
 			devpriv->flags &= ~SEND_EOS;
 		} else {
-			/* interrupt for each tranfer */
+			/* interrupt for each transfer */
 			RtdAboutCounter(dev, devpriv->transCount - 1);
 		}
 
 		DPRINTK
-		    ("rtd520: scanLen=%d tranferCount=%d fifoLen=%d\n  scanTime(ns)=%d flags=0x%x\n",
+		    ("rtd520: scanLen=%d transferCount=%d fifoLen=%d\n  scanTime(ns)=%d flags=0x%x\n",
 		     cmd->chanlist_len, devpriv->transCount, devpriv->fifoLen,
 		     cmd->scan_begin_arg, devpriv->flags);
 	} else {		/* unknown timing, just use 1/2 FIFO */
diff --git a/drivers/staging/media/go7007/README b/drivers/staging/media/go7007/README
index 48f4476..c8d6214 100644
--- a/drivers/staging/media/go7007/README
+++ b/drivers/staging/media/go7007/README
@@ -6,6 +6,6 @@ Todo:
 	- testing?
 	- handle churn in v4l layer.
 
-Please send patchs to Greg Kroah-Hartman <greg@kroah.com> and Cc: Ross
+Please send patches to Greg Kroah-Hartman <greg@linuxfoundation.org> and Cc: Ross
 Cohen <rcohen@snurgle.org> as well.
 
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index 26bacb9..0f909b7 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -1905,7 +1905,7 @@ associate_complete:
 							}
 						}else{
 							ieee->softmac_stats.rx_auth_rs_err++;
-							IEEE80211_DEBUG_MGMT("Authentication respose status code 0x%x",errcode);
+							IEEE80211_DEBUG_MGMT("Authentication response status code 0x%x",errcode);
 							ieee80211_associate_abort(ieee);
 						}
 
diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
index 3771985..b526fa4 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
@@ -216,7 +216,7 @@ static bool firmware_check_ready(struct net_device *dev,
 		break;
 	default:
 		rt_status = false;
-		RT_TRACE(COMP_FIRMWARE, "Unknown firware status");
+		RT_TRACE(COMP_FIRMWARE, "Unknown firmware status");
 		break;
 	}
 
diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
index 3e705ef..9676c59 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
@@ -689,7 +689,7 @@ void rtl8192_phy_setTxPower(struct net_device *dev, u8 channel)
 	case RF_8258:
 		break;
 	default:
-		RT_TRACE(COMP_ERR, "unknown rf chip in funtion %s()\n",
+		RT_TRACE(COMP_ERR, "unknown rf chip in function %s()\n",
 			 __func__);
 		break;
 	}
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index be2a28c..6249c3f 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -671,7 +671,7 @@ void RxReorderIndicatePacket( struct ieee80211_device *ieee,
 		index = 1;
 	} else {
 		/* Current packet is going to be inserted into pending list.*/
-		//IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): We RX no ordered packed, insert to orderd list\n",__FUNCTION__);
+		//IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): We RX no ordered packed, insert to ordered list\n",__FUNCTION__);
 		if(!list_empty(&ieee->RxReorder_Unused_List)) {
 			pReorderEntry = (PRX_REORDER_ENTRY)list_entry(ieee->RxReorder_Unused_List.next,RX_REORDER_ENTRY,List);
 			list_del_init(&pReorderEntry->List);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index c2ab5fa..f6ff8cf 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -2062,7 +2062,7 @@ ieee80211_rx_frame_softmac(struct ieee80211_device *ieee, struct sk_buff *skb,
 							}
 						}else{
 							ieee->softmac_stats.rx_auth_rs_err++;
-							IEEE80211_DEBUG_MGMT("Authentication respose status code 0x%x",errcode);
+							IEEE80211_DEBUG_MGMT("Authentication response status code 0x%x",errcode);
 							ieee80211_associate_abort(ieee);
 						}
 
diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index 9b50b5b..c51f651 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -2212,7 +2212,7 @@ void dump_dl_modules(struct bridge_dev_context *bridge_context)
 
 		if (status) {
 			pr_debug(
-			"%s: Failed to read dll_module stuct for 0x%x.\n",
+			"%s: Failed to read dll_module struct for 0x%x.\n",
 			__func__, module_dsp_addr);
 			break;
 		}
diff --git a/drivers/staging/tidspbridge/core/ue_deh.c b/drivers/staging/tidspbridge/core/ue_deh.c
index 006ffd7..3d28b23 100644
--- a/drivers/staging/tidspbridge/core/ue_deh.c
+++ b/drivers/staging/tidspbridge/core/ue_deh.c
@@ -215,7 +215,7 @@ static inline const char *event_to_string(int event)
 	case DSP_MMUFAULT: return "DSP_MMUFAULT"; break;
 	case DSP_PWRERROR: return "DSP_PWRERROR"; break;
 	case DSP_WDTOVERFLOW: return "DSP_WDTOVERFLOW"; break;
-	default: return "unkown event"; break;
+	default: return "unknown event"; break;
 	}
 }
 
diff --git a/drivers/staging/usbip/usbip_protocol.txt b/drivers/staging/usbip/usbip_protocol.txt
index 0f10208..16b6fe2 100644
--- a/drivers/staging/usbip/usbip_protocol.txt
+++ b/drivers/staging/usbip/usbip_protocol.txt
@@ -27,7 +27,7 @@ Once the client knows the list of exported USB devices it may decide to use one
 of them. First the client opens a TCP/IP connection towards the server and
 sends an OP_REQ_IMPORT packet. The server replies with OP_REP_IMPORT. If the
 import was successful the TCP/IP connection remains open and will be used
-to trasfer the URB traffic between the client and the server. The client may
+to transfer the URB traffic between the client and the server. The client may
 send two types of packets: the USBIP_CMD_SUBMIT to submit an URB, and
 USBIP_CMD_UNLINK to unlink a previously submitted URB. The answers of the
 server may be USBIP_RET_SUBMIT and USBIP_RET_UNLINK respectively.
diff --git a/drivers/staging/vme/devices/vme_pio2_gpio.c b/drivers/staging/vme/devices/vme_pio2_gpio.c
index 8584849..c766d39 100644
--- a/drivers/staging/vme/devices/vme_pio2_gpio.c
+++ b/drivers/staging/vme/devices/vme_pio2_gpio.c
@@ -79,7 +79,7 @@ static void pio2_gpio_set(struct gpio_chip *chip, unsigned int offset,
 	if ((card->bank[PIO2_CHANNEL_BANK[offset]].config == INPUT) |
 		(card->bank[PIO2_CHANNEL_BANK[offset]].config == NOFIT)) {
 
-		dev_err(&card->vdev->dev, "Channel not availabe as output\n");
+		dev_err(&card->vdev->dev, "Channel not available as output\n");
 		return;
 	}
 
-- 
1.7.10.rc4

