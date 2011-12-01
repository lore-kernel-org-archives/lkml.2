Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1LABzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 20:55:19 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62342 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab1LABzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 20:55:14 -0500
Message-ID: <1322704507.11560.8.camel@phoenix>
Subject: [PATCH 4/4] mfd: twl6040-core: Use gpio_request_one
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Misael Lopez Cruz <misael.lopez@ti.com>,
        Jorge Eduardo Candelaria <jorge.candelaria@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 01 Dec 2011 09:55:07 +0800
In-Reply-To: <1322704074.11560.3.camel@phoenix>
References: <1322704074.11560.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use gpio_request_one() instead of multiple gpiolib calls.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/twl6040-core.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 268f80f..e57b1d1 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -509,13 +509,10 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
 		twl6040->audpwron = -EINVAL;
 
 	if (gpio_is_valid(twl6040->audpwron)) {
-		ret = gpio_request(twl6040->audpwron, "audpwron");
+		ret = gpio_request_one(twl6040->audpwron, GPIOF_OUT_INIT_LOW,
+				       "audpwron");
 		if (ret)
 			goto gpio1_err;
-
-		ret = gpio_direction_output(twl6040->audpwron, 0);
-		if (ret)
-			goto gpio2_err;
 	}
 
 	/* codec interrupt */
-- 
1.7.5.4



