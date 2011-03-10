Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab1CJVCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:02:51 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:53037 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1CJVCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:02:44 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 08/22] staging: xgifb: delete redundant extended register access enable
Date: Thu, 10 Mar 2011 23:02:33 +0200
Message-Id: <1299790967-7135-9-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The extended register access enable in !XGIvga_enabled case is not needed.
The driver has enabled the access unconditionally already earlier in
the routine.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 79ff4df..17f2aef 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2264,10 +2264,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	if (!XGIvga_enabled) {
 		/* Mapping Max FB Size for 315 Init */
 		XGIhw_ext.pjVideoMemoryAddress = ioremap(xgi_video_info.video_base, 0x10000000);
-		if ((xgifb_mode_idx < 0) || ((XGIbios_mode[xgifb_mode_idx].mode_no) != 0xFF)) {
-			outXGIIDXREG(XGISR, IND_XGI_PASSWORD, XGI_PASSWORD);
-
-		}
 	}
 	if (XGIfb_get_dram_size()) {
 		printk(KERN_INFO "XGIfb: Fatal error: Unable to determine RAM size.\n");
-- 
1.5.6.5

