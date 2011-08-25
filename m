Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1HYKyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 06:54:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46185 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab1HYKyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 06:54:12 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andres Salomon <dilinger@queued.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Belisko <marek.belisko@open-nandra.com>,
        Jean Delvare <khali@linux-fr.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/olpc_dcon: Remove obsolete cleanup for clientdata
Date: Thu, 25 Aug 2011 12:53:30 +0200
Message-Id: <1314269628-18325-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.5.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few new i2c-drivers came into the kernel which clear the clientdata-pointer
on exit or error. This is obsolete meanwhile, the core will do it.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Marek Belisko <marek.belisko@open-nandra.com>
Cc: Jean Delvare <khali@linux-fr.org>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 750fe50..a235330 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -712,7 +712,6 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
  eirq:
 	free_irq(DCON_IRQ, dcon);
  einit:
-	i2c_set_clientdata(client, NULL);
 	kfree(dcon);
 	return rc;
 }
@@ -721,8 +720,6 @@ static int dcon_remove(struct i2c_client *client)
 {
 	struct dcon_priv *dcon = i2c_get_clientdata(client);
 
-	i2c_set_clientdata(client, NULL);
-
 	fb_unregister_client(&dcon->fbevent_nb);
 	unregister_reboot_notifier(&dcon->reboot_nb);
 	atomic_notifier_chain_unregister(&panic_notifier_list, &dcon_panic_nb);
-- 
1.7.5.4

