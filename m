Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab2EYNeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:34:22 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:31842
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754198Ab2EYNeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:34:18 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bhf0ah)
X-FB-SS: 0,
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <devicetree-discuss@lists.ozlabs.org>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <b29396@freescale.com>
Subject: [PATCH v4 2/6] gpio: re-add of_node_to_gpiochip function
Date: Fri, 25 May 2012 21:36:16 +0800
Message-ID: <1337952980-14621-2-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337952980-14621-1-git-send-email-b29396@freescale.com>
References: <1337952980-14621-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 drivers/gpio/gpiolib-of.c |   11 +++++++++++
 include/linux/of_gpio.h   |    5 +++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 8389d4a..b8010a9 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -234,3 +234,14 @@ void of_gpiochip_remove(struct gpio_chip *chip)
 	if (chip->of_node)
 		of_node_put(chip->of_node);
 }
+
+/* Private function for resolving node pointer to gpio_chip */
+static int of_gpiochip_is_match(struct gpio_chip *chip, void *data)
+{
+	return chip->of_node == data;
+}
+
+struct gpio_chip *of_node_to_gpiochip(struct device_node *np)
+{
+	return gpiochip_find(np, of_gpiochip_is_match);
+}
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index c454f57..880783b 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -61,6 +61,7 @@ extern void of_gpiochip_remove(struct gpio_chip *gc);
 extern int of_gpio_simple_xlate(struct gpio_chip *gc,
 				const struct of_phandle_args *gpiospec,
 				u32 *flags);
+extern struct gpio_chip *of_node_to_gpiochip(struct device_node *np);
 
 #else /* CONFIG_OF_GPIO */
 
@@ -84,6 +85,10 @@ static inline int of_gpio_simple_xlate(struct gpio_chip *gc,
 	return -ENOSYS;
 }
 
+static struct gpio_chip *of_node_to_gpiochip(struct device_node *np)
+{
+	return NULL;
+}
 static inline void of_gpiochip_add(struct gpio_chip *gc) { }
 static inline void of_gpiochip_remove(struct gpio_chip *gc) { }
 
-- 
1.7.0.4


