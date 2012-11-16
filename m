Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab2KPGiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:38:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37752 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2KPGiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:38:05 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb: dwc3: core: move dwc3_cache_hwparams before dwc3_alloc_event_buffers
Date: Fri, 16 Nov 2012 12:07:54 +0530
Message-ID: <1353047874-4981-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 392142 moved event buffer allocation out of dwc3_core_init() but
event buffer allocation uses the cached copy of hwparams to determine
the number of event buffers and the caching is done in dwc3_core_init.
So moved dwc3_cache_hwparams function before dwc3_alloc_event_buffers so
that dwc3_alloc_event_buffers sees the correct number of event buffers.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index b923183..88e8d31 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -356,8 +356,6 @@ static int __devinit dwc3_core_init(struct dwc3 *dwc)
 
 	dwc3_core_soft_reset(dwc);
 
-	dwc3_cache_hwparams(dwc);
-
 	reg = dwc3_readl(dwc->regs, DWC3_GCTL);
 	reg &= ~DWC3_GCTL_SCALEDOWN_MASK;
 	reg &= ~DWC3_GCTL_DISSCRAMBLE;
@@ -498,6 +496,8 @@ static int __devinit dwc3_probe(struct platform_device *pdev)
 	pm_runtime_get_sync(dev);
 	pm_runtime_forbid(dev);
 
+	dwc3_cache_hwparams(dwc);
+
 	ret = dwc3_alloc_event_buffers(dwc, DWC3_EVENT_BUFFERS_SIZE);
 	if (ret) {
 		dev_err(dwc->dev, "failed to allocate event buffers\n");
-- 
1.7.9.5

