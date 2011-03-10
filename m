Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab1CJK4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:56:35 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52950 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab1CJKvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:51:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=seYxkKnUe/mOx8yVhSUJOGaleTj6tYkaVA9cJzJ6J8APVFKSpcc/JMCEouLicGN5Sn
         c93igolfZGkDF55K2oR3j1/1qH1sZvOxIeI50Jspn/RD15Wmo+ia8NjTZ7VbJunCufNe
         A/hxzThkStanQ2Asw5g4sKIznFC+r/1tY7Cxk=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 02/21] staging: ft1000: Fix coding style in card_send_command function.
Date: Thu, 10 Mar 2011 11:51:16 +0100
Message-Id: <1299754295-8493-3-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   60 +++++++++++-------------
 1 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 293a469..ded13f2 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -481,51 +481,47 @@ static void card_reset_dsp(struct ft1000_device *ft1000dev, bool value)
 // Notes:
 //
 //---------------------------------------------------------------------------
-void card_send_command(struct ft1000_device *ft1000dev, void *ptempbuffer, int size)
+void card_send_command(struct ft1000_device *ft1000dev, void *ptempbuffer,
+		       int size)
 {
-    unsigned short temp;
-    unsigned char *commandbuf;
+	unsigned short temp;
+	unsigned char *commandbuf;
 
-    DEBUG("card_send_command: enter card_send_command... size=%d\n", size);
+	DEBUG("card_send_command: enter card_send_command... size=%d\n", size);
 
-    commandbuf =(unsigned char*) kmalloc(size+2, GFP_KERNEL);
-    memcpy((void*)commandbuf+2, (void*)ptempbuffer, size);
+	commandbuf = (unsigned char *)kmalloc(size + 2, GFP_KERNEL);
+	memcpy((void *)commandbuf + 2, (void *)ptempbuffer, size);
 
-    //DEBUG("card_send_command: Command Send\n");
+	//DEBUG("card_send_command: Command Send\n");
 
-    ft1000_read_register(ft1000dev, &temp, FT1000_REG_DOORBELL);
+	ft1000_read_register(ft1000dev, &temp, FT1000_REG_DOORBELL);
 
-    if (temp & 0x0100)
-    {
-       msleep(10);
-    }
+	if (temp & 0x0100)
+		msleep(10);
 
-    // check for odd word
-    size = size + 2;
-    if (size % 4)
-    {
-       // Must force to be 32 bit aligned
-       size += 4 - (size % 4);
-    }
+	/* check for odd word */
+	size = size + 2;
 
+	/* Must force to be 32 bit aligned */
+	if (size % 4)
+		size += 4 - (size % 4);
 
-    //DEBUG("card_send_command: write dpram ... size=%d\n", size);
-    ft1000_write_dpram32(ft1000dev, 0,commandbuf, size);
-    msleep(1);
-    //DEBUG("card_send_command: write into doorbell ...\n");
-    ft1000_write_register(ft1000dev,  FT1000_DB_DPRAM_TX ,FT1000_REG_DOORBELL) ;
-    msleep(1);
+	//DEBUG("card_send_command: write dpram ... size=%d\n", size);
+	ft1000_write_dpram32(ft1000dev, 0, commandbuf, size);
+	msleep(1);
+	//DEBUG("card_send_command: write into doorbell ...\n");
+	ft1000_write_register(ft1000dev, FT1000_DB_DPRAM_TX,
+			      FT1000_REG_DOORBELL);
+	msleep(1);
 
-    ft1000_read_register(ft1000dev, &temp, FT1000_REG_DOORBELL);
-    //DEBUG("card_send_command: read doorbell ...temp=%x\n", temp);
-    if ( (temp & 0x0100) == 0)
-    {
-       //DEBUG("card_send_command: Message sent\n");
-    }
+	ft1000_read_register(ft1000dev, &temp, FT1000_REG_DOORBELL);
+	//DEBUG("card_send_command: read doorbell ...temp=%x\n", temp);
+	if ((temp & 0x0100) == 0) {
+		//DEBUG("card_send_command: Message sent\n");
+	}
 
 }
 
-
 //--------------------------------------------------------------------------
 //
 //  Function:   dsp_reload
-- 
1.7.1

