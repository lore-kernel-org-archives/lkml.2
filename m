Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab0IBJQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 05:16:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56581 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab0IBJQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 05:16:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ptShqNWx4KA53Mw9YQHO0NpWhUKf2e4uR91IrmDV7MdR9gANplYJ0CUOBVLTtvGFeC
         2Uw4vBrlmT6hehURS1A3KpeS+P4Se/vg/9SNTj4omvP2IVSc8lgVWD5SK5phuqEInvUA
         jp86n6vYfdDz46fG17WcUjXpFS6/eu4IJJ32k=
Subject: Input: tps6507x-ts - add missing platform_set_drvdata() in
	tps6507x_ts_probe()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Todd Fischer <todd.fischer@ridgerun.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain
Date: Thu, 02 Sep 2010 17:20:41 +0800
Message-Id: <1283419241.19272.9.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call platform_get_drvdata() in tps6507x_ts_remove(),
thus we should call platform_set_drvdata() in tps6507x_ts_probe().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/touchscreen/tps6507x-ts.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/tps6507x-ts.c b/drivers/input/touchscreen/tps6507x-ts.c
index a644d18..7286209 100644
--- a/drivers/input/touchscreen/tps6507x-ts.c
+++ b/drivers/input/touchscreen/tps6507x-ts.c
@@ -335,6 +335,7 @@ static int tps6507x_ts_probe(struct platform_device *pdev)
 		dev_err(tsc->dev, "schedule failed");
 		goto err2;
 	 }
+	platform_set_drvdata(pdev, tps6507x_dev);
 
 	return 0;
 
-- 
1.7.2



