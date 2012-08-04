Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab2HDRZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 13:25:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42027 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab2HDRZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 13:25:28 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Javier=20Mu=C3=B1oz?= <jmunhoz@igalia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Devendra Naga <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH V2] staging: sm7xxfb: copy name of the device before calling smtc_alloc_fb_info
Date: Sat,  4 Aug 2012 23:10:20 +0545
Message-Id: <1344101120-22866-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as we do a strcpy(smdrv_ptr->fb_struct->fix->id, name), and the name here in
sm7xxx_probe is not having any assignment, and which leads to copying of the garbage value
into the id field of the fix struct of fb interface struct. fix it by copying the name before
calling alloc_fbinfo.

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---

Changes since V1:
 Fix a null deref when smtc_alloc_fbinfo fails, this was added by me in V1.

 drivers/staging/sm7xxfb/sm7xxfb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 1c1780c..1e42444 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -798,6 +798,8 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	if (err)
 		return err;
 
+	sprintf(name, "sm%Xfb", ent->device);
+
 	sfb = smtc_alloc_fb_info(pdev, name);
 
 	if (!sfb) {
@@ -806,8 +808,6 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	}
 
 	sfb->chip_id = ent->device;
-	sprintf(name, "sm%Xfb", sfb->chip_id);
-
 	pci_set_drvdata(pdev, sfb);
 
 	sm7xx_init_hw();
-- 
1.7.9.5

