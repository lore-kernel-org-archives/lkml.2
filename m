Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab2CQXBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 19:01:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43266 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab2CQXBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 19:01:15 -0400
Date: Sat, 17 Mar 2012 16:01:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MFD: da9052-i2c - add some section annotations
Message-ID: <20120317230108.GA19068@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

da9052_i2c_remove() can and should be marked as __devexit.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/mfd/da9052-i2c.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
index 44b97c7..f99685a 100644
--- a/drivers/mfd/da9052-i2c.c
+++ b/drivers/mfd/da9052-i2c.c
@@ -87,7 +87,7 @@ err:
 	return ret;
 }
 
-static int da9052_i2c_remove(struct i2c_client *client)
+static int __devexit da9052_i2c_remove(struct i2c_client *client)
 {
 	struct da9052 *da9052 = i2c_get_clientdata(client);
 
@@ -107,7 +107,7 @@ static struct i2c_device_id da9052_i2c_id[] = {
 
 static struct i2c_driver da9052_i2c_driver = {
 	.probe = da9052_i2c_probe,
-	.remove = da9052_i2c_remove,
+	.remove = __devexit_p(da9052_i2c_remove),
 	.id_table = da9052_i2c_id,
 	.driver = {
 		.name = "da9052",

-- 
Dmitry
