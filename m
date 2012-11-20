Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab2KTEtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:49:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40704 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944Ab2KTEti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:49:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/5] mfd: wm5110: Disable control interface error report for WM5110 rev B
Date: Tue, 20 Nov 2012 13:46:18 +0900
Message-Id: <1353386781-10468-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353386781-10468-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20121120044544.GF4483@opensource.wolfsonmicro.com>
 <1353386781-10468-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It can misreport.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index ef0f2d0..b1b0091 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -178,6 +178,7 @@ int arizona_irq_init(struct arizona *arizona)
 
 		switch (arizona->rev) {
 		case 0:
+		case 1:
 			ctrlif_error = false;
 			break;
 		default:
-- 
1.7.10.4

