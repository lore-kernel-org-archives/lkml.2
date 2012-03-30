Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934670Ab2C3UFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:05:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53461 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934628Ab2C3UFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:05:35 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel@pengutronix.de, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH v2 11/15] gpio/samsung: mark const init data with __initconst instead of __initdata
Date: Fri, 30 Mar 2012 22:05:01 +0200
Message-Id: <1333137905-13809-11-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120330200358.GV15647@pengutronix.de>
References: <20120330200358.GV15647@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As long as there is no other non-const variable marked __initdata in the
same compilation unit it doesn't hurt. If there were one however
compilation would fail with

	error: $variablename causes a section type conflict

because a section containing const variables is marked read only and so
cannot contain non-const variables.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>
---
no changes since (implicit) v1

 drivers/gpio/gpio-samsung.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 4627787..fee2e85 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -2681,7 +2681,7 @@ static int exynos_gpio_xlate(struct gpio_chip *gc,
 	return gpiospec->args[0];
 }
 
-static const struct of_device_id exynos_gpio_dt_match[] __initdata = {
+static const struct of_device_id exynos_gpio_dt_match[] __initconst = {
 	{ .compatible = "samsung,exynos4-gpio", },
 	{}
 };
-- 
1.7.9.5

