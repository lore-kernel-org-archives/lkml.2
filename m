Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab0CTOQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:16:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59214 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab0CTOQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:16:29 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Date: Sat, 20 Mar 2010 15:13:03 +0100
Message-Id: <1269094385-16114-23-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 22/24] staging/iio/light: fix dangling pointers
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
 drivers/staging/iio/light/tsl2563.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/light/tsl2563.c b/drivers/staging/iio/light/tsl2563.c
index 78b9432..286559d 100644
--- a/drivers/staging/iio/light/tsl2563.c
+++ b/drivers/staging/iio/light/tsl2563.c
@@ -681,6 +681,7 @@ static int __devinit tsl2563_probe(struct i2c_client *client,
 fail2:
 	iio_device_unregister(chip->indio_dev);
 fail1:
+	i2c_set_clientdata(client, NULL);
 	kfree(chip);
 	return err;
 }
@@ -691,6 +692,7 @@ static int tsl2563_remove(struct i2c_client *client)
 
 	iio_device_unregister(chip->indio_dev);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(chip);
 	return 0;
 }
-- 
1.7.0

