Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab1LAIit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:38:49 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51123 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab1LAIir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:38:47 -0500
Message-ID: <1322728721.14554.6.camel@phoenix>
Subject: [PATCH 2/2] leds: netxbig: Use gpio_request_one()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Simon Guinot <sguinot@lacie.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>
Date: Thu, 01 Dec 2011 16:38:41 +0800
In-Reply-To: <1322728636.14554.4.camel@phoenix>
References: <1322728636.14554.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use gpio_request_one() instead of multiple gpiolib calls.
This also simplifies error handling a bit.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-netxbig.c |   24 ++++++------------------
 1 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/leds/leds-netxbig.c b/drivers/leds/leds-netxbig.c
index 8c7a4ea..d8433f2 100644
--- a/drivers/leds/leds-netxbig.c
+++ b/drivers/leds/leds-netxbig.c
@@ -81,35 +81,23 @@ static int __devinit gpio_ext_init(struct netxbig_gpio_ext *gpio_ext)
 
 	/* Configure address GPIOs. */
 	for (i = 0; i < gpio_ext->num_addr; i++) {
-		err = gpio_request(gpio_ext->addr[i], "GPIO extension addr");
+		err = gpio_request_one(gpio_ext->addr[i], GPIOF_OUT_INIT_LOW,
+				       "GPIO extension addr");
 		if (err)
 			goto err_free_addr;
-		err = gpio_direction_output(gpio_ext->addr[i], 0);
-		if (err) {
-			gpio_free(gpio_ext->addr[i]);
-			goto err_free_addr;
-		}
 	}
 	/* Configure data GPIOs. */
 	for (i = 0; i < gpio_ext->num_data; i++) {
-		err = gpio_request(gpio_ext->data[i], "GPIO extension data");
+		err = gpio_request_one(gpio_ext->data[i], GPIOF_OUT_INIT_LOW,
+				   "GPIO extension data");
 		if (err)
 			goto err_free_data;
-		err = gpio_direction_output(gpio_ext->data[i], 0);
-		if (err) {
-			gpio_free(gpio_ext->data[i]);
-			goto err_free_data;
-		}
 	}
 	/* Configure "enable select" GPIO. */
-	err = gpio_request(gpio_ext->enable, "GPIO extension enable");
+	err = gpio_request_one(gpio_ext->enable, GPIOF_OUT_INIT_LOW,
+			       "GPIO extension enable");
 	if (err)
 		goto err_free_data;
-	err = gpio_direction_output(gpio_ext->enable, 0);
-	if (err) {
-		gpio_free(gpio_ext->enable);
-		goto err_free_data;
-	}
 
 	return 0;
 
-- 
1.7.5.4



