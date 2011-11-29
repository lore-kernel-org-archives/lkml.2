Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1LCIVW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 03:21:22 -0500
Received: from www17.your-server.de ([213.133.104.17]:58097 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab1LCIU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 03:20:56 -0500
Subject: [PATCH] leds: Use kcalloc instead of kzalloc to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.309.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/leds/leds-mc13783.c b/drivers/leds/leds-mc13783.c
--- a/drivers/leds/leds-mc13783.c 2011-11-13 11:07:27.873510772 +0100
+++ b/drivers/leds/leds-mc13783.c 2011-11-28 19:59:58.327155325 +0100
@@ -280,7 +280,7 @@ static int __devinit mc13783_led_probe(s
 		return -EINVAL;
 	}
 
-	led = kzalloc(sizeof(*led) * pdata->num_leds, GFP_KERNEL);
+	led = kcalloc(pdata->num_leds, sizeof(*led), GFP_KERNEL);
 	if (led == NULL) {
 		dev_err(&pdev->dev, "failed to alloc memory\n");
 		return -ENOMEM;
