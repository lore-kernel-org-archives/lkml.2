Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab1GFSEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755111Ab1GFSE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:04:28 -0400
Date: Wed, 6 Jul 2011 15:03:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv3 13/17] [media] dvb-bt8xx: Don't return -EFAULT when a
 device is not found
Message-ID: <20110706150359.28924e4a@pedra>
In-Reply-To: <cover.1309974026.git.mchehab@redhat.com>
References: <cover.1309974026.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a device (or their PCI structs) are not found, the error should
be -ENODEV. -EFAULT is reserved for errors while copying arguments
from/to userspace.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/bt8xx/dvb-bt8xx.c b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
index 1e1106d..521d691 100644
--- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
@@ -892,7 +892,7 @@ static int __devinit dvb_bt8xx_probe(struct bttv_sub_device *sub)
 	if (!(bttv_pci_dev = bttv_get_pcidev(card->bttv_nr))) {
 		printk("dvb_bt8xx: no pci device for card %d\n", card->bttv_nr);
 		kfree(card);
-		return -EFAULT;
+		return -ENODEV;
 	}
 
 	if (!(card->bt = dvb_bt8xx_878_match(card->bttv_nr, bttv_pci_dev))) {
@@ -902,7 +902,7 @@ static int __devinit dvb_bt8xx_probe(struct bttv_sub_device *sub)
 		       "installed, try removing it.\n");
 
 		kfree(card);
-		return -EFAULT;
+		return -ENODEV;
 	}
 
 	mutex_init(&card->bt->gpio_lock);
-- 
1.7.1


