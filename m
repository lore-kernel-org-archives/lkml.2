Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2GXOmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:42:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43626 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755206Ab2GXOmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:42:51 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: wm8994: Flag the interrupt block as requiring runtime PM be enabled
Date: Tue, 24 Jul 2012 15:42:45 +0100
Message-Id: <1343140966-18641-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1343140966-18641-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1343140966-18641-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's only required in a few circumstances but better to be safe.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Seems most sensible to merge via regmap?

 drivers/mfd/wm8994-irq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/wm8994-irq.c b/drivers/mfd/wm8994-irq.c
index 0aac4af..a050e56 100644
--- a/drivers/mfd/wm8994-irq.c
+++ b/drivers/mfd/wm8994-irq.c
@@ -135,6 +135,7 @@ static struct regmap_irq_chip wm8994_irq_chip = {
 	.status_base = WM8994_INTERRUPT_STATUS_1,
 	.mask_base = WM8994_INTERRUPT_STATUS_1_MASK,
 	.ack_base = WM8994_INTERRUPT_STATUS_1,
+	.runtime_pm = true,
 };
 
 int wm8994_irq_init(struct wm8994 *wm8994)
-- 
1.7.10.4

