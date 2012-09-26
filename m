Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab2IZRAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:00:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54811 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757422Ab2IZRAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:00:39 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: wm5110: Disable control interface error report for WM5110 rev B
Date: Wed, 26 Sep 2012 18:00:28 +0100
Message-Id: <1348678829-15496-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It can misreport.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index f7886c8..ef0f2d0 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -192,6 +192,7 @@ int arizona_irq_init(struct arizona *arizona)
 
 		switch (arizona->rev) {
 		case 0:
+		case 1:
 			ctrlif_error = false;
 			break;
 		default:
-- 
1.7.10.4

