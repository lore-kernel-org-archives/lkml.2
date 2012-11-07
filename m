Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143Ab2KGFLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 00:11:53 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57330 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2KGFLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 00:11:52 -0500
MIME-Version: 1.0
In-Reply-To: <1352215003-30268-1-git-send-email-linus.walleij@stericsson.com>
References: <1352215003-30268-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 7 Nov 2012 10:41:51 +0530
X-Google-Sender-Auth: hnbhqgcctKpkmDZvcx3aFXYmiNA
Message-ID: <CAOh2x==WYpq_hZa9bZhDNhD_ptE3hw3hBBugtyRu4AN0qetyTw@mail.gmail.com>
Subject: Re: [PATCH 2/5] gpiolib-of: staticize the pin range calls
From: viresh kumar <viresh.kumar@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 November 2012 20:46, Linus Walleij <linus.walleij@stericsson.com> wrote:
diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c

 #ifdef CONFIG_PINCTRL
-void of_gpiochip_add_pin_range(struct gpio_chip *chip)
+static void of_gpiochip_add_pin_range(struct gpio_chip *chip)
 {
        struct device_node *np = chip->of_node;
        struct gpio_pin_range *pin_range;
@@ -254,7 +254,7 @@ void of_gpiochip_add_pin_range(struct gpio_chip *chip)
        } while (index++);
 }

-void of_gpiochip_remove_pin_range(struct gpio_chip *chip)
+static void of_gpiochip_remove_pin_range(struct gpio_chip *chip)
 {
        struct gpio_pin_range *pin_range, *tmp;

@@ -265,8 +265,8 @@ void of_gpiochip_remove_pin_range(struct gpio_chip *chip)
        }
 }
 #else
-void of_gpiochip_add_pin_range(struct gpio_chip *chip) {}
-void of_gpiochip_remove_pin_range(struct gpio_chip *chip) {}
+static void of_gpiochip_add_pin_range(struct gpio_chip *chip) {}
+static void of_gpiochip_remove_pin_range(struct gpio_chip *chip) {}

Maybe static inline??

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
