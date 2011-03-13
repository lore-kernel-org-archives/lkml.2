Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab1CMK05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:26:57 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:39913 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab1CMK0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:26:21 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH v2 08/24] staging: xgifb: delete redundant extended register access enable
Date: Sun, 13 Mar 2011 12:26:12 +0200
Message-Id: <1300011988-2109-9-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
References: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
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

