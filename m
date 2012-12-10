Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab2LJW20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:28:26 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19812 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2LJW2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:28:24 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6922"; a="12917207"
From: Jack Pham <jackp@codeaurora.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jack Pham <jackp@codeaurora.org>
Subject: [PATCH] usb: dwc3: debugfs: fix regdump offset
Date: Mon, 10 Dec 2012 14:28:13 -0800
Message-Id: <1355178493-16688-1-git-send-email-jackp@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As with dwc_readl/writel, the global registers are specified as
offsets starting from the beginning of the xHCI address space,
but the memory region pointed to by dwc->regs already maps to
the start of the global addresses. Fix by offsetting each of the
regs relative to DWC3_GLOBALS_REGS_START.

Signed-off-by: Jack Pham <jackp@codeaurora.org>
---
 drivers/usb/dwc3/debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
index d4a30f1..be4eff7 100644
--- a/drivers/usb/dwc3/debugfs.c
+++ b/drivers/usb/dwc3/debugfs.c
@@ -56,7 +56,7 @@
 #define dump_register(nm)				\
 {							\
 	.name	= __stringify(nm),			\
-	.offset	= DWC3_ ##nm,				\
+	.offset	= DWC3_ ##nm - DWC3_GLOBALS_REGS_START,	\
 }
 
 static const struct debugfs_reg32 dwc3_regs[] = {
-- 
Employee of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

