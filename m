Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab2FVEQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 00:16:33 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:14639 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222Ab2FVEQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 00:16:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwEAO3w40+WZb0z/2dsb2JhbABFtmiCRlKBPgESiAq6R5EwA55ShluCcQ
From: Steve Bennett <steveb@workware.net.au>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Steve Bennett <steveb@workware.net.au>
Subject: [PATCH] usb: gadget: acm_ms: need to set max_speed
Date: Fri, 22 Jun 2012 14:16:19 +1000
Message-Id: <1340338579-1411-1-git-send-email-steveb@workware.net.au>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Failing to set max_speed prevents g_acm_ms working with many drivers which
check for driver->max_speed < USB_SPEED_FULL, including pxa25x_udc

Signed-off-by: Steve Bennett <steveb@workware.net.au>
---
 drivers/usb/gadget/acm_ms.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/acm_ms.c b/drivers/usb/gadget/acm_ms.c
index fdb7aec..75b8a69 100644
--- a/drivers/usb/gadget/acm_ms.c
+++ b/drivers/usb/gadget/acm_ms.c
@@ -235,6 +235,7 @@ static int __exit acm_ms_unbind(struct usb_composite_dev *cdev)
 static struct usb_composite_driver acm_ms_driver = {
 	.name		= "g_acm_ms",
 	.dev		= &device_desc,
+	.max_speed	= USB_SPEED_SUPER,
 	.strings	= dev_strings,
 	.unbind		= __exit_p(acm_ms_unbind),
 };
-- 
1.7.10

