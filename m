Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab1FVSlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:41:25 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:34253 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758604Ab1FVSlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:41:22 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Subject: [7/15] staging: ft1000-pcmcia: remove DSPINITMSG typedefs
Date: Wed, 22 Jun 2011 20:41:13 +0200
User-Agent: KMail/1.9.10
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106222041.15807.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove DSPINITMSG typedefs.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -304,7 +304,7 @@ struct media_msg {
 	u32 dns_2;
 } __attribute__ ((packed));
 
-typedef struct _DSPINITMSG {
+struct dsp_init_msg {
     struct pseudo_hdr pseudo;
     u16 type;
     u16 length;
@@ -315,7 +315,7 @@ typedef struct _DSPINITMSG {
     u8 ProductMode[MODESZ];     // Product Mode (Market/Production)
     u8 RfCalVer[CALVERSZ];      // Rf Calibration version
     u8 RfCalDate[CALDATESZ];    // Rf Calibration date
-} __attribute__ ((packed)) DSPINITMSG, *PDSPINITMSG;
+} __attribute__ ((packed));
 
 typedef struct _DSPHIBERNATE {
 	struct pseudo_hdr pseudo;
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -1016,7 +1016,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 	u16 msgtype;
 	u16 tempword;
 	struct media_msg *pmediamsg;
-	PDSPINITMSG pdspinitmsg;
+	struct dsp_init_msg *pdspinitmsg;
 	struct drv_msg *pdrvmsg;
 	u16 len;
 	u16 i;
@@ -1122,7 +1122,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
             }
 			break;
 		case DSP_INIT_MSG:
-			pdspinitmsg = (PDSPINITMSG) & cmdbuffer[0];
+			pdspinitmsg = (struct dsp_init_msg *) & cmdbuffer[0];
 			memcpy(info->DspVer, pdspinitmsg->DspVer, DSPVERSZ);
 			DEBUG(1, "DSPVER = 0x%2x 0x%2x 0x%2x 0x%2x\n",
 				  info->DspVer[0], info->DspVer[1], info->DspVer[2],
@@ -1139,7 +1139,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 			dev->dev_addr[5] = info->eui64[7];
 
 			if (ntohs(pdspinitmsg->length) ==
-				(sizeof(DSPINITMSG) - 20)) {
+				(sizeof(struct dsp_init_msg) - 20)) {
 				memcpy(info->ProductMode,
 					   pdspinitmsg->ProductMode, MODESZ);
 				memcpy(info->RfCalVer, pdspinitmsg->RfCalVer,

-- 
Ondrej Zary
