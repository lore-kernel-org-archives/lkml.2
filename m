Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab2HEVPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 17:15:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41853 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab2HEVPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 17:15:08 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Naren Sankar <nsankar@broadcom.com>, Jarod Wilson <jarod@wilsonet.com>,
        Scott Davilla <davilla@4pi.com>, Manu Abraham <abraham.manu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jorgyano Vieira <jorgyano@gmail.com>,
        Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH 2/2] staging/crystalhd: unregister chardev when class_create fails in chd_dec_init_chdev
Date: Mon,  6 Aug 2012 02:59:56 +0545
Message-Id: <1344201296-16995-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we missed a unregiser_chrdev if the class_create and subsequent function calls / checks fail

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/staging/crystalhd/crystalhd_lnx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 0582ac0..5909d8d 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -375,7 +375,7 @@ static int __devinit chd_dec_init_chdev(struct crystalhd_adp *adp)
 	if (IS_ERR(crystalhd_class)) {
 		rc = PTR_ERR(crystalhd_class);
 		BCMLOG_ERR("failed to create class\n");
-		goto fail;
+		goto class_create_fail;
 	}
 
 	dev = device_create(crystalhd_class, NULL, MKDEV(adp->chd_dec_major, 0),
@@ -412,6 +412,8 @@ elem_pool_fail:
 	device_destroy(crystalhd_class, MKDEV(adp->chd_dec_major, 0));
 device_create_fail:
 	class_destroy(crystalhd_class);
+class_create_fail:
+	unregister_chrdev(adp->chd_dec_major, CRYSTALHD_API_NAME);
 fail:
 	return rc;
 }
-- 
1.7.9.5

