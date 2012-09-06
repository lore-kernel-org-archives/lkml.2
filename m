Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab2IFHi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 03:38:59 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:17928 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab2IFHi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 03:38:58 -0400
Date: Thu, 6 Sep 2012 09:38:47 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Tyser <ptyser@xes-inc.com>, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] gpio-ich: Add missing spinlock init
Message-ID: <20120906093847.3a034c1f@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by CONFIG_DEBUG_SPINLOCK=y.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Peter Tyser <ptyser@xes-inc.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org [v3.5+]
---
 drivers/gpio/gpio-ich.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-3.6-rc4.orig/drivers/gpio/gpio-ich.c	2012-09-04 13:34:03.000000000 +0200
+++ linux-3.6-rc4/drivers/gpio/gpio-ich.c	2012-09-06 08:08:57.571210424 +0200
@@ -390,6 +390,7 @@ static int __devinit ichx_gpio_probe(str
 		return -ENODEV;
 	}
 
+	spin_lock_init(&ichx_priv.lock);
 	res_base = platform_get_resource(pdev, IORESOURCE_IO, ICH_RES_GPIO);
 	ichx_priv.use_gpio = ich_info->use_gpio;
 	err = ichx_gpio_request_regions(res_base, pdev->name,


-- 
Jean Delvare
