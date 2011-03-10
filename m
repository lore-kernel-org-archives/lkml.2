Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab1CJX5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:57:15 -0500
Received: from kroah.org ([198.145.64.141]:46810 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab1CJX5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:36 2011
Message-Id: <20110310235536.427263200@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [patch 04/29] ASoC: Fix WM9081 platform data initialisation
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 3ee845acba58549578d03a46ed307c0a56c7f777 upstream.

It went AWOL in the multi-component conversion.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm9081.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/soc/codecs/wm9081.c
+++ b/sound/soc/codecs/wm9081.c
@@ -15,6 +15,7 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/device.h>
 #include <linux/pm.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
@@ -1338,6 +1339,10 @@ static __devinit int wm9081_i2c_probe(st
 	wm9081->control_type = SND_SOC_I2C;
 	wm9081->control_data = i2c;
 
+	if (dev_get_platdata(&i2c->dev))
+		memcpy(&wm9081->retune, dev_get_platdata(&i2c->dev),
+		       sizeof(wm9081->retune));
+
 	ret = snd_soc_register_codec(&i2c->dev,
 			&soc_codec_dev_wm9081, &wm9081_dai, 1);
 	if (ret < 0)


