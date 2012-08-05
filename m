Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab2HEVOB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 17:14:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43348 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab2HEVN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 17:13:59 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Naren Sankar <nsankar@broadcom.com>, Jarod Wilson <jarod@wilsonet.com>,
        Scott Davilla <davilla@4pi.com>, Manu Abraham <abraham.manu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jorgyano Vieira <jorgyano@gmail.com>,
        Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH 1/2] staging/crystalhd: assign PTR_ERR at fail cases to rc in chd_dec_init_chdev
Date: Mon,  6 Aug 2012 02:58:47 +0545
Message-Id: <1344201227-16912-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the rc assignment to PTR_ERR at fail cases of class_create and device_create are missed out,
return proper error rather than returning -ENODEV.

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/staging/crystalhd/crystalhd_lnx.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index d9e3d61..0582ac0 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -373,6 +373,7 @@ static int __devinit chd_dec_init_chdev(struct crystalhd_adp *adp)
 	/* register crystalhd class */
 	crystalhd_class = class_create(THIS_MODULE, "crystalhd");
 	if (IS_ERR(crystalhd_class)) {
+		rc = PTR_ERR(crystalhd_class);
 		BCMLOG_ERR("failed to create class\n");
 		goto fail;
 	}
@@ -380,6 +381,7 @@ static int __devinit chd_dec_init_chdev(struct crystalhd_adp *adp)
 	dev = device_create(crystalhd_class, NULL, MKDEV(adp->chd_dec_major, 0),
 			    NULL, "crystalhd");
 	if (IS_ERR(dev)) {
+		rc = PTR_ERR(crystalhd_class);
 		BCMLOG_ERR("failed to create device\n");
 		goto device_create_fail;
 	}
-- 
1.7.9.5

