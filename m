Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab1CAX3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:29:11 -0500
Received: from xes-mad.com ([216.165.139.218]:46770 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445Ab1CAX3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:29:10 -0500
From: Peter Tyser <ptyser@xes-inc.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Tyser <ptyser@xes-inc.com>, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v5 3/4] gpio: pca953x: Implement get_direction() hook
Date: Tue,  1 Mar 2011 17:28:19 -0600
Message-Id: <1299022100-14564-3-git-send-email-ptyser@xes-inc.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1299022100-14564-1-git-send-email-ptyser@xes-inc.com>
References: <1299022100-14564-1-git-send-email-ptyser@xes-inc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the get_direction() function allows the accurate GPIO pin
direction data to be shown in sysfs.  Previously, the direction was
was always initialized to 'unknown'.

Cc: Alek Du <alek.du@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Joe Perches <joe@perches.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
---
Changes since v1:
- None

Changes since v2:
- Use GPIOF_DIR_* defines

Changes since v3:
- None

Change since V4:
- None

 drivers/gpio/pca953x.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index b473429..b93611f 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -168,6 +168,15 @@ exit:
 	return ret;
 }
 
+static int pca953x_gpio_get_direction(struct gpio_chip *gc, unsigned off)
+{
+	struct pca953x_chip *chip;
+
+	chip = container_of(gc, struct pca953x_chip, gpio_chip);
+
+	return chip->reg_direction & (1u << off) ? GPIOF_DIR_IN : GPIOF_DIR_OUT;
+}
+
 static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
 {
 	struct pca953x_chip *chip;
@@ -221,6 +230,7 @@ static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
 
 	gc->direction_input  = pca953x_gpio_direction_input;
 	gc->direction_output = pca953x_gpio_direction_output;
+	gc->get_direction = pca953x_gpio_get_direction;
 	gc->get = pca953x_gpio_get_value;
 	gc->set = pca953x_gpio_set_value;
 	gc->can_sleep = 1;
-- 
1.7.0.4

