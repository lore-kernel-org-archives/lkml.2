Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab1KXIKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 03:10:05 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46513 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab1KXIKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 03:10:03 -0500
Message-ID: <1322122197.10476.5.camel@phoenix>
Subject: [PATCH 3/3] leds: Convert leds-dac124s085 to module_spi_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Guennadi Liakhovetski <lg@denx.de>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 24 Nov 2011 16:09:57 +0800
In-Reply-To: <1322122004.10476.1.camel@phoenix>
References: <1322122004.10476.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out some boilerplate code for spi driver registration
into module_spi_driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-dac124s085.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/leds/leds-dac124s085.c b/drivers/leds/leds-dac124s085.c
index 31cf0d6..d56c142 100644
--- a/drivers/leds/leds-dac124s085.c
+++ b/drivers/leds/leds-dac124s085.c
@@ -131,18 +131,7 @@ static struct spi_driver dac124s085_driver = {
 	},
 };
 
-static int __init dac124s085_leds_init(void)
-{
-	return spi_register_driver(&dac124s085_driver);
-}
-
-static void __exit dac124s085_leds_exit(void)
-{
-	spi_unregister_driver(&dac124s085_driver);
-}
-
-module_init(dac124s085_leds_init);
-module_exit(dac124s085_leds_exit);
+module_spi_driver(dac124s085_driver);
 
 MODULE_AUTHOR("Guennadi Liakhovetski <lg@denx.de>");
 MODULE_DESCRIPTION("DAC124S085 LED driver");
-- 
1.7.5.4



