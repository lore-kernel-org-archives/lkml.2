Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab1BQA6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 19:58:03 -0500
Received: from xes-mad.com ([216.165.139.218]:35613 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755836Ab1BQA6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 19:58:00 -0500
From: Peter Tyser <ptyser@xes-inc.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Tyser <ptyser@xes-inc.com>, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 3/4] gpio: pca953x: Implement get_direction() hook
Date: Wed, 16 Feb 2011 18:56:55 -0600
Message-Id: <1297904216-15219-3-git-send-email-ptyser@xes-inc.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1297904216-15219-1-git-send-email-ptyser@xes-inc.com>
References: <1297904216-15219-1-git-send-email-ptyser@xes-inc.com>
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
Cc: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Joe Perches <joe@perches.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
---
Changes since v1:
- None

 drivers/gpio/pca953x.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index b473429..66d36b1 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -168,6 +168,16 @@ exit:
 	return ret;
 }
 
+static int pca953x_gpio_get_direction(struct gpio_chip *gc, unsigned off)
+{
+	struct pca953x_chip *chip;
+
+	chip = container_of(gc, struct pca953x_chip, gpio_chip);
+
+	/* return 0 if IO pin is input, 1 if its an output */
+	return chip->reg_direction & (1u << off) ? 0 : 1;
+}
+
 static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
 {
 	struct pca953x_chip *chip;
@@ -221,6 +231,7 @@ static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
 
 	gc->direction_input  = pca953x_gpio_direction_input;
 	gc->direction_output = pca953x_gpio_direction_output;
+	gc->get_direction = pca953x_gpio_get_direction;
 	gc->get = pca953x_gpio_get_value;
 	gc->set = pca953x_gpio_set_value;
 	gc->can_sleep = 1;
-- 
1.7.0.4

