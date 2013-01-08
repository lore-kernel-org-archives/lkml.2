Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab3AHM7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 07:59:47 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64734 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab3AHM7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 07:59:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 1/4] gpiolib: introduce descriptor-based GPIO interface
Date: Tue, 8 Jan 2013 12:59:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Alexandre Courbot <gnurou@gmail.com>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <1357629535-26033-2-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1357629535-26033-2-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301081259.29839.arnd@arndb.de>
X-Provags-ID: V02:K0:J9bwHPZ5H+WvY4rhF3/UIYXWIm5rqEpcqgQfgD9nv5z
 GlFIgEZPQutNMSt6QnHY/bu/OVYBNPtNwv6ZejuScCQQHlzWUG
 zQ8iEPdhc5zm058LS6G6rNKl/hxx4jF5IwlTdP1aAU1NGCLi86
 NhIrkVZURozfNpZFYs9PuXAqTBA9NxVL1ROxgQtH8IzEv6P2D8
 BwmUKXl57UhWSxlGih9hPO4KER136iu9F2D5rVBxD+Kq3pVXwl
 IsraM2rE6j+CnOlRfMBPlwlYqFju2iZfO60DaDGpWMmos3mXUT
 MDfQHjA8scs/zWCM6+Q7/3GU0+WIuqSjBrFMC1YrF9BB4MbD7A
 DBg2mfNoRSs7uJF2xixo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2013, Alexandre Courbot wrote:
> +struct gpio_desc *__must_check devm_gpiod_get(struct device *dev,
> +                                                    const char *con_id)
> +{
> +       struct gpio_desc **dr;
> +       struct gpio_desc *desc;
> +
> +       dr = devres_alloc(devm_gpio_release, sizeof(struct gpio_desc *),
> +                         GFP_KERNEL);
> +       if (!dr)
> +               return ERR_PTR(-ENOMEM);
> +
> +       desc = gpiod_get(dev, con_id);
> +       if (IS_ERR_OR_NULL(desc)) {
> +               devres_free(dr);
> +               return desc;
> +       }

Please avoid the use of IS_ERR_OR_NULL(), especially on interfaces you
introduce yourself. AFAICT, gpiod_get cannot return NULL, so you
should not check for that.

> +       *dr = desc;
> +       devres_add(dev, dr);
> +
> +       return 0;
> +}

I'm pretty sure you meant to write 'return desc;' here.

	Arnd
