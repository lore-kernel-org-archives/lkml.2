Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab2LNQXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:23:06 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:36660 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab2LNQUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:20:07 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org,
        Paer-Olof Haakansson <par-olof.hakansson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/21] gpio: ab8500: Allow gpios to wake the system from suspend
Date: Fri, 14 Dec 2012 16:19:30 +0000
Message-Id: <1355501979-1157-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paer-Olof Haakansson <par-olof.hakansson@stericsson.com>

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Paer-Olof Haakansson <par-olof.hakansson@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index 8616368..ef75984 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -329,12 +329,12 @@ static void ab8500_gpio_irq_sync_unlock(struct irq_data *data)
 		if (rising)
 			ret = request_threaded_irq(irq_to_rising(irq),
 					NULL, handle_rising,
-					IRQF_TRIGGER_RISING,
+					IRQF_TRIGGER_RISING | IRQF_NO_SUSPEND,
 					"ab8500-gpio-r", ab8500_gpio);
 		if (falling)
 			ret = request_threaded_irq(irq_to_falling(irq),
 				       NULL, handle_falling,
-				       IRQF_TRIGGER_FALLING,
+				       IRQF_TRIGGER_FALLING | IRQF_NO_SUSPEND,
 				       "ab8500-gpio-f", ab8500_gpio);
 		break;
 	case SHUTDOWN:
-- 
1.7.9.5

