Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab0ISMz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 08:55:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58608 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab0ISMzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 08:55:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uZNytDVtUyBy3ky1roJuHdqjsj6ERvdjJKhEGo/1L4lS5dTsrka3n9mEZmt84tbdL6
         uSmrRsROqhF4KObPLLunCdhey0/oTIhzEtn2nTtST1H1vITA6J9Rdg5z4rHEBd5cZD6O
         OCmi6yexZhE7r9T0Wbo3g/ddQsPvWMzkcNOKM=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: David Vrabel <david.vrabel@csr.com>, Tejun Heo <tj@kernel.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] uwb: fix device_register() error handling
Date: Sun, 19 Sep 2010 16:55:18 +0400
Message-Id: <1284900918-24770-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device_register() fails then call put_device().
See comment to device_register.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 compile tested.

 drivers/uwb/umc-dev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/uwb/umc-dev.c b/drivers/uwb/umc-dev.c
index 43ea998..e8e06ee 100644
--- a/drivers/uwb/umc-dev.c
+++ b/drivers/uwb/umc-dev.c
@@ -68,6 +68,7 @@ int umc_device_register(struct umc_dev *umc)
 	return 0;
 
 error_device_register:
+	put_device(&umc->dev);
 	release_resource(&umc->resource);
 error_request_resource:
 	return err;
-- 
1.7.0.4

