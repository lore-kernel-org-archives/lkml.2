Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910Ab1EODZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 23:25:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41683 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab1EODZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 23:25:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=I+24EFZxD6qsgDFK4pg1BCFKxEgmR/Kb9tyS3/GGz7xO4rdP5XFfZbIcGX8hp43qdz
         UzlGwC9D8jykAkAMomrMSNLrbFxFe9VsQBfAlLoMseoPaVzFV8U+qnNvOJcZUjWHbiLJ
         Ue+n8Hp4FoEKCNfwzZwAfnVBdBUmaHrSrZmVo=
Subject: [PATCH 3/3] printk loglevels modified to match the scenario
From: anish <anish198519851985@gmail.com>
To: greg@kroah.com, teddy.wang@siliconmotion.com.cn
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 23:25:11 +0530
Message-ID: <1305395711.7400.18.camel@anish-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KERN_ERR should be used in place of KERN_INFO in the case of
error scenarios.
Signed-off-by: anish kumar<anish198519851985@gmail.com>

---
drivers/staging/sm7xx/smtcfb.c |    8 ++++----
1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c
b/drivers/staging/sm7xx/smtcfb.c
index d1dd387..c8caf54 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -753,7 +753,7 @@ static int smtc_map_smem(struct smtcfb_info *sfb,
sfb->fb.screen_base = smtc_VRAMBaseAddress;

if (!sfb->fb.screen_base) {
- printk(KERN_INFO "%s: unable to map screen memory\n",
+ printk(KERN_ERR "%s: unable to map screen memory\n",
sfb->fb.fix.id);
return -ENOMEM;
}
@@ -908,7 +908,7 @@ static int __devinit smtcfb_pci_probe(struct pci_dev
*pdev,
}
#endif
if (!smtc_RegBaseAddress) {
- printk(KERN_INFO
+ printk(KERN_ERR
"%s: unable to map memory mapped IO\n",
sfb->fb.fix.id);
err = -ENOMEM;
@@ -943,7 +943,7 @@ static int __devinit smtcfb_pci_probe(struct pci_dev
*pdev,
smtc_seqw(0x6b, 0x02);
break;
default:
- printk(KERN_INFO
+ printk(KERN_ERR
"No valid Silicon Motion display chip was detected!\n");

goto failed_fb;
@@ -976,7 +976,7 @@ static int __devinit smtcfb_pci_probe(struct pci_dev
*pdev,
return 0;

  failed:
- printk(KERN_INFO "Silicon Motion, Inc.  primary display init fail\n");
+ printk(KERN_ERR "Silicon Motion, Inc.  primary display init fail\n");

smtc_unmap_smem(sfb);
smtc_unmap_mmio(sfb);
-- 
1.7.0.4



