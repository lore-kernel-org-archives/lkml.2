Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab1ITRmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:42:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58940 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1ITRmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:42:18 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] drivers: base: print rejected matches with DEBUG_DRIVER
Date: Tue, 20 Sep 2011 19:41:17 +0200
Message-Id: <1316540477-21383-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.5.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When DEBUG_DRIVER is activated, be verbose and explicitly state when a
device<->driver match was rejected by the probe-function of the driver.
Now all code-paths report what is currently happening which helps
debugging, because you don't have to remember that no printout means
the match is rejected (and then you still don't know if it was because
of ENODEV or ENXIO).

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---

Patch is tested on a ppc-based MPC5121 board with 3.1-rc6

 drivers/base/dd.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 6658da7..142e3d600 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -147,6 +147,9 @@ probe_failed:
 		printk(KERN_WARNING
 		       "%s: probe of %s failed with error %d\n",
 		       drv->name, dev_name(dev), ret);
+	} else {
+		pr_debug("%s: probe of %s rejects match %d\n",
+		       drv->name, dev_name(dev), ret);
 	}
 	/*
 	 * Ignore errors returned by ->probe so that the next driver can try
-- 
1.7.5.4

