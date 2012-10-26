Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab2JZG7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:59:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48961 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab2JZG7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:59:51 -0400
X-Greylist: delayed 172019 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2012 02:59:51 EDT
Date: Fri, 26 Oct 2012 09:59:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>, Ryan Mallon <rmallon@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] gpiolib: unlock on error in gpio_export()
Message-ID: <20121026065942.GB9284@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to unlock here before returning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Only needed in linux-next.

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d5f9742..14251c3 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -728,7 +728,8 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 				__func__, gpio,
 				test_bit(FLAG_REQUESTED, &desc->flags),
 				test_bit(FLAG_EXPORT, &desc->flags));
-		return -EPERM;
+		status = -EPERM;
+		goto fail_unlock;
 	}
 
 	if (!desc->chip->direction_input || !desc->chip->direction_output)
