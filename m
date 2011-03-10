Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1CJKws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:52:48 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46557 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab1CJKwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:52:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=aNhBbHpE9aheBLckj+/12oDIuRH31zG/KMHpQxNgNWDH5IOip5Dn2tlaaQ66TJuor5
         1zWlD/HCovKI7/AvRw+6dyjJHcfbHE+SNrpN2d6m79jC21cfMlDPdN/CF42NxOIuomV5
         7eprjtUxONXX7q2CdccL7aTgJsrNxJ6qt7Smk=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 21/21] staging: ft1000: Fix coding style in ft1000_proc_drvmsg function.
Date: Thu, 10 Mar 2011 11:51:35 +0100
Message-Id: <1299754295-8493-22-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |  566 +++++++++++++------------
 1 files changed, 299 insertions(+), 267 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 0187758..78dcd49 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1530,286 +1530,318 @@ static int ft1000_dsp_prov(void *arg)
 	return STATUS_SUCCESS;
 }
 
-static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
+static int ft1000_proc_drvmsg(struct ft1000_device *dev, u16 size)
+{
 	struct ft1000_info *info = netdev_priv(dev->net);
-    u16 msgtype;
-    u16 tempword;
+	u16 msgtype;
+	u16 tempword;
 	struct media_msg *pmediamsg;
 	struct dsp_init_msg *pdspinitmsg;
 	struct drv_msg *pdrvmsg;
-    u16 i;
+	u16 i;
 	struct pseudo_hdr *ppseudo_hdr;
-    u16 *pmsg;
-    u16 status;
-    union {
-        u8  byte[2];
-        u16 wrd;
-    } convert;
-
-
-    char *cmdbuffer = kmalloc(1600, GFP_KERNEL);
-    if (!cmdbuffer)
-	return STATUS_FAILURE;
-
-    status = ft1000_read_dpram32(dev, 0x200, cmdbuffer, size);
+	u16 *pmsg;
+	u16 status;
+	union {
+		u8 byte[2];
+		u16 wrd;
+	} convert;
 
+	char *cmdbuffer = kmalloc(1600, GFP_KERNEL);
+	if (!cmdbuffer)
+		return STATUS_FAILURE;
 
+	status = ft1000_read_dpram32(dev, 0x200, cmdbuffer, size);
 
 #ifdef JDEBUG
-        DEBUG("ft1000_proc_drvmsg:cmdbuffer\n");
-        for(i = 0; i < size; i+=5)
-        {
-            if( (i + 5) < size )
-                DEBUG("0x%x, 0x%x, 0x%x, 0x%x, 0x%x\n", cmdbuffer[i], cmdbuffer[i+1], cmdbuffer[i+2], cmdbuffer[i+3], cmdbuffer[i+4]);
-            else
-            {
-                for (j = i; j < size; j++)
-                DEBUG("0x%x ", cmdbuffer[j]);
-                DEBUG("\n");
-                break;
-            }
-        }
+	DEBUG("ft1000_proc_drvmsg:cmdbuffer\n");
+	for (i = 0; i < size; i += 5) {
+		if ((i + 5) < size)
+			DEBUG("0x%x, 0x%x, 0x%x, 0x%x, 0x%x\n", cmdbuffer[i],
+			      cmdbuffer[i + 1], cmdbuffer[i + 2],
+			      cmdbuffer[i + 3], cmdbuffer[i + 4]);
+		else {
+			for (j = i; j < size; j++)
+				DEBUG("0x%x ", cmdbuffer[j]);
+			DEBUG("\n");
+			break;
+		}
+	}
 #endif
 	pdrvmsg = (struct drv_msg *)&cmdbuffer[2];
-        msgtype = ntohs(pdrvmsg->type);
-        DEBUG("ft1000_proc_drvmsg:Command message type = 0x%x\n", msgtype);
-        switch (msgtype) {
-            case MEDIA_STATE: {
-                DEBUG("ft1000_proc_drvmsg:Command message type = MEDIA_STATE");
-
-		pmediamsg = (struct media_msg *)&cmdbuffer[0];
-                if (info->ProgConStat != 0xFF) {
-                    if (pmediamsg->state) {
-                        DEBUG("Media is up\n");
-                        if (info->mediastate == 0) {
-                            if ( info->NetDevRegDone )
-                            {
-                                //netif_carrier_on(dev->net);//mbelian
-                                netif_wake_queue(dev->net);
-                            }
-                            info->mediastate = 1;
-                            /*do_gettimeofday(&tv);
-                            info->ConTm = tv.tv_sec;*/ //mbelian
-                        }
-                    }
-                    else {
-                        DEBUG("Media is down\n");
-                        if (info->mediastate == 1) {
-                            info->mediastate = 0;
-                            if ( info->NetDevRegDone )
-                            {
-                                //netif_carrier_off(dev->net); mbelian
-                                //netif_stop_queue(dev->net);
-                            }
-                            info->ConTm = 0;
-                        }
-                    }
-                }
-                else {
-                    DEBUG("Media is down\n");
-                    if (info->mediastate == 1) {
-                        info->mediastate = 0;
-                        if ( info->NetDevRegDone)
-                        {
-                            //netif_carrier_off(dev->net); //mbelian
-                            //netif_stop_queue(dev->net);
-                        }
-                        info->ConTm = 0;
-                    }
-                }
-                break;
-            }
-            case DSP_INIT_MSG: {
-                DEBUG("ft1000_proc_drvmsg:Command message type = DSP_INIT_MSG");
-
-		pdspinitmsg = (struct dsp_init_msg *)&cmdbuffer[2];
-                memcpy(info->DspVer, pdspinitmsg->DspVer, DSPVERSZ);
-                DEBUG("DSPVER = 0x%2x 0x%2x 0x%2x 0x%2x\n", info->DspVer[0], info->DspVer[1], info->DspVer[2], info->DspVer[3]);
-                memcpy(info->HwSerNum, pdspinitmsg->HwSerNum, HWSERNUMSZ);
-                memcpy(info->Sku, pdspinitmsg->Sku, SKUSZ);
-                memcpy(info->eui64, pdspinitmsg->eui64, EUISZ);
-                DEBUG("EUI64=%2x.%2x.%2x.%2x.%2x.%2x.%2x.%2x\n", info->eui64[0],info->eui64[1], info->eui64[2], info->eui64[3], info->eui64[4], info->eui64[5],info->eui64[6], info->eui64[7]);
-                dev->net->dev_addr[0] = info->eui64[0];
-                dev->net->dev_addr[1] = info->eui64[1];
-                dev->net->dev_addr[2] = info->eui64[2];
-                dev->net->dev_addr[3] = info->eui64[5];
-                dev->net->dev_addr[4] = info->eui64[6];
-                dev->net->dev_addr[5] = info->eui64[7];
-
-		if (ntohs(pdspinitmsg->length) == (sizeof(struct dsp_init_msg) - 20)) {
-                    memcpy(info->ProductMode, pdspinitmsg->ProductMode, MODESZ);
-                    memcpy(info->RfCalVer, pdspinitmsg->RfCalVer, CALVERSZ);
-                    memcpy(info->RfCalDate, pdspinitmsg->RfCalDate, CALDATESZ);
-                    DEBUG("RFCalVer = 0x%2x 0x%2x\n", info->RfCalVer[0], info->RfCalVer[1]);
-                }
-                break;
-            }
-            case DSP_PROVISION: {
-                DEBUG("ft1000_proc_drvmsg:Command message type = DSP_PROVISION\n");
+	msgtype = ntohs(pdrvmsg->type);
+	DEBUG("ft1000_proc_drvmsg:Command message type = 0x%x\n", msgtype);
+	switch (msgtype) {
+	case MEDIA_STATE:{
+			DEBUG
+			    ("ft1000_proc_drvmsg:Command message type = MEDIA_STATE");
+
+			pmediamsg = (struct media_msg *)&cmdbuffer[0];
+			if (info->ProgConStat != 0xFF) {
+				if (pmediamsg->state) {
+					DEBUG("Media is up\n");
+					if (info->mediastate == 0) {
+						if (info->NetDevRegDone) {
+							//netif_carrier_on(dev->net);//mbelian
+							netif_wake_queue(dev->
+									 net);
+						}
+						info->mediastate = 1;
+						/*do_gettimeofday(&tv);
+						   info->ConTm = tv.tv_sec; *///mbelian
+					}
+				} else {
+					DEBUG("Media is down\n");
+					if (info->mediastate == 1) {
+						info->mediastate = 0;
+						if (info->NetDevRegDone) {
+							//netif_carrier_off(dev->net); mbelian
+							//netif_stop_queue(dev->net);
+						}
+						info->ConTm = 0;
+					}
+				}
+			} else {
+				DEBUG("Media is down\n");
+				if (info->mediastate == 1) {
+					info->mediastate = 0;
+					if (info->NetDevRegDone) {
+						//netif_carrier_off(dev->net); //mbelian
+						//netif_stop_queue(dev->net);
+					}
+					info->ConTm = 0;
+				}
+			}
+			break;
+		}
+	case DSP_INIT_MSG:{
+			DEBUG
+			    ("ft1000_proc_drvmsg:Command message type = DSP_INIT_MSG");
+
+			pdspinitmsg = (struct dsp_init_msg *)&cmdbuffer[2];
+			memcpy(info->DspVer, pdspinitmsg->DspVer, DSPVERSZ);
+			DEBUG("DSPVER = 0x%2x 0x%2x 0x%2x 0x%2x\n",
+			      info->DspVer[0], info->DspVer[1], info->DspVer[2],
+			      info->DspVer[3]);
+			memcpy(info->HwSerNum, pdspinitmsg->HwSerNum,
+			       HWSERNUMSZ);
+			memcpy(info->Sku, pdspinitmsg->Sku, SKUSZ);
+			memcpy(info->eui64, pdspinitmsg->eui64, EUISZ);
+			DEBUG("EUI64=%2x.%2x.%2x.%2x.%2x.%2x.%2x.%2x\n",
+			      info->eui64[0], info->eui64[1], info->eui64[2],
+			      info->eui64[3], info->eui64[4], info->eui64[5],
+			      info->eui64[6], info->eui64[7]);
+			dev->net->dev_addr[0] = info->eui64[0];
+			dev->net->dev_addr[1] = info->eui64[1];
+			dev->net->dev_addr[2] = info->eui64[2];
+			dev->net->dev_addr[3] = info->eui64[5];
+			dev->net->dev_addr[4] = info->eui64[6];
+			dev->net->dev_addr[5] = info->eui64[7];
+
+			if (ntohs(pdspinitmsg->length) ==
+			    (sizeof(struct dsp_init_msg) - 20)) {
+				memcpy(info->ProductMode,
+				       pdspinitmsg->ProductMode, MODESZ);
+				memcpy(info->RfCalVer, pdspinitmsg->RfCalVer,
+				       CALVERSZ);
+				memcpy(info->RfCalDate, pdspinitmsg->RfCalDate,
+				       CALDATESZ);
+				DEBUG("RFCalVer = 0x%2x 0x%2x\n",
+				      info->RfCalVer[0], info->RfCalVer[1]);
+			}
+			break;
+		}
+	case DSP_PROVISION:{
+			DEBUG
+			    ("ft1000_proc_drvmsg:Command message type = DSP_PROVISION\n");
+
+			/* kick off dspprov routine to start provisioning
+			 * Send provisioning data to DSP
+			 */
+			if (list_empty(&info->prov_list) == 0) {
+				info->fProvComplete = 0;
+				status = ft1000_dsp_prov(dev);
+				if (status != STATUS_SUCCESS)
+					goto out;
+			} else {
+				info->fProvComplete = 1;
+				status =
+				    ft1000_write_register(dev, FT1000_DB_HB,
+							  FT1000_REG_DOORBELL);
+				DEBUG
+				    ("FT1000:drivermsg:No more DSP provisioning data in dsp image\n");
+			}
+			DEBUG("ft1000_proc_drvmsg:DSP PROVISION is done\n");
+			break;
+		}
+	case DSP_STORE_INFO:{
+			DEBUG
+			    ("ft1000_proc_drvmsg:Command message type = DSP_STORE_INFO");
+
+			DEBUG("FT1000:drivermsg:Got DSP_STORE_INFO\n");
+			tempword = ntohs(pdrvmsg->length);
+			info->DSPInfoBlklen = tempword;
+			if (tempword < (MAX_DSP_SESS_REC - 4)) {
+				pmsg = (u16 *) &pdrvmsg->data[0];
+				for (i = 0; i < ((tempword + 1) / 2); i++) {
+					DEBUG
+					    ("FT1000:drivermsg:dsp info data = 0x%x\n",
+					     *pmsg);
+					info->DSPInfoBlk[i + 10] = *pmsg++;
+				}
+			} else {
+				info->DSPInfoBlklen = 0;
+			}
+			break;
+		}
+	case DSP_GET_INFO:{
+			DEBUG("FT1000:drivermsg:Got DSP_GET_INFO\n");
+			/* copy dsp info block to dsp */
+			info->DrvMsgPend = 1;
+			/* allow any outstanding ioctl to finish */
+			mdelay(10);
+			status =
+			    ft1000_read_register(dev, &tempword,
+						 FT1000_REG_DOORBELL);
+			if (tempword & FT1000_DB_DPRAM_TX) {
+				mdelay(10);
+				status =
+				    ft1000_read_register(dev, &tempword,
+							 FT1000_REG_DOORBELL);
+				if (tempword & FT1000_DB_DPRAM_TX) {
+					mdelay(10);
+					status =
+					    ft1000_read_register(dev, &tempword,
+								 FT1000_REG_DOORBELL);
+					if (tempword & FT1000_DB_DPRAM_TX)
+						break;
+				}
+			}
+			/* Put message into Slow Queue
+			 * Form Pseudo header
+			 */
+			pmsg = (u16 *) info->DSPInfoBlk;
+			*pmsg++ = 0;
+			*pmsg++ =
+			    htons(info->DSPInfoBlklen + 20 +
+				  info->DSPInfoBlklen);
+			ppseudo_hdr =
+			    (struct pseudo_hdr *)(u16 *) &info->DSPInfoBlk[2];
+			ppseudo_hdr->length =
+			    htons(info->DSPInfoBlklen + 4 +
+				  info->DSPInfoBlklen);
+			ppseudo_hdr->source = 0x10;
+			ppseudo_hdr->destination = 0x20;
+			ppseudo_hdr->portdest = 0;
+			ppseudo_hdr->portsrc = 0;
+			ppseudo_hdr->sh_str_id = 0;
+			ppseudo_hdr->control = 0;
+			ppseudo_hdr->rsvd1 = 0;
+			ppseudo_hdr->rsvd2 = 0;
+			ppseudo_hdr->qos_class = 0;
+			/* Insert slow queue sequence number */
+			ppseudo_hdr->seq_num = info->squeseqnum++;
+			/* Insert application id */
+			ppseudo_hdr->portsrc = 0;
+			/* Calculate new checksum */
+			ppseudo_hdr->checksum = *pmsg++;
+			for (i = 1; i < 7; i++)
+				ppseudo_hdr->checksum ^= *pmsg++;
 
-                // kick off dspprov routine to start provisioning
-                // Send provisioning data to DSP
-                if (list_empty(&info->prov_list) == 0)
-                {
-		    info->fProvComplete = 0;
-		    status = ft1000_dsp_prov(dev);
-		    if (status != STATUS_SUCCESS)
-		        goto out;
-                }
-                else {
-                    info->fProvComplete = 1;
-                    status = ft1000_write_register (dev, FT1000_DB_HB, FT1000_REG_DOORBELL);
-                    DEBUG("FT1000:drivermsg:No more DSP provisioning data in dsp image\n");
-                }
-                DEBUG("ft1000_proc_drvmsg:DSP PROVISION is done\n");
-                break;
-            }
-            case DSP_STORE_INFO: {
-                DEBUG("ft1000_proc_drvmsg:Command message type = DSP_STORE_INFO");
-
-                DEBUG("FT1000:drivermsg:Got DSP_STORE_INFO\n");
-                tempword = ntohs(pdrvmsg->length);
-                info->DSPInfoBlklen = tempword;
-                if (tempword < (MAX_DSP_SESS_REC-4) ) {
-                    pmsg = (u16 *)&pdrvmsg->data[0];
-                    for (i=0; i<((tempword+1)/2); i++) {
-                        DEBUG("FT1000:drivermsg:dsp info data = 0x%x\n", *pmsg);
-                        info->DSPInfoBlk[i+10] = *pmsg++;
-                    }
-                }
-                else {
-                    info->DSPInfoBlklen = 0;
-                }
-                break;
-            }
-            case DSP_GET_INFO: {
-                DEBUG("FT1000:drivermsg:Got DSP_GET_INFO\n");
-                // copy dsp info block to dsp
-                info->DrvMsgPend = 1;
-                // allow any outstanding ioctl to finish
-                mdelay(10);
-                status = ft1000_read_register(dev, &tempword, FT1000_REG_DOORBELL);
-                if (tempword & FT1000_DB_DPRAM_TX) {
-                    mdelay(10);
-                    status = ft1000_read_register(dev, &tempword, FT1000_REG_DOORBELL);
-                    if (tempword & FT1000_DB_DPRAM_TX) {
-                        mdelay(10);
-                            status = ft1000_read_register(dev, &tempword, FT1000_REG_DOORBELL);
-                            if (tempword & FT1000_DB_DPRAM_TX) {
-                                break;
-                            }
-                    }
-                }
-
-                // Put message into Slow Queue
-                // Form Pseudo header
-                pmsg = (u16 *)info->DSPInfoBlk;
-                *pmsg++ = 0;
-                *pmsg++ = htons(info->DSPInfoBlklen+20+info->DSPInfoBlklen);
-		ppseudo_hdr = (struct pseudo_hdr *)(u16 *)&info->DSPInfoBlk[2];
-                ppseudo_hdr->length = htons(info->DSPInfoBlklen+4+info->DSPInfoBlklen);
-                ppseudo_hdr->source = 0x10;
-                ppseudo_hdr->destination = 0x20;
-                ppseudo_hdr->portdest = 0;
-                ppseudo_hdr->portsrc = 0;
-                ppseudo_hdr->sh_str_id = 0;
-                ppseudo_hdr->control = 0;
-                ppseudo_hdr->rsvd1 = 0;
-                ppseudo_hdr->rsvd2 = 0;
-                ppseudo_hdr->qos_class = 0;
-                // Insert slow queue sequence number
-                ppseudo_hdr->seq_num = info->squeseqnum++;
-                // Insert application id
-                ppseudo_hdr->portsrc = 0;
-                // Calculate new checksum
-                ppseudo_hdr->checksum = *pmsg++;
-                for (i=1; i<7; i++) {
-                    ppseudo_hdr->checksum ^= *pmsg++;
-                }
-                info->DSPInfoBlk[10] = 0x7200;
-                info->DSPInfoBlk[11] = htons(info->DSPInfoBlklen);
-                status = ft1000_write_dpram32 (dev, 0, (u8 *)&info->DSPInfoBlk[0], (unsigned short)(info->DSPInfoBlklen+22));
-                status = ft1000_write_register (dev, FT1000_DB_DPRAM_TX, FT1000_REG_DOORBELL);
-                info->DrvMsgPend = 0;
-
-                break;
-            }
+			info->DSPInfoBlk[10] = 0x7200;
+			info->DSPInfoBlk[11] = htons(info->DSPInfoBlklen);
+			status =
+			    ft1000_write_dpram32(dev, 0,
+						 (u8 *) &info->DSPInfoBlk[0],
+						 (unsigned short)(info->
+								  DSPInfoBlklen
+								  + 22));
+			status =
+			    ft1000_write_register(dev, FT1000_DB_DPRAM_TX,
+						  FT1000_REG_DOORBELL);
+			info->DrvMsgPend = 0;
 
-          case GET_DRV_ERR_RPT_MSG: {
-              DEBUG("FT1000:drivermsg:Got GET_DRV_ERR_RPT_MSG\n");
-              // copy driver error message to dsp
-              info->DrvMsgPend = 1;
-              // allow any outstanding ioctl to finish
-              mdelay(10);
-              status = ft1000_read_register(dev, &tempword, FT1000_REG_DOORBELL);
-              if (tempword & FT1000_DB_DPRAM_TX) {
-                  mdelay(10);
-                  status = ft1000_read_register(dev, &tempword, FT1000_REG_DOORBELL);
-                  if (tempword & FT1000_DB_DPRAM_TX) {
-                      mdelay(10);
-                  }
-              }
-
-              if ( (tempword & FT1000_DB_DPRAM_TX) == 0) {
-                  // Put message into Slow Queue
-                  // Form Pseudo header
-                  pmsg = (u16 *)&tempbuffer[0];
-			ppseudo_hdr = (struct pseudo_hdr *)pmsg;
-                  ppseudo_hdr->length = htons(0x0012);
-                  ppseudo_hdr->source = 0x10;
-                  ppseudo_hdr->destination = 0x20;
-                  ppseudo_hdr->portdest = 0;
-                  ppseudo_hdr->portsrc = 0;
-                  ppseudo_hdr->sh_str_id = 0;
-                  ppseudo_hdr->control = 0;
-                  ppseudo_hdr->rsvd1 = 0;
-                  ppseudo_hdr->rsvd2 = 0;
-                  ppseudo_hdr->qos_class = 0;
-                  // Insert slow queue sequence number
-                  ppseudo_hdr->seq_num = info->squeseqnum++;
-                  // Insert application id
-                  ppseudo_hdr->portsrc = 0;
-                  // Calculate new checksum
-                  ppseudo_hdr->checksum = *pmsg++;
-                  for (i=1; i<7; i++) {
-                      ppseudo_hdr->checksum ^= *pmsg++;
-                  }
-                  pmsg = (u16 *)&tempbuffer[16];
-                  *pmsg++ = htons(RSP_DRV_ERR_RPT_MSG);
-                  *pmsg++ = htons(0x000e);
-                  *pmsg++ = htons(info->DSP_TIME[0]);
-                  *pmsg++ = htons(info->DSP_TIME[1]);
-                  *pmsg++ = htons(info->DSP_TIME[2]);
-                  *pmsg++ = htons(info->DSP_TIME[3]);
-                  convert.byte[0] = info->DspVer[0];
-                  convert.byte[1] = info->DspVer[1];
-                  *pmsg++ = convert.wrd;
-                  convert.byte[0] = info->DspVer[2];
-                  convert.byte[1] = info->DspVer[3];
-                  *pmsg++ = convert.wrd;
-                  *pmsg++ = htons(info->DrvErrNum);
-
-                  card_send_command (dev, (unsigned char*)&tempbuffer[0], (u16)(0x0012 + PSEUDOSZ));
-                  info->DrvErrNum = 0;
-              }
-              info->DrvMsgPend = 0;
-
-          break;
-      }
-
-      default:
-          break;
-        }
+			break;
+		}
+
+	case GET_DRV_ERR_RPT_MSG:{
+			DEBUG("FT1000:drivermsg:Got GET_DRV_ERR_RPT_MSG\n");
+			/* copy driver error message to dsp */
+			info->DrvMsgPend = 1;
+			/* allow any outstanding ioctl to finish */
+			mdelay(10);
+			status =
+			    ft1000_read_register(dev, &tempword,
+						 FT1000_REG_DOORBELL);
+			if (tempword & FT1000_DB_DPRAM_TX) {
+				mdelay(10);
+				status =
+				    ft1000_read_register(dev, &tempword,
+							 FT1000_REG_DOORBELL);
+				if (tempword & FT1000_DB_DPRAM_TX)
+					mdelay(10);
+			}
 
+			if ((tempword & FT1000_DB_DPRAM_TX) == 0) {
+				/* Put message into Slow Queue
+				 * Form Pseudo header
+				 */
+				pmsg = (u16 *) &tempbuffer[0];
+				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
+				ppseudo_hdr->length = htons(0x0012);
+				ppseudo_hdr->source = 0x10;
+				ppseudo_hdr->destination = 0x20;
+				ppseudo_hdr->portdest = 0;
+				ppseudo_hdr->portsrc = 0;
+				ppseudo_hdr->sh_str_id = 0;
+				ppseudo_hdr->control = 0;
+				ppseudo_hdr->rsvd1 = 0;
+				ppseudo_hdr->rsvd2 = 0;
+				ppseudo_hdr->qos_class = 0;
+				/* Insert slow queue sequence number */
+				ppseudo_hdr->seq_num = info->squeseqnum++;
+				/* Insert application id */
+				ppseudo_hdr->portsrc = 0;
+				/* Calculate new checksum */
+				ppseudo_hdr->checksum = *pmsg++;
+				for (i = 1; i < 7; i++)
+					ppseudo_hdr->checksum ^= *pmsg++;
+
+				pmsg = (u16 *) &tempbuffer[16];
+				*pmsg++ = htons(RSP_DRV_ERR_RPT_MSG);
+				*pmsg++ = htons(0x000e);
+				*pmsg++ = htons(info->DSP_TIME[0]);
+				*pmsg++ = htons(info->DSP_TIME[1]);
+				*pmsg++ = htons(info->DSP_TIME[2]);
+				*pmsg++ = htons(info->DSP_TIME[3]);
+				convert.byte[0] = info->DspVer[0];
+				convert.byte[1] = info->DspVer[1];
+				*pmsg++ = convert.wrd;
+				convert.byte[0] = info->DspVer[2];
+				convert.byte[1] = info->DspVer[3];
+				*pmsg++ = convert.wrd;
+				*pmsg++ = htons(info->DrvErrNum);
+
+				card_send_command(dev,
+						 (unsigned char *)&tempbuffer[0],
+						 (u16) (0x0012 + PSEUDOSZ));
+				info->DrvErrNum = 0;
+			}
+			info->DrvMsgPend = 0;
 
-    status = STATUS_SUCCESS;
-out:
-    kfree(cmdbuffer);
-    DEBUG("return from ft1000_proc_drvmsg\n");
-    return status;
-}
+			break;
+		}
 
+	default:
+		break;
+	}
 
+	status = STATUS_SUCCESS;
+out:
+	kfree(cmdbuffer);
+	DEBUG("return from ft1000_proc_drvmsg\n");
+	return status;
+}
 
 int ft1000_poll(void* dev_id) {
 
-- 
1.7.1

