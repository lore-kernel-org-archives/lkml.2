Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab2GKBsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 21:48:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44555 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab2GKBsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 21:48:09 -0400
Message-ID: <1341971280.25495.0.camel@phoenix>
Subject: [PATCH] mfd: Remove __devexit annotation for pm80x_deinit
From: Axel Lin <axel.lin@gmail.com>
To: SamuelOrtiz <sameo@linux.intel.com>
Cc: Qiao Zhou <zhouqiao@marvell.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Jul 2012 09:48:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes below section mismatch warning:

  LD      drivers/mfd/built-in.o
WARNING: drivers/mfd/built-in.o(.devinit.text+0x46c): Section mismatch in reference from the function pm800_probe() to the function .devexit.text:pm80x_deinit()
The function __devinit pm800_probe() references
a function __devexit pm80x_deinit().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __devexit annotation of
pm80x_deinit() so it may be used outside an exit section.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/88pm80x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/88pm80x.c b/drivers/mfd/88pm80x.c
index 62da342..cd0bf52 100644
--- a/drivers/mfd/88pm80x.c
+++ b/drivers/mfd/88pm80x.c
@@ -91,7 +91,7 @@ err_regmap_init:
 }
 EXPORT_SYMBOL_GPL(pm80x_init);
 
-int __devexit pm80x_deinit(struct i2c_client *client)
+int pm80x_deinit(struct i2c_client *client)
 {
 	struct pm80x_chip *chip = i2c_get_clientdata(client);
 
-- 
1.7.9.5



