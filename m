Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727Ab2DSVWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:22:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965183Ab2DSVRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:17:31 -0400
Message-Id: <20120419210823.008993770@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:09:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 51/68] usb: gadget: pch_udc: Fix wrong return value
In-Reply-To: <20120419210923.GA18589@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit c802672cd36cd063bfd54d54c8c34825ab5b2357 upstream.

ISSUE:
If the return value of pch_udc_pcd_init() is False, the return value of
this function is unsettled.
Since pch_udc_pcd_init() always returns 0, there is not actually the issue.

CAUSE:
If pch_udc_pcd_init() is True, the variable, retval, is not set for an
appropriate value.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/pch_udc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -2915,8 +2915,10 @@ static int pch_udc_probe(struct pci_dev
 	}
 	pch_udc = dev;
 	/* initialize the hardware */
-	if (pch_udc_pcd_init(dev))
+	if (pch_udc_pcd_init(dev)) {
+		retval = -ENODEV;
 		goto finished;
+	}
 	if (request_irq(pdev->irq, pch_udc_isr, IRQF_SHARED, KBUILD_MODNAME,
 			dev)) {
 		dev_err(&pdev->dev, "%s: request_irq(%d) fail\n", __func__,


