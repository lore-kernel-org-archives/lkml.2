Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab2GLGLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:11:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47093 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab2GLGLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:11:19 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sage Ahn <syahn@gctsemi.com>, Devendra Naga <devendra.aaru@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] staging/gdm72xx: return PTR_ERR rather -ENOENT
Date: Thu, 12 Jul 2012 11:56:11 +0545
Message-Id: <1342073471-11937-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

return the error of filp_open rather returning -ENOENT.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/gdm72xx/usb_boot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gdm72xx/usb_boot.c b/drivers/staging/gdm72xx/usb_boot.c
index c163bcc..fef290c 100644
--- a/drivers/staging/gdm72xx/usb_boot.c
+++ b/drivers/staging/gdm72xx/usb_boot.c
@@ -174,7 +174,7 @@ int usb_boot(struct usb_device *usbdev, u16 pid)
 	if (IS_ERR(filp)) {
 		printk(KERN_ERR "Can't find %s.\n", img_name);
 		set_fs(fs);
-		ret = -ENOENT;
+		ret = PTR_ERR(filp);
 		goto restore_fs;
 	}
 
-- 
1.7.9.5

