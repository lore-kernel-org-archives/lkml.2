Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab1KFNO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 08:14:29 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40872 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab1KFNO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 08:14:28 -0500
Message-ID: <1320585256.18391.1.camel@phoenix>
Subject: [PATCH 1/2] hwspinlock/u8500: fix build error due to undefined label
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Sun, 06 Nov 2011 21:14:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build error:

  CC      drivers/hwspinlock/u8500_hsem.o
drivers/hwspinlock/u8500_hsem.c: In function 'u8500_hsem_probe':
drivers/hwspinlock/u8500_hsem.c:113: error: label 'free_state' used but not defined

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hwspinlock/u8500_hsem.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hwspinlock/u8500_hsem.c b/drivers/hwspinlock/u8500_hsem.c
index 143461a..a120f14 100644
--- a/drivers/hwspinlock/u8500_hsem.c
+++ b/drivers/hwspinlock/u8500_hsem.c
@@ -108,10 +108,8 @@ static int __devinit u8500_hsem_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	io_base = ioremap(res->start, resource_size(res));
-	if (!io_base) {
-		ret = -ENOMEM;
-		goto free_state;
-	}
+	if (!io_base)
+		return -ENOMEM;
 
 	/* make sure protocol 1 is selected */
 	val = readl(io_base + HSEM_CTRL_REG);
-- 
1.7.5.4



