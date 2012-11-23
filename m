Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2KWM67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:58:59 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60454 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab2KWM65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:58:57 -0500
MIME-Version: 1.0
In-Reply-To: <1353674665-31905-1-git-send-email-lee.jones@linaro.org>
References: <1353674665-31905-1-git-send-email-lee.jones@linaro.org>
Date: Fri, 23 Nov 2012 18:28:32 +0530
Message-ID: <CAKohponCWA62+C31nm8QoA5cANPQ09BsU4Sd-x07kA8G_g+AvQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] gpio: Provide the STMPE GPIO driver with its own IRQ Domain
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 November 2012 18:14, Lee Jones <lee.jones@linaro.org> wrote:
> The STMPE GPIO driver can be used as an IRQ controller by some
> related devices. Here we provide it with its very own IRQ Domain
> so that IRQs can be issued dynamically. This will stand the
> driver in good stead when it is enabled for Device Tree, as this
> it a prerequisite.
>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c

> +const struct irq_domain_ops stmpe_gpio_irq_simple_ops = {

static?

> +       .unmap = stmpe_gpio_irq_unmap,
> +       .map = stmpe_gpio_irq_map,
> +       .xlate = irq_domain_xlate_twocell,
> +};


Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
