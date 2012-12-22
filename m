Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab2LVB6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 20:58:47 -0500
Received: from mail-ia0-f176.google.com ([209.85.210.176]:56129 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab2LVB6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:58:42 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org
Subject: [PATCH 22/25] usb/at91_udc: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:57:12 -0800
Message-Id: <1356141435-17340-23-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Remove unnecessary pending tests from at91_udc.  Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 drivers/usb/gadget/at91_udc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index f4a21f6..e81d8a2 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1621,8 +1621,7 @@ static void at91_vbus_timer(unsigned long data)
 	 * bus such as i2c or spi which may sleep, so schedule some work
 	 * to read the vbus gpio
 	 */
-	if (!work_pending(&udc->vbus_timer_work))
-		schedule_work(&udc->vbus_timer_work);
+	schedule_work(&udc->vbus_timer_work);
 }
 
 static int at91_start(struct usb_gadget *gadget,
-- 
1.8.0.2

