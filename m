Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab2GBIyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:54:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45486 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab2GBIyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:54:07 -0400
Message-ID: <1341219232.5864.1.camel@phoenix>
Subject: [PATCH] mfd: adp5520: Guard PM methods with CONFIG_PM_SLEEP
From: Axel Lin <axel.lin@gmail.com>
To: SamuelOrtiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Michael Hennerich <michael.hennerich@analog.com>
Date: Mon, 02 Jul 2012 16:53:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes below build warnings:
  CC      drivers/mfd/adp5520.o
drivers/mfd/adp5520.c:324:12: warning: 'adp5520_suspend' defined but not used [-Wunused-function]
drivers/mfd/adp5520.c:333:12: warning: 'adp5520_resume' defined but not used [-Wunused-function]

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/adp5520.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
index 8d816cc..ea8b947 100644
--- a/drivers/mfd/adp5520.c
+++ b/drivers/mfd/adp5520.c
@@ -320,7 +320,7 @@ static int __devexit adp5520_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int adp5520_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-- 
1.7.9.5



