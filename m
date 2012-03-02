Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab2CBWdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:33:18 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63127 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab2CBWdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:33:16 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of alan@signal11.us designates 10.236.190.134 as permitted sender) smtp.mail=alan@signal11.us
MIME-Version: 1.0
From: Alan Ott <alan@signal11.us>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Ott <alan@signal11.us>
Subject: [PATCH v2] ARM: tegra: export tegra_gpio_{en,dis}able
Date: Fri,  2 Mar 2012 17:32:24 -0500
Message-Id: <1330727544-11617-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330630010-11241-2-git-send-email-alan@signal11.us>
References: <1330630010-11241-2-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

These two functions are used in drivers that can be
modules, so they need to be exported.

Acked-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Olof Johansson <olof@lixom.net>

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Ott <alan@signal11.us>
---
 drivers/gpio/gpio-tegra.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index bdc2937..96662cc 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -107,11 +107,13 @@ void tegra_gpio_enable(int gpio)
 {
 	tegra_gpio_mask_write(GPIO_MSK_CNF(gpio), gpio, 1);
 }
+EXPORT_SYMBOL_GPL(tegra_gpio_enable);
 
 void tegra_gpio_disable(int gpio)
 {
 	tegra_gpio_mask_write(GPIO_MSK_CNF(gpio), gpio, 0);
 }
+EXPORT_SYMBOL_GPL(tegra_gpio_disable);
 
 static void tegra_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
-- 
1.7.0.4

