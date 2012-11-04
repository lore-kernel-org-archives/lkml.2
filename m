Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733Ab2KDRrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 12:47:19 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45180 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab2KDRrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 12:47:15 -0500
MIME-Version: 1.0
In-Reply-To: <1351666855-23854-2-git-send-email-yuanhan.liu@linux.intel.com>
References: <1351666855-23854-1-git-send-email-yuanhan.liu@linux.intel.com>
	<1351666855-23854-2-git-send-email-yuanhan.liu@linux.intel.com>
Date: Sun, 4 Nov 2012 18:47:12 +0100
Message-ID: <CACRpkdapHWJAMFn0hUQF52RjBz38MZzD3GS+5+pLfhsKJ+p_GQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: do not call __gpio_xxx under !CONFIG_GPIOLIB
From: Linus Walleij <linus.walleij@linaro.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 8:00 AM, Yuanhan Liu
<yuanhan.liu@linux.intel.com> wrote:

> Those functions are availabe only when CONFIG_GPIOLIB is set. So, we
> should not call them under !CONFIG_GPIOLIB block.
>
> This would fix following build errros:
> include/asm-generic/gpio.h: In function 'gpio_get_value_cansleep':
> include/asm-generic/gpio.h:220:2: error: implicit declaration of function '__gpio_get_value'
> include/asm-generic/gpio.h: In function 'gpio_set_value_cansleep':
> nclude/asm-generic/gpio.h:226:2: error: implicit declaration of function '__gpio_set_value'

OK...

>  static inline int gpio_get_value_cansleep(unsigned gpio)
>  {
> -       might_sleep();

So why are you deleting this very useful might_sleep() runtime
semantic check?

> -       return __gpio_get_value(gpio);
> +       WARN_ON(1);
> +       return 0;
>  }
>
>  static inline void gpio_set_value_cansleep(unsigned gpio, int value)
>  {
> -       might_sleep();
> -       __gpio_set_value(gpio, value);
> +       WARN_ON(1);
>  }

Yours,
Linus Walleij
