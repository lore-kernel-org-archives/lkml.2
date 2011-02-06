Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab1BFX27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:28:59 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:54844 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab1BFX24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:28:56 -0500
Date: Sun, 6 Feb 2011 15:28:53 -0800
From: Andres Salomon <dilinger@queued.net>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, cjb@laptop.org,
        jon.nettleton@gmail.com
Subject: [PATCH 4/4] olpc_dcon: actually return the value of i2c_add_driver
Message-ID: <20110206152853.70620e19@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's nice to actually check for errors. :)

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 5d85d77..eec10e7 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -872,7 +872,7 @@ static irqreturn_t dcon_interrupt(int irq, void *id)
 	return IRQ_HANDLED;
 }
 
-static struct i2c_device_id dcon_idtable[] = {
+static const struct i2c_device_id dcon_idtable[] = {
 	{ "olpc_dcon",  0 },
 	{ }
 };
@@ -901,8 +901,7 @@ static int __init olpc_dcon_init(void)
 {
 	pdata = &dcon_pdata_xo_1;
 
-	i2c_add_driver(&dcon_driver);
-	return 0;
+	return i2c_add_driver(&dcon_driver);
 }
 
 static void __exit olpc_dcon_exit(void)
-- 
1.7.2.3

