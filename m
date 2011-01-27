Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab1A0Aha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:37:30 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:22654 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752974Ab1A0Ah3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:37:29 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] usb/gadget/pch_udc: fix compile error
Date: Thu, 27 Jan 2011 09:36:50 +0900
Message-Id: <1296088610-14421-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In linux-2.6.38, return type of pci_restore_state is changed "int" to "void".
So, modify the pch_udc driver.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/usb/gadget/pch_udc.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 0c8dd81..542b83e 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -2792,11 +2792,8 @@ static int pch_udc_resume(struct pci_dev *pdev)
 	int ret;
 
 	pci_set_power_state(pdev, PCI_D0);
-	ret = pci_restore_state(pdev);
-	if (ret) {
-		dev_err(&pdev->dev, "%s: pci_restore_state failed\n", __func__);
-		return ret;
-	}
+	pci_restore_state(pdev);
+
 	ret = pci_enable_device(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "%s: pci_enable_device failed\n", __func__);
-- 
1.7.3.4

