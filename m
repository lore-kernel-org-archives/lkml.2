Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab2ALCcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 21:32:52 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:53390 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071Ab2ALCcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 21:32:48 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 2/6 v2] usb/gadget/pch_udc: Fix wrong return value
Date: Thu, 12 Jan 2012 11:27:06 +0900
Message-Id: <1326335230-32469-2-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1326335230-32469-1-git-send-email-tomoya.rohm@gmail.com>
References: <1326335230-32469-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISSUE:
If the return value of pch_udc_pcd_init() is False, the return value of this function is unsettled.
Since pch_udc_pcd_init() always returns 0, there is not actually the issue.

CAUSE:
If pch_udc_pcd_init() is True, the variable, retval, is not set for an appropriate value.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
V2: Divide into 6 patches
---
 drivers/usb/gadget/pch_udc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index a4f8b08..78a2fce 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -2920,8 +2920,10 @@ static int pch_udc_probe(struct pci_dev *pdev,
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
-- 
1.7.4.4

