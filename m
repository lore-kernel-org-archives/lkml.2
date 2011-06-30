Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab1F3WGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:06:37 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:60557 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753254Ab1F3WER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:04:17 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/28] staging: ft1000-pcmcia: remove PROV_RECORD typedefs
Date: Fri,  1 Jul 2011 00:03:41 +0200
Message-Id: <1309471437-12633-13-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
References: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove PROV_RECORD typedefs.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h      |    4 ++--
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |    4 ++--
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |   12 ++++++------
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
index b3aefd8..e697e9c 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -315,10 +315,10 @@ struct dsp_init_msg {
     u8 RfCalDate[CALDATESZ];    // Rf Calibration date
 } __attribute__ ((packed));
 
-typedef struct _PROV_RECORD {
+struct prov_record {
     struct list_head list;
     u8 *pprov_data;
-} PROV_RECORD, *PPROV_RECORD;
+};
 
 typedef struct _FT1000_INFO {
     struct net_device_stats stats;
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
index 0a905a4..3c8fcb5 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -321,7 +321,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 	long word_length;
 	USHORT request;
 	USHORT temp;
-	PPROV_RECORD pprov_record;
+	struct prov_record *pprov_record;
 	PUCHAR pbuffer;
 	PDSP_FILE_HDR_5 pFileHdr5;
 	PDSP_IMAGE_INFO pDspImageInfo = NULL;
@@ -890,7 +890,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 							   sizeof(struct pseudo_hdr)));
 					// link provisioning data
 					pprov_record =
-						kmalloc(sizeof(PROV_RECORD),
+						kmalloc(sizeof(struct prov_record),
 							GFP_ATOMIC);
 					if (pprov_record) {
 						pprov_record->pprov_data =
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 949c155..d33f747 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -421,7 +421,7 @@ static int ft1000_reset_card(struct net_device *dev)
 	u16 tempword;
 	int i;
 	unsigned long flags;
-	PPROV_RECORD ptr;
+	struct prov_record *ptr;
 
 	DEBUG(1, "ft1000_hw:ft1000_reset_card called.....\n");
 
@@ -436,7 +436,7 @@ static int ft1000_reset_card(struct net_device *dev)
 	while (list_empty(&info->prov_list) == 0) {
 		DEBUG(0,
 			  "ft1000_hw:ft1000_reset_card:deleting provisioning record\n");
-		ptr = list_entry(info->prov_list.next, PROV_RECORD, list);
+		ptr = list_entry(info->prov_list.next, struct prov_record, list);
 		list_del(&ptr->list);
 		kfree(ptr->pprov_data);
 		kfree(ptr);
@@ -1020,7 +1020,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 	struct drv_msg *pdrvmsg;
 	u16 len;
 	u16 i;
-	PPROV_RECORD ptr;
+	struct prov_record *ptr;
 	struct pseudo_hdr *ppseudo_hdr;
 	PUSHORT pmsg;
 	struct timeval tv;
@@ -1061,7 +1061,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 				}
 				ptr =
 					list_entry(info->prov_list.next,
-						   PROV_RECORD, list);
+						   struct prov_record, list);
 				len = *(u16 *) ptr->pprov_data;
 				len = htons(len);
 
@@ -2095,7 +2095,7 @@ static irqreturn_t ft1000_interrupt(int irq, void *dev_id)
 void stop_ft1000_card(struct net_device *dev)
 {
 	FT1000_INFO *info = netdev_priv(dev);
-	PPROV_RECORD ptr;
+	struct prov_record *ptr;
 //	int cnt;
 
 	DEBUG(0, "ft1000_hw: stop_ft1000_card()\n");
@@ -2107,7 +2107,7 @@ void stop_ft1000_card(struct net_device *dev)
 
 	// Make sure we free any memory reserve for provisioning
 	while (list_empty(&info->prov_list) == 0) {
-		ptr = list_entry(info->prov_list.next, PROV_RECORD, list);
+		ptr = list_entry(info->prov_list.next, struct prov_record, list);
 		list_del(&ptr->list);
 		kfree(ptr->pprov_data);
 		kfree(ptr);
-- 
Ondrej Zary

