Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab0KZRGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:06:51 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42343 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab0KZRGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:06:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=WIeBjNNm5ATPtxr+VHeyLYj1fxHUPKtb4xyfvWPRe5dzImABuRJe+MuwxYZUb6QNqO
         H2t2ydk+dO4H4Diou6k2/KG/OzEKpwcv3DuMl3LEj2bbDyDk+vy6COub+DMpSqA6z3nC
         XfsUNL7kvjSKJJXrpUCt09YgdwqIsB4FPIIRg=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: rc: lirc_dev: check kobject_set_name() result
Date: Fri, 26 Nov 2010 20:06:41 +0300
Message-Id: <1290791203-21448-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kobject_set_name() may fail with -ENOMEM, check for it.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/media/rc/lirc_dev.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 8418b14..0a2d267 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -178,7 +178,9 @@ static int lirc_cdev_add(struct irctl *ir)
 		cdev_init(cdev, &lirc_dev_fops);
 		cdev->owner = THIS_MODULE;
 	}
-	kobject_set_name(&cdev->kobj, "lirc%d", d->minor);
+	retval = kobject_set_name(&cdev->kobj, "lirc%d", d->minor);
+	if (retval)
+		return retval;
 
 	retval = cdev_add(cdev, MKDEV(MAJOR(lirc_base_dev), d->minor), 1);
 	if (retval)
-- 
1.7.0.4

