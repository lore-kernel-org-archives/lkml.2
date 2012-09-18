Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab2IRPAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 11:00:18 -0400
Received: from mail1.frequentis.com ([212.186.194.131]:35688 "EHLO
	mail1.frequentis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab2IRPAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 11:00:15 -0400
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Sep 2012 11:00:14 EDT
X-IronPort-AV: E=Sophos;i="4.80,443,1344204000"; 
   d="scan'208";a="13452504"
Date: Tue, 18 Sep 2012 16:50:06 +0200
From: Christian Engelmayer <christian.engelmayer@frequentis.com>
To: <linux-kernel@vger.kernel.org>
CC: <christian.engelmayer@frequentis.com>, <grant.likely@secretlab.ca>
Subject: [PATCH] gpio-pcf857x: avoid an empty kernel message in case no irq
 is configured
Message-ID: <20120918165006.3852c06d@frequentis.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid a needless kernel message in case there is no client irq to be ignored.

   [    2.856058] gpiochip_add: registered GPIOs 248 to 255 on device: pcf8574
   [    2.862830] pcf857x 1-0020:

Signed-off-by: Christian Engelmayer <christian.engelmayer@frequentis.com>
---
--- a/drivers/gpio/gpio-pcf857x.c	2012-07-06 09:19:07.000000000 +0200
+++ b/drivers/gpio/gpio-pcf857x.c	2012-07-06 09:21:15.000000000 +0200
@@ -290,8 +290,8 @@ static int pcf857x_probe(struct i2c_clie
 	 * methods can't be called from sleeping contexts.
 	 */
 
-	dev_info(&client->dev, "%s\n",
-			client->irq ? " (irq ignored)" : "");
+	if (client->irq)
+		dev_info(&client->dev, " (irq ignored)\n");
 
 	/* Let platform code set up the GPIOs and their users.
 	 * Now is the first time anyone could use them.
