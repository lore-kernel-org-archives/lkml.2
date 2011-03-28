Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab1C1LKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 07:10:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33353 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1C1LKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 07:10:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=JV/M7YvVAgmA71j34PReKGfWuXWcc/k6fzcCTJQZ00SZ1ichO5whDebDnv7D1INvNp
         N7ThJmA6LLrrx3Va+epjGmudgB68m3xZo+5zQsGe1g/1yt9y3QqJ1+PF4S7vXDYWJSZ4
         rpZq3wVPdngLTtYYqqyJqEXNfjAZkeaWHuRP0=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] staging:ft1000: Remove dead code in ft1000_hw.c
Date: Mon, 28 Mar 2011 13:10:27 +0200
Message-Id: <1301310627-30366-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |  151 +++++--------------------
 1 files changed, 30 insertions(+), 121 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 78dcd49..0d0e437 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -6,8 +6,6 @@
 //
 // $Id:
 //====================================================
-// 20090926; aelias; removed compiler warnings & errors; ubuntu 9.04; 2.6.28-15-generic
-
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -38,8 +36,6 @@ static int ft1000_open (struct net_device *dev);
 static struct net_device_stats *ft1000_netdev_stats(struct net_device *dev);
 static int ft1000_chkcard (struct ft1000_device *dev);
 
-//Jim
-
 static u8 tempbuffer[1600];
 
 #define MAX_RCV_LOOP   100
@@ -492,8 +488,6 @@ void card_send_command(struct ft1000_device *ft1000dev, void *ptempbuffer,
 	commandbuf = (unsigned char *)kmalloc(size + 2, GFP_KERNEL);
 	memcpy((void *)commandbuf + 2, (void *)ptempbuffer, size);
 
-	//DEBUG("card_send_command: Command Send\n");
-
 	ft1000_read_register(ft1000dev, &temp, FT1000_REG_DOORBELL);
 
 	if (temp & 0x0100)
@@ -506,16 +500,14 @@ void card_send_command(struct ft1000_device *ft1000dev, void *ptempbuffer,
 	if (size % 4)
 		size += 4 - (size % 4);
 
-	//DEBUG("card_send_command: write dpram ... size=%d\n", size);
 	ft1000_write_dpram32(ft1000dev, 0, commandbuf, size);
 	msleep(1);
-	//DEBUG("card_send_command: write into doorbell ...\n");
 	ft1000_write_register(ft1000dev, FT1000_DB_DPRAM_TX,
 			      FT1000_REG_DOORBELL);
 	msleep(1);
 
 	ft1000_read_register(ft1000dev, &temp, FT1000_REG_DOORBELL);
-	//DEBUG("card_send_command: read doorbell ...temp=%x\n", temp);
+
 	if ((temp & 0x0100) == 0) {
 		//DEBUG("card_send_command: Message sent\n");
 	}
@@ -683,8 +675,6 @@ static int ft1000_reset_card(struct net_device *dev)
 	return TRUE;
 }
 
-
-//mbelian
 #ifdef HAVE_NET_DEVICE_OPS
 static const struct net_device_ops ftnet_ops =
 {
@@ -904,14 +894,10 @@ static void ft1000_usb_transmit_complete(struct urb *urb)
 
 	struct ft1000_device *ft1000dev = urb->context;
 
-    //DEBUG("ft1000_usb_transmit_complete entered\n");
-
 	if (urb->status)
 		pr_err("%s: TX status %d\n", ft1000dev->net->name, urb->status);
 
 	netif_wake_queue(ft1000dev->net);
-
-    //DEBUG("Return from ft1000_usb_transmit_complete\n");
 }
 
 //---------------------------------------------------------------------------
@@ -943,8 +929,6 @@ static int ft1000_copy_down_pkt(struct net_device *netdev, u8 * packet, u16 len)
 		return -ENODEV;
 	}
 
-	//DEBUG("ft1000_copy_down_pkt() entered, len = %d\n", len);
-
 	count = sizeof(struct pseudo_hdr) + len;
 	if (count > MAX_BUF_SIZE) {
 		DEBUG("Error:ft1000_copy_down_pkt:Message Size Overflow!\n");
@@ -973,8 +957,6 @@ static int ft1000_copy_down_pkt(struct net_device *netdev, u8 * packet, u16 len)
 
 	netif_stop_queue(netdev);
 
-	//DEBUG ("ft1000_copy_down_pkt: count = %d\n", count);
-
 	usb_fill_bulk_urb(pFt1000Dev->tx_urb,
 			  pFt1000Dev->dev,
 			  usb_sndbulkpipe(pFt1000Dev->dev,
@@ -983,11 +965,6 @@ static int ft1000_copy_down_pkt(struct net_device *netdev, u8 * packet, u16 len)
 			  ft1000_usb_transmit_complete, (void *)pFt1000Dev);
 
 	t = (u8 *) pFt1000Dev->tx_urb->transfer_buffer;
-	//DEBUG("transfer_length=%d\n", pFt1000Dev->tx_urb->transfer_buffer_length);
-	/*for (i=0; i<count; i++ )
-	   {
-	   DEBUG("%x    ", *t++ );
-	   } */
 
 	ret = usb_submit_urb(pFt1000Dev->tx_urb, GFP_ATOMIC);
 
@@ -999,8 +976,6 @@ static int ft1000_copy_down_pkt(struct net_device *netdev, u8 * packet, u16 len)
 		pInfo->stats.tx_bytes += (len + 14);
 	}
 
-	//DEBUG("ft1000_copy_down_pkt() exit\n");
-
 	return 0;
 }
 
@@ -1026,8 +1001,6 @@ static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	u8 *pdata;
 	int maxlen, pipe;
 
-	//DEBUG(" ft1000_start_xmit() entered\n");
-
 	if (skb == NULL) {
 		DEBUG("ft1000_hw: ft1000_start_xmit:skb == NULL!!!\n");
 		return NETDEV_TX_OK;
@@ -1037,17 +1010,12 @@ static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		DEBUG("network driver is closed, return\n");
 		goto err;
 	}
-	//DEBUG("ft1000_start_xmit 1:length of packet = %d\n", skb->len);
+
 	pipe =
 	    usb_sndbulkpipe(pFt1000Dev->dev, pFt1000Dev->bulk_out_endpointAddr);
 	maxlen = usb_maxpacket(pFt1000Dev->dev, pipe, usb_pipeout(pipe));
-	//DEBUG("ft1000_start_xmit 2: pipe=%d dev->maxpacket  = %d\n", pipe, maxlen);
 
 	pdata = (u8 *) skb->data;
-	/*for (i=0; i<skb->len; i++)
-	   DEBUG("skb->data[%d]=%x    ", i, *(skb->data+i));
-
-	   DEBUG("\n"); */
 
 	if (pInfo->mediastate == 0) {
 		/* Drop packet is mediastate is down */
@@ -1060,13 +1028,12 @@ static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		DEBUG("ft1000_hw:ft1000_start_xmit:invalid ethernet length\n");
 		goto err;
 	}
-//mbelian
+
 	ft1000_copy_down_pkt(dev, (pdata + ENET_HEADER_SIZE - 2),
 			     skb->len - ENET_HEADER_SIZE + 2);
 
 err:
 	dev_kfree_skb(skb);
-	//DEBUG(" ft1000_start_xmit() exit\n");
 
 	return NETDEV_TX_OK;
 }
@@ -1093,24 +1060,20 @@ static int ft1000_copy_up_pkt(struct urb *urb)
 
 	u16 tempword;
 	u16 len;
-	u16 lena;		//mbelian
+	u16 lena;
 	struct sk_buff *skb;
 	u16 i;
 	u8 *pbuffer = NULL;
 	u8 *ptemp = NULL;
 	u16 *chksum;
 
-	//DEBUG("ft1000_copy_up_pkt entered\n");
-
 	if (ft1000dev->status & FT1000_STATUS_CLOSING) {
 		DEBUG("network driver is closed, return\n");
 		return STATUS_SUCCESS;
 	}
 	// Read length
 	len = urb->transfer_buffer_length;
-	lena = urb->actual_length;	//mbelian
-	//DEBUG("ft1000_copy_up_pkt: transfer_buffer_length=%d, actual_buffer_len=%d\n",
-	//       urb->transfer_buffer_length, urb->actual_length);
+	lena = urb->actual_length;
 
 	chksum = (u16 *) ft1000dev->rx_buf;
 
@@ -1124,8 +1087,6 @@ static int ft1000_copy_up_pkt(struct urb *urb)
 		return STATUS_FAILURE;
 	}
 
-	//DEBUG("ft1000_copy_up_pkt: checksum is correct %x\n", *chksum);
-
 	skb = dev_alloc_skb(len + 12 + 2);
 
 	if (skb == NULL) {
@@ -1157,12 +1118,6 @@ static int ft1000_copy_up_pkt(struct urb *urb)
 	memcpy(pbuffer, ft1000dev->rx_buf + sizeof(struct pseudo_hdr),
 	       len - sizeof(struct pseudo_hdr));
 
-	//DEBUG("ft1000_copy_up_pkt: Data passed to Protocol layer\n");
-	/*for (i=0; i<len+12; i++)
-	   {
-	   DEBUG("ft1000_copy_up_pkt: Protocol Data: 0x%x\n ", *ptemp++);
-	   } */
-
 	skb->dev = net;
 
 	skb->protocol = eth_type_trans(skb, net);
@@ -1171,10 +1126,10 @@ static int ft1000_copy_up_pkt(struct urb *urb)
 
 	info->stats.rx_packets++;
 	/* Add on 12 bytes for MAC address which was removed */
-	info->stats.rx_bytes += (lena + 12);	//mbelian
+	info->stats.rx_bytes += (lena + 12);
 
 	ft1000_submit_rx_urb(info);
-	//DEBUG("ft1000_copy_up_pkt exited\n");
+
 	return SUCCESS;
 }
 
@@ -1197,10 +1152,8 @@ static int ft1000_submit_rx_urb(struct ft1000_info *info)
 	int result;
 	struct ft1000_device *pFt1000Dev = info->pFt1000Dev;
 
-	//DEBUG ("ft1000_submit_rx_urb entered: sizeof rx_urb is %d\n", sizeof(*pFt1000Dev->rx_urb));
 	if (pFt1000Dev->status & FT1000_STATUS_CLOSING) {
 		DEBUG("network driver is closed, return\n");
-		//usb_kill_urb(pFt1000Dev->rx_urb); //mbelian
 		return -ENODEV;
 	}
 
@@ -1218,7 +1171,6 @@ static int ft1000_submit_rx_urb(struct ft1000_info *info)
 		       result);
 		return result;
 	}
-	//DEBUG("ft1000_submit_rx_urb exit: result=%d\n", result);
 
 	return 0;
 }
@@ -1241,23 +1193,22 @@ static int ft1000_submit_rx_urb(struct ft1000_info *info)
 static int ft1000_open(struct net_device *dev)
 {
 	struct ft1000_info *pInfo = netdev_priv(dev);
-	struct timeval tv;	//mbelian
+	struct timeval tv;
 	int ret;
 
 	DEBUG("ft1000_open is called for card %d\n", pInfo->CardNumber);
-	//DEBUG("ft1000_open: dev->addr=%x, dev->addr_len=%d\n", dev->addr, dev->addr_len);
 
-	pInfo->stats.rx_bytes = 0;	//mbelian
-	pInfo->stats.tx_bytes = 0;	//mbelian
-	pInfo->stats.rx_packets = 0;	//mbelian
-	pInfo->stats.tx_packets = 0;	//mbelian
+	pInfo->stats.rx_bytes = 0;
+	pInfo->stats.tx_bytes = 0;
+	pInfo->stats.rx_packets = 0;
+	pInfo->stats.tx_packets = 0;
 	do_gettimeofday(&tv);
 	pInfo->ConTm = tv.tv_sec;
-	pInfo->ProgConStat = 0;	//mbelian
+	pInfo->ProgConStat = 0;
 
 	netif_start_queue(dev);
 
-	netif_carrier_on(dev);	//mbelian
+	netif_carrier_on(dev);
 
 	ret = ft1000_submit_rx_urb(pInfo);
 
@@ -1283,19 +1234,14 @@ int ft1000_close(struct net_device *net)
 	struct ft1000_info *pInfo = netdev_priv(net);
 	struct ft1000_device *ft1000dev = pInfo->pFt1000Dev;
 
-	//DEBUG ("ft1000_close: netdev->refcnt=%d\n", net->refcnt);
-
 	ft1000dev->status |= FT1000_STATUS_CLOSING;
 
-	//DEBUG("ft1000_close: calling usb_kill_urb \n");
-
 	DEBUG("ft1000_close: pInfo=%p, ft1000dev=%p\n", pInfo, ft1000dev);
-	netif_carrier_off(net);	//mbelian
+	netif_carrier_off(net);
 	netif_stop_queue(net);
-	//DEBUG("ft1000_close: netif_stop_queue called\n");
 	ft1000dev->status &= ~FT1000_STATUS_CLOSING;
 
-	pInfo->ProgConStat = 0xff;	//mbelian
+	pInfo->ProgConStat = 0xff;
 
 	return 0;
 }
@@ -1304,15 +1250,10 @@ static struct net_device_stats *ft1000_netdev_stats(struct net_device *dev)
 {
 	struct ft1000_info *info = netdev_priv(dev);
 
-	return &(info->stats); //mbelian
+	return &(info->stats);
 }
 
 
-/*********************************************************************************
-Jim
-*/
-
-
 //---------------------------------------------------------------------------
 //
 // Function:   ft1000_chkcard
@@ -1340,7 +1281,6 @@ static int ft1000_chkcard(struct ft1000_device *dev)
 	 * set to zero.
 	 */
 	status = ft1000_read_register(dev, &tempword, FT1000_REG_SUP_IMASK);
-	//DEBUG("ft1000_hw:ft1000_chkcard: read FT1000_REG_SUP_IMASK = %x\n", tempword);
 	if (tempword == 0) {
 		DEBUG
 		    ("ft1000_hw:ft1000_chkcard: IMASK = 0 Card not detected\n");
@@ -1350,9 +1290,8 @@ static int ft1000_chkcard(struct ft1000_device *dev)
 	 * if the device is not present.
 	 */
 	status = ft1000_read_register(dev, &tempword, FT1000_REG_ASIC_ID);
-	//DEBUG("ft1000_hw:ft1000_chkcard: read FT1000_REG_ASIC_ID = %x\n", tempword);
 	if (tempword != 0x1b01) {
-		dev->status |= FT1000_STATUS_CLOSING;	//mbelian
+		dev->status |= FT1000_STATUS_CLOSING;
 		DEBUG
 		    ("ft1000_hw:ft1000_chkcard: Version = 0xffff Card not detected\n");
 		return FALSE;
@@ -1395,7 +1334,6 @@ static bool ft1000_receive_cmd(struct ft1000_device *dev, u16 *pbuffer,
 				      FT1000_REG_DPRAM_ADDR);
 		ret =
 		    ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAH);
-		//DEBUG("ft1000_hw:received data = 0x%x\n", *pbuffer);
 		pbuffer++;
 		ft1000_write_register(dev, FT1000_DPRAM_MAG_RX_BASE + 1,
 				      FT1000_REG_DPRAM_ADDR);
@@ -1412,11 +1350,11 @@ static bool ft1000_receive_cmd(struct ft1000_device *dev, u16 *pbuffer,
 		/* copy odd aligned word */
 		ret =
 		    ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAL);
-		//DEBUG("ft1000_hw:received data = 0x%x\n", *pbuffer);
+
 		pbuffer++;
 		ret =
 		    ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAH);
-		//DEBUG("ft1000_hw:received data = 0x%x\n", *pbuffer);
+
 		pbuffer++;
 		if (size & 0x0001) {
 			/* copy odd byte from fifo */
@@ -1495,10 +1433,8 @@ static int ft1000_dsp_prov(void *arg)
 			ppseudo_hdr->portsrc = 0;
 			/* Calculate new checksum */
 			ppseudo_hdr->checksum = *pmsg++;
-			//DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum);
 			for (i = 1; i < 7; i++) {
 				ppseudo_hdr->checksum ^= *pmsg++;
-				//DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum);
 			}
 
 			TempShortBuf[0] = 0;
@@ -1582,21 +1518,16 @@ static int ft1000_proc_drvmsg(struct ft1000_device *dev, u16 size)
 					DEBUG("Media is up\n");
 					if (info->mediastate == 0) {
 						if (info->NetDevRegDone) {
-							//netif_carrier_on(dev->net);//mbelian
 							netif_wake_queue(dev->
 									 net);
 						}
 						info->mediastate = 1;
-						/*do_gettimeofday(&tv);
-						   info->ConTm = tv.tv_sec; *///mbelian
 					}
 				} else {
 					DEBUG("Media is down\n");
 					if (info->mediastate == 1) {
 						info->mediastate = 0;
 						if (info->NetDevRegDone) {
-							//netif_carrier_off(dev->net); mbelian
-							//netif_stop_queue(dev->net);
 						}
 						info->ConTm = 0;
 					}
@@ -1605,10 +1536,6 @@ static int ft1000_proc_drvmsg(struct ft1000_device *dev, u16 size)
 				DEBUG("Media is down\n");
 				if (info->mediastate == 1) {
 					info->mediastate = 0;
-					if (info->NetDevRegDone) {
-						//netif_carrier_off(dev->net); //mbelian
-						//netif_stop_queue(dev->net);
-					}
 					info->ConTm = 0;
 				}
 			}
@@ -1860,31 +1787,26 @@ int ft1000_poll(void* dev_id) {
 	struct pseudo_hdr *ppseudo_hdr;
     unsigned long flags;
 
-    //DEBUG("Enter ft1000_poll...\n");
     if (ft1000_chkcard(dev) == FALSE) {
         DEBUG("ft1000_poll::ft1000_chkcard: failed\n");
         return STATUS_FAILURE;
     }
 
     status = ft1000_read_register (dev, &tempword, FT1000_REG_DOORBELL);
-   // DEBUG("ft1000_poll: read FT1000_REG_DOORBELL message 0x%x\n", tempword);
 
     if ( !status )
     {
 
         if (tempword & FT1000_DB_DPRAM_RX) {
-            //DEBUG("ft1000_poll: FT1000_REG_DOORBELL message type:  FT1000_DB_DPRAM_RX\n");
 
             status = ft1000_read_dpram16(dev, 0x200, (u8 *)&data, 0);
-            //DEBUG("ft1000_poll:FT1000_DB_DPRAM_RX:ft1000_read_dpram16:size = 0x%x\n", data);
-            size = ntohs(data) + 16 + 2; //wai
+            size = ntohs(data) + 16 + 2;
             if (size % 4) {
                 modulo = 4 - (size % 4);
                 size = size + modulo;
             }
             status = ft1000_read_dpram16(dev, 0x201, (u8 *)&portid, 1);
             portid &= 0xff;
-            //DEBUG("ft1000_poll: FT1000_REG_DOORBELL message type: FT1000_DB_DPRAM_RX : portid 0x%x\n", portid);
 
             if (size < MAX_CMD_SQSIZE) {
                 switch (portid)
@@ -1899,13 +1821,11 @@ int ft1000_poll(void* dev_id) {
                     case DSPBCMSGID:
                         // This is a dsp broadcast message
                         // Check which application has registered for dsp broadcast messages
-                        //DEBUG("ft1000_poll: FT1000_REG_DOORBELL message type: FT1000_DB_DPRAM_RX : portid DSPBCMSGID\n");
 
     	    	        for (i=0; i<MAX_NUM_APP; i++) {
         	           if ( (info->app_info[i].DspBCMsgFlag) && (info->app_info[i].fileobject) &&
                                          (info->app_info[i].NumOfMsg < MAX_MSG_LIMIT)  )
 			   {
-			       //DEBUG("Dsp broadcast message detected for app id %d\n", i);
 			       nxtph = FT1000_DPRAM_RX_BASE + 2;
 			       pdpram_blk = ft1000_get_buffer (&freercvpool);
 			       if (pdpram_blk != NULL) {
@@ -1929,15 +1849,13 @@ int ft1000_poll(void* dev_id) {
                                else {
                                    DEBUG("Out of memory in free receive command pool\n");
                                    info->app_info[i].nRxMsgMiss++;
-                               }//endof if (pdpram_blk != NULL)
-                           }//endof if
-    		           //else
-    		           //    DEBUG("app_info mismatch\n");
-	                }// endof for
+                               }
+                           }
+	                }
                         break;
                     default:
                         pdpram_blk = ft1000_get_buffer (&freercvpool);
-                        //DEBUG("Memory allocated = 0x%8x\n", (u32)pdpram_blk);
+
                         if (pdpram_blk != NULL) {
                            if ( ft1000_receive_cmd(dev, pdpram_blk->pbuffer, MAX_CMD_SQSIZE, &nxtph) ) {
 				ppseudo_hdr = (struct pseudo_hdr *)pdpram_blk->pbuffer;
@@ -1961,11 +1879,8 @@ int ft1000_poll(void* dev_id) {
                                    else {
                                        info->app_info[i].nRxMsg++;
                                        // Put message into the appropriate application block
-                                       //pxu spin_lock_irqsave(&free_buff_lock, flags);
                                        list_add_tail(&pdpram_blk->list, &info->app_info[i].app_sqlist);
             			       info->app_info[i].NumOfMsg++;
-                                       //pxu spin_unlock_irqrestore(&free_buff_lock, flags);
-                                       //pxu wake_up_interruptible(&info->app_info[i].wait_dpram_msg);
                                    }
                                }
                            }
@@ -1978,15 +1893,14 @@ int ft1000_poll(void* dev_id) {
                             DEBUG("Out of memory in free receive command pool\n");
                         }
                         break;
-                } //end of switch
-            } //endof if (size < MAX_CMD_SQSIZE)
+                }
+            }
             else {
                 DEBUG("FT1000:dpc:Invalid total length for SlowQ = %d\n", size);
             }
             status = ft1000_write_register (dev, FT1000_DB_DPRAM_RX, FT1000_REG_DOORBELL);
         }
         else if (tempword & FT1000_DSP_ASIC_RESET) {
-            //DEBUG("ft1000_poll: FT1000_REG_DOORBELL message type:  FT1000_DSP_ASIC_RESET\n");
 
             // Let's reset the ASIC from the Host side as well
             status = ft1000_write_register (dev, ASIC_RESET_BIT, FT1000_REG_RESET);
@@ -2025,10 +1939,8 @@ int ft1000_poll(void* dev_id) {
         }
         else if (tempword & FT1000_DB_COND_RESET) {
             DEBUG("ft1000_poll: FT1000_REG_DOORBELL message type:  FT1000_DB_COND_RESET\n");
-//By Jim
-// Reset ASIC and DSP
-//MAG
-            if (info->fAppMsgPend == 0) {
+
+	    if (info->fAppMsgPend == 0) {
                // Reset ASIC and DSP
 
                 status    = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER0, (u8 *)&(info->DSP_TIME[0]), FT1000_MAG_DSP_TIMER0_INDX);
@@ -2048,11 +1960,8 @@ int ft1000_poll(void* dev_id) {
             ft1000_write_register(dev, FT1000_DB_COND_RESET, FT1000_REG_DOORBELL);
         }
 
-    }//endof if ( !status )
+    }
 
-    //DEBUG("return from ft1000_poll.\n");
     return STATUS_SUCCESS;
 
 }
-
-/*end of Jim*/
-- 
1.7.1

