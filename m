Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab2HDRVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 13:21:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63701 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2HDRVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 13:21:22 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Javier=20Mu=C3=B1oz?= <jmunhoz@igalia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Devendra Naga <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH] staging: sm7xxfb: copy name of the device before calling smtc_alloc_fb_info
Date: Sat,  4 Aug 2012 23:06:12 +0545
Message-Id: <1344100872-19640-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as we do a strcpy(smdrv_ptr->fb_struct->fix->id, name), and the name here in
sm7xxx_probe is not having any assignment, and which leads to copying of the garbage value
into the id field of the fix struct of fb interface struct. fix it by copying the name before
calling alloc_fbinfo

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 Only compile tested
 This patch is not tested using the hardware... if any one is having this hardware, i request them to
please test this
 drivers/staging/sm7xxfb/sm7xxfb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 1c1780c..d3957ef 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -798,16 +798,17 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	if (err)
 		return err;
 
+	sprintf(name, "sm%Xfb", ent->device);
+
 	sfb = smtc_alloc_fb_info(pdev, name);
 
+	sfb->chip_id = ent->device;
+
 	if (!sfb) {
 		err = -ENOMEM;
 		goto failed_free;
 	}
 
-	sfb->chip_id = ent->device;
-	sprintf(name, "sm%Xfb", sfb->chip_id);
-
 	pci_set_drvdata(pdev, sfb);
 
 	sm7xx_init_hw();
-- 
1.7.9.5

