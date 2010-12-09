Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab0LIM5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 07:57:43 -0500
Received: from smtp.nokia.com ([147.243.1.47]:64713 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278Ab0LIM5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 07:57:41 -0500
From: Aaro Koskinen <aaro.koskinen@nokia.com>
To: eric.y.miao@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpiolib: gpio_request_one(): add missing gpio_free()
Date: Thu,  9 Dec 2010 14:58:30 +0200
Message-Id: <1291899510-19861-1-git-send-email-aaro.koskinen@nokia.com>
X-Mailer: git-send-email 1.5.6.5
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If GPIO request succeeds, but configuration fails, it should be released.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
---
 drivers/gpio/gpiolib.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 21da9c1..649550e 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1281,6 +1281,9 @@ int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
 		err = gpio_direction_output(gpio,
 				(flags & GPIOF_INIT_HIGH) ? 1 : 0);
 
+	if (err)
+		gpio_free(gpio);
+
 	return err;
 }
 EXPORT_SYMBOL_GPL(gpio_request_one);
-- 
1.5.6.5

