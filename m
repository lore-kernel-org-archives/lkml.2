Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab0JBFSB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 01:18:01 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54053 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab0JBFSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 01:18:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=O4xYpVHuL+8pU73/V+SH4nTXP0PKwdyWSOppsiPyxkNA+uTeFji3c3GQ5DR0IzpyEP
         8MdXq+/l/49oEdrL1NgVY9AeKZ0F4Iadqvi/6AbBHDanOhrzX66at49Gcb0jIyTmLzwy
         Qw+rh5mfhBRHb1C5i2TQtAO2w7DFaGOsZ9gMo=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [PATCH] usb: gadget: ci13xxx_udc: Fix error path
Date: Sat,  2 Oct 2010 10:47:32 +0530
Message-Id: <1285996652-3224-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call put_device() when device_register() fails.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/usb/gadget/ci13xxx_udc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/ci13xxx_udc.c b/drivers/usb/gadget/ci13xxx_udc.c
index 6996951..f330833 100644
--- a/drivers/usb/gadget/ci13xxx_udc.c
+++ b/drivers/usb/gadget/ci13xxx_udc.c
@@ -2635,8 +2635,10 @@ static int udc_probe(struct device *dev, void __iomem *regs, const char *name)
 	udc->gadget.dev.release  = udc_release;
 
 	retval = device_register(&udc->gadget.dev);
-	if (retval)
+	if (retval) {
+		put_device(&udc->gadget.dev);
 		goto done;
+	}
 
 #ifdef CONFIG_USB_GADGET_DEBUG_FILES
 	retval = dbg_create_files(&udc->gadget.dev);
-- 
1.7.2.3

