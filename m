Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab1FVSkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:40:49 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:55994 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932270Ab1FVSkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:40:47 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Subject: [4/15] staging: ft1000-pcmcia: remove DRVMSG typedefs
Date: Wed, 22 Jun 2011 20:40:38 +0200
User-Agent: KMail/1.9.10
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106222040.40613.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove DRVMSG typedefs.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -285,12 +285,12 @@ struct pseudo_hdr
 
 #define MAXIMUM_ASIC_HB_CNT      15
 
-typedef struct _DRVMSG {
+struct drv_msg {
 	struct pseudo_hdr pseudo;
 	u16 type;
 	u16 length;
 	u8  data[0];
-} __attribute__ ((packed)) DRVMSG, *PDRVMSG;
+} __attribute__ ((packed));
 
 typedef struct _MEDIAMSG {
 	struct pseudo_hdr pseudo;
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -328,7 +328,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 	PDSP_IMAGE_INFO_V6 pDspImageInfoV6 = NULL;
 	long requested_version;
 	BOOLEAN bGoodVersion = 0;
-	PDRVMSG pMailBoxData;
+	struct drv_msg *pMailBoxData;
 	USHORT *pUsData = NULL;
 	USHORT *pUsFile = NULL;
 	UCHAR *pUcFile = NULL;
@@ -605,7 +605,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 						(long)(info->DSPInfoBlklen + 1) / 2;
 					put_request_value(dev, word_length);
 					pMailBoxData =
-						(PDRVMSG) & info->DSPInfoBlk[0];
+						(struct drv_msg *) & info->DSPInfoBlk[0];
 					pUsData =
 						(USHORT *) & pMailBoxData->data[0];
 					// Provide mutual exclusive access while reading ASIC registers.
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -1017,7 +1017,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 	u16 tempword;
 	PMEDIAMSG pmediamsg;
 	PDSPINITMSG pdspinitmsg;
-	PDRVMSG pdrvmsg;
+	struct drv_msg *pdrvmsg;
 	u16 len;
 	u16 i;
 	PPROV_RECORD ptr;
@@ -1038,7 +1038,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
     if ( ft1000_receive_cmd(dev, &cmdbuffer[0], MAX_CMD_SQSIZE, &tempword) ) {
 
 		// Get the message type which is total_len + PSEUDO header + msgtype + message body
-		pdrvmsg = (PDRVMSG) & cmdbuffer[0];
+		pdrvmsg = (struct drv_msg *) & cmdbuffer[0];
 		msgtype = ntohs(pdrvmsg->type);
 		DEBUG(1, "Command message type = 0x%x\n", msgtype);
 		switch (msgtype) {

-- 
Ondrej Zary
