Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934614Ab2C3UF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:05:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53399 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934280Ab2C3UFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:05:25 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel@pengutronix.de, Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH v2 01/15] pinctrl: mark const init data with __initconst instead of __initdata
Date: Fri, 30 Mar 2012 22:04:51 +0200
Message-Id: <1333137905-13809-1-git-send-email-u.kleine-koenig@pengutronix.de>
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
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
---
changes since (implict) v1:
 - move __initconst after variable name

 Documentation/pinctrl.txt        |    2 +-
 drivers/pinctrl/pinctrl-coh901.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index d97bccf..30b53ed 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -786,7 +786,7 @@ and spi on the second function mapping:
 
 #include <linux/pinctrl/machine.h>
 
-static const struct pinctrl_map __initdata mapping[] = {
+static const struct pinctrl_map mapping[] __initconst = {
 	{
 		.dev_name = "foo-spi.0",
 		.name = PINCTRL_STATE_DEFAULT,
diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index 0797eba..55697a5 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -174,7 +174,7 @@ struct u300_gpio_confdata {
 
 
 /* Initial configuration */
-static const struct __initdata u300_gpio_confdata
+static const struct __initconst u300_gpio_confdata
 bs335_gpio_config[BS335_GPIO_NUM_PORTS][U300_GPIO_PINS_PER_PORT] = {
 	/* Port 0, pins 0-7 */
 	{
@@ -255,7 +255,7 @@ bs335_gpio_config[BS335_GPIO_NUM_PORTS][U300_GPIO_PINS_PER_PORT] = {
 	}
 };
 
-static const struct __initdata u300_gpio_confdata
+static const struct __initconst u300_gpio_confdata
 bs365_gpio_config[BS365_GPIO_NUM_PORTS][U300_GPIO_PINS_PER_PORT] = {
 	/* Port 0, pins 0-7 */
 	{
-- 
1.7.9.5

