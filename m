Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab0LBOJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 09:09:12 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:52843 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757605Ab0LBOJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 09:09:10 -0500
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH] MFD: ab8500-core improved error handling in get_chip_id
Date: Thu, 2 Dec 2010 15:08:32 +0100
Message-ID: <1291298912-3589-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves the error handling in ab8500_get_chip_id.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
---
 drivers/mfd/ab8500-core.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index d9640a6..e91b5b7 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -103,8 +103,12 @@ static const int ab8500_irq_regoffset[AB8500_NUM_IRQ_REGS] = {
 
 static int ab8500_get_chip_id(struct device *dev)
 {
-	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
-	return (int)ab8500->chip_id;
+	struct ab8500 *ab8500;
+
+	if (!dev)
+		return -EINVAL;
+	ab8500 = dev_get_drvdata(dev->parent);
+	return ab8500 ? (int)ab8500->chip_id : -EINVAL;
 }
 
 static int set_register_interruptible(struct ab8500 *ab8500, u8 bank,
-- 
1.7.2.2

