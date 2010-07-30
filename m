Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975Ab0G3R7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:59:48 -0400
Received: from kroah.org ([198.145.64.141]:59140 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932739Ab0G3R53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:29 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:49 2010
Message-Id: <20100730175149.385225008@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [170/205] mfd: Remove unneeded and dangerous clearing of clientdata
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wolfram Sang <w.sang@pengutronix.de>

commit 28ade0f217a3a3ff992b01e06e6e425c250a8406 upstream.

Unlike real i2c-devices which get detached from the driver, dummy-devices
get truly unregistered. So, there has never been a need to clear the
clientdata because the device will go away anyhow. For the occasions fixed
here, clearing clientdata was even dangerous as the structure was freed
already.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/88pm860x-i2c.c |    1 -
 drivers/mfd/max8925-i2c.c  |    2 --
 2 files changed, 3 deletions(-)

--- a/drivers/mfd/88pm860x-i2c.c
+++ b/drivers/mfd/88pm860x-i2c.c
@@ -200,7 +200,6 @@ static int __devexit pm860x_remove(struc
 
 	pm860x_device_exit(chip);
 	i2c_unregister_device(chip->companion);
-	i2c_set_clientdata(chip->companion, NULL);
 	i2c_set_clientdata(chip->client, NULL);
 	kfree(chip);
 	return 0;
--- a/drivers/mfd/max8925-i2c.c
+++ b/drivers/mfd/max8925-i2c.c
@@ -173,8 +173,6 @@ static int __devexit max8925_remove(stru
 	max8925_device_exit(chip);
 	i2c_unregister_device(chip->adc);
 	i2c_unregister_device(chip->rtc);
-	i2c_set_clientdata(chip->adc, NULL);
-	i2c_set_clientdata(chip->rtc, NULL);
 	i2c_set_clientdata(chip->i2c, NULL);
 	kfree(chip);
 	return 0;


