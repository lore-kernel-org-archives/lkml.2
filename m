Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030198Ab2GEX21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 19:28:27 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:38034 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab2GEX20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 19:28:26 -0400
X-Greylist: delayed 1107 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2012 19:28:26 EDT
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Neil Zhang <zhangwm@marvell.com>, Felipe Balbi <balbi@ti.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: [PATCH] usb: gadget: mv_udc: use GFP_ATOMIC in build_dtd()
Date: Fri,  6 Jul 2012 01:09:48 +0200
Message-Id: <1341529788-10232-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

build_dtd() is called either from interrupt handler mv_udc_irq()
or with spinlock held (from mv_ep_queue()). So we should 
alloc memory with GFP_ATOMIC, not GFP_KERNEL.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/gadget/mv_udc_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index 117a4bb..693e1e4 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -374,7 +374,7 @@ static struct mv_dtd *build_dtd(struct mv_req *req, unsigned *length,
 	 * Be careful that no _GFP_HIGHMEM is set,
 	 * or we can not use dma_to_virt
 	 */
-	dtd = dma_pool_alloc(udc->dtd_pool, GFP_KERNEL, dma);
+	dtd = dma_pool_alloc(udc->dtd_pool, GFP_ATOMIC, dma);
 	if (dtd == NULL)
 		return dtd;
 
-- 
1.7.9.5

