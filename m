Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab2LYCxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 21:53:01 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:38212 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2LYCw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 21:52:59 -0500
Message-ID: <1356403969.22368.1.camel@phoenix>
Subject: [PATCH] mfd: pcf50633: Init pcf->dev before using it
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Harald Welte <laforge@openmoko.org>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-kernel@vger.kernel.org
Date: Tue, 25 Dec 2012 10:52:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code uses pcf->dev in the dev_err call before setting it to
&client->dev. Fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/mfd/pcf50633-core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 64803f1..d115673 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -208,6 +208,8 @@ static int pcf50633_probe(struct i2c_client *client,
 	if (!pcf)
 		return -ENOMEM;
 
+	i2c_set_clientdata(client, pcf);
+	pcf->dev = &client->dev;
 	pcf->pdata = pdata;
 
 	mutex_init(&pcf->lock);
@@ -219,9 +221,6 @@ static int pcf50633_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	i2c_set_clientdata(client, pcf);
-	pcf->dev = &client->dev;
-
 	version = pcf50633_reg_read(pcf, 0);
 	variant = pcf50633_reg_read(pcf, 1);
 	if (version < 0 || variant < 0) {
-- 
1.7.9.5



