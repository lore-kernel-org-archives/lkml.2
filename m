Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab0JBHfv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 03:35:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36754 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab0JBHfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 03:35:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cgrom9D1e5f/mSbvPoMXc66Hv0Dk2Vp7hkM6lH/p+8zokrAA9730bk9ciYJx0GSE2q
         h2lDYZ5Z3qe5KmKfLuIzAK8kQckPI1WLWPw0x2M/qXkU1D1mZD75Sx0tKm4wbeBK4Onv
         J+fLBsU20Ndt0e8WB8IalrUOv+jo+uhX2cJRc=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Harro Haan <hrhaan@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ryan Mallon <ryan@bluewatersys.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [PATCH] usb: gadget: at91_udc: Fix error path
Date: Sat,  2 Oct 2010 13:05:16 +0530
Message-Id: <1286004916-3948-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function at91udc_probe()
call put_device() when device_register() fails.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/usb/gadget/at91_udc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 93ead19..43178e5 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1798,8 +1798,10 @@ static int __init at91udc_probe(struct platform_device *pdev)
 	}
 
 	retval = device_register(&udc->gadget.dev);
-	if (retval < 0)
+	if (retval < 0) {
+		put_device(&udc->gadget.dev);
 		goto fail0b;
+	}
 
 	/* don't do anything until we have both gadget driver and VBUS */
 	clk_enable(udc->iclk);
-- 
1.7.2.3

