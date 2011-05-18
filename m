Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289Ab1ERRNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 13:13:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59494 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab1ERRNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 13:13:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=cpKw6vrTupa+A6lpCh2c5eTescBodGNSenpYnuXEEv/pRKaElomc3NMjy7nLOJRN7q
         8uZrkYzavQIk/bunp9ObkWrwfoIEx+BkwSFael25T9Ohchvzj+Iu+wjzgq8ainEKQ3PR
         OVEbTxdw5xcgcRRCumK0s8ZJPsuwBv9n5ckso=
Subject: [patch 3/3] Staging: sm7xx: printk loglevels modified to match the
 scenario
From: anish <anish198519851985@gmail.com>
To: greg@kroah.com, teddy.wang@siliconmotion.com.cn
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 22:42:32 +0530
Message-ID: <1305738752.1881.85.camel@anish-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KERN_ERR should be used in place of KERN_INFO in the case of
 error scenarios.

 Signed-off-by: anish kumar <anish198519851985@gmail.com>

---
 drivers/staging/sm7xx/smtcfb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index c41d2f7..a164fc4 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -783,7 +783,7 @@ static int smtc_map_smem(struct smtcfb_info *sfb,
 	sfb->fb.screen_base = smtc_VRAMBaseAddress;
 
 	if (!sfb->fb.screen_base) {
-		printk(KERN_INFO "%s: unable to map screen memory\n",
+		printk(KERN_ERR "%s: unable to map screen memory\n",
 				sfb->fb.fix.id);
 		return -ENOMEM;
 	}
@@ -938,7 +938,7 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 		}
 #endif
 		if (!smtc_RegBaseAddress) {
-			printk(KERN_INFO
+			printk(KERN_ERR
 				"%s: unable to map memory mapped IO\n",
 				sfb->fb.fix.id);
 			err = -ENOMEM;
@@ -973,7 +973,7 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 		smtc_seqw(0x6b, 0x02);
 		break;
 	default:
-		printk(KERN_INFO
+		printk(KERN_ERR
 		"No valid Silicon Motion display chip was detected!\n");
 
 		goto failed_fb;
@@ -1006,7 +1006,7 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	return 0;
 
 failed:
-	printk(KERN_INFO "Silicon Motion, Inc.  primary display init fail\n");
+	printk(KERN_ERR "Silicon Motion, Inc.  primary display init fail\n");
 
 	smtc_unmap_smem(sfb);
 	smtc_unmap_mmio(sfb);
-- 
1.7.0.4




