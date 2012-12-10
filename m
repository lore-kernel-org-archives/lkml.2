Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab2LJI6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:58:52 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49158 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2LJI4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:56:25 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 04/12] regulator: gpio-regulator: gpio_set_value should use cansleep
Date: Mon, 10 Dec 2012 08:55:53 +0000
Message-Id: <1355129761-8088-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If it's possible for gpio_set_value to sleep, we should be using
the *_cansleep call instead. This patch fixes multiple warnings
from gpiolib.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/gpio-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 5462c28..90f5221 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -82,7 +82,7 @@ static int gpio_regulator_set_voltage(struct regulator_dev *dev,
 
 	for (ptr = 0; ptr < data->nr_gpios; ptr++) {
 		state = (target & (1 << ptr)) >> ptr;
-		gpio_set_value(data->gpios[ptr].gpio, state);
+		gpio_set_value_cansleep(data->gpios[ptr].gpio, state);
 	}
 	data->state = target;
 
@@ -119,7 +119,7 @@ static int gpio_regulator_set_current_limit(struct regulator_dev *dev,
 
 	for (ptr = 0; ptr < data->nr_gpios; ptr++) {
 		state = (target & (1 << ptr)) >> ptr;
-		gpio_set_value(data->gpios[ptr].gpio, state);
+		gpio_set_value_cansleep(data->gpios[ptr].gpio, state);
 	}
 	data->state = target;
 
-- 
1.7.9.5

