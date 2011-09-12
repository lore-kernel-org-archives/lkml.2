Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab1ILQsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:48:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64825 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab1ILQsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:48:03 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 09/10] hwspinlock/omap: omap_hwspinlock_remove should be __devexit
Date: Mon, 12 Sep 2011 19:47:04 +0300
Message-Id: <1315846025-11453-10-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315846025-11453-1-git-send-email-ohad@wizery.com>
References: <1315846025-11453-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark omap_hwspinlock_remove with __devexit (and use __devexit_p
appropriately) so the function can be discarded when the conditions are met.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/hwspinlock/omap_hwspinlock.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwspinlock/omap_hwspinlock.c b/drivers/hwspinlock/omap_hwspinlock.c
index aec3006..887d34e 100644
--- a/drivers/hwspinlock/omap_hwspinlock.c
+++ b/drivers/hwspinlock/omap_hwspinlock.c
@@ -142,7 +142,7 @@ iounmap_base:
 	return ret;
 }
 
-static int omap_hwspinlock_remove(struct platform_device *pdev)
+static int __devexit omap_hwspinlock_remove(struct platform_device *pdev)
 {
 	struct hwspinlock_device *bank = platform_get_drvdata(pdev);
 	void __iomem *io_base = bank->lock[0].priv - LOCK_BASE_OFFSET;
@@ -163,7 +163,7 @@ static int omap_hwspinlock_remove(struct platform_device *pdev)
 
 static struct platform_driver omap_hwspinlock_driver = {
 	.probe		= omap_hwspinlock_probe,
-	.remove		= omap_hwspinlock_remove,
+	.remove		= __devexit_p(omap_hwspinlock_remove),
 	.driver		= {
 		.name	= "omap_hwspinlock",
 		.owner	= THIS_MODULE,
-- 
1.7.4.1

