Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab0JBHYA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 03:24:00 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61443 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab0JBHX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 03:23:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UrKCZEI6PKC43GvVW5EwXI+Oc+rP287LfnFksAj3ju/Vsx2t3PGQGVefpQhxt7FFt5
         SUKFq/qwj8YPwN0DCrZk2CpdiRKT438ia4P4EKTZY5j3oCaOq94FAAIMki/V0AeVp0jn
         0I/C0fD99QjwH77Vnlw+9bTTu2QYmOkqj2W/w=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [PATCH] usb: gadget: dummy_hcd: Fix error path
Date: Sat,  2 Oct 2010 12:53:30 +0530
Message-Id: <1286004210-3833-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function dummy_udc_probe()
call put_device() when device_register() fails.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/usb/gadget/dummy_hcd.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index dc65462..2548091 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -885,8 +885,10 @@ static int dummy_udc_probe (struct platform_device *pdev)
 	dum->gadget.dev.parent = &pdev->dev;
 	dum->gadget.dev.release = dummy_gadget_release;
 	rc = device_register (&dum->gadget.dev);
-	if (rc < 0)
+	if (rc < 0) {
+		put_device(&dum->gadget.dev);
 		return rc;
+	}
 
 	usb_get_hcd (dummy_to_hcd (dum));
 
-- 
1.7.2.3

