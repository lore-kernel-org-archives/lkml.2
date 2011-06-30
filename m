Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1F3WIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:08:31 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:35390 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753200Ab1F3WER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:04:17 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/28] staging: ft1000-pcmcia: remove MEDIAMSG typedefs
Date: Fri,  1 Jul 2011 00:03:36 +0200
Message-Id: <1309471437-12633-8-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
References: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove MEDIAMSG typedefs.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h    |    4 ++--
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
index 472b737..e4537e0 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -292,7 +292,7 @@ struct drv_msg {
 	u8  data[0];
 } __attribute__ ((packed));
 
-typedef struct _MEDIAMSG {
+struct media_msg {
 	struct pseudo_hdr pseudo;
 	u16 type;
 	u16 length;
@@ -302,7 +302,7 @@ typedef struct _MEDIAMSG {
 	u32 gateway;
 	u32 dns_1;
 	u32 dns_2;
-} __attribute__ ((packed)) MEDIAMSG, *PMEDIAMSG;
+} __attribute__ ((packed));
 
 typedef struct _TIMEMSG {
 	struct pseudo_hdr pseudo;
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 77ce8c4..ecc5319 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -1015,7 +1015,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 	FT1000_INFO *info = netdev_priv(dev);
 	u16 msgtype;
 	u16 tempword;
-	PMEDIAMSG pmediamsg;
+	struct media_msg *pmediamsg;
 	PDSPINITMSG pdspinitmsg;
 	struct drv_msg *pdrvmsg;
 	u16 len;
@@ -1090,7 +1090,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 			info->CardReady = 1;
 			break;
 		case MEDIA_STATE:
-			pmediamsg = (PMEDIAMSG) & cmdbuffer[0];
+			pmediamsg = (struct media_msg *) & cmdbuffer[0];
 			if (info->ProgConStat != 0xFF) {
 			if (pmediamsg->state) {
 				DEBUG(1, "Media is up\n");
-- 
Ondrej Zary

