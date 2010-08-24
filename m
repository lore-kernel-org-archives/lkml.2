Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934393Ab0HXXlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:41:03 -0400
Received: from kroah.org ([198.145.64.141]:52418 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932784Ab0HXW6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:06 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:12 2010
Message-Id: <20100824224212.578234364@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:41:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [06/91] regulator: Default GPIO controlled WM8994 regulators to disabled
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joonyoung Shim <jy0922.shim@samsung.com>

commit c4604e49c1a5832a58789a22eba7ca982933e1be upstream.

This ensures that if the GPIO was not enabled prior to the driver
starting the regulator API will insert the required powerup ramp
delay when it enables the regulator.  The gpiolib API does not
provide this information.

[Rewrote changelog to describe the actual change -- broonie.]

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/regulator/wm8994-regulator.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -219,8 +219,6 @@ static __devinit int wm8994_ldo_probe(st
 
 	ldo->wm8994 = wm8994;
 
-	ldo->is_enabled = true;
-
 	if (pdata->ldo[id].enable && gpio_is_valid(pdata->ldo[id].enable)) {
 		ldo->enable = pdata->ldo[id].enable;
 
@@ -237,7 +235,8 @@ static __devinit int wm8994_ldo_probe(st
 				ret);
 			goto err_gpio;
 		}
-	}
+	} else
+		ldo->is_enabled = true;
 
 	ldo->regulator = regulator_register(&wm8994_ldo_desc[id], &pdev->dev,
 					     pdata->ldo[id].init_data, ldo);


