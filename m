Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab0CTOQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:16:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59183 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab0CTOQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:16:13 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Date: Sat, 20 Mar 2010 15:13:00 +0100
Message-Id: <1269094385-16114-20-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 19/24] staging/dream: fix dangling pointers
X-SA-Exim-Version: 4.2.1 (built Sat, 01 Aug 2009 12:09:26 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix I2C-drivers which missed setting clientdata to NULL before freeing the
structure it points to. Also fix drivers which do this _after_ the structure
was freed already.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---

Found using coccinelle, then reviewed. Full patchset is available via
kernel-janitors, linux-i2c, and LKML.
---
 drivers/staging/dream/synaptics_i2c_rmi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/dream/synaptics_i2c_rmi.c b/drivers/staging/dream/synaptics_i2c_rmi.c
index 4de6bc9..a318c18 100644
--- a/drivers/staging/dream/synaptics_i2c_rmi.c
+++ b/drivers/staging/dream/synaptics_i2c_rmi.c
@@ -534,6 +534,7 @@ err_input_register_device_failed:
 err_input_dev_alloc_failed:
 err_detect_failed:
 err_power_failed:
+	i2c_set_clientdata(client, NULL);
 	kfree(ts);
 err_alloc_data_failed:
 err_check_functionality_failed:
@@ -551,6 +552,7 @@ static int synaptics_ts_remove(struct i2c_client *client)
 	else
 		hrtimer_cancel(&ts->timer);
 	input_unregister_device(ts->input_dev);
+	i2c_set_clientdata(client, NULL);
 	kfree(ts);
 	return 0;
 }
-- 
1.7.0

