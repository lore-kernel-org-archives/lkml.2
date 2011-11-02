Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab1KBURG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:17:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57791 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1KBURE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:17:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAO_0yfOa7B4tB1nJg8c_5a612KjNmPh_aMvS=wHhfU_maAvZAg@mail.gmail.com>
References: <CAO_0yfOa7B4tB1nJg8c_5a612KjNmPh_aMvS=wHhfU_maAvZAg@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 2 Nov 2011 16:16:41 -0400
Message-ID: <CAMjpGUe_g9b3b+3nfi-h2k4-9WqFh1HwQ9aes6H5oUnKWRUAgQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: fix build error in include/asm-generic/gpio.h
To: Hamo <hamo.by@gmail.com>
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 21:38, Hamo wrote:
> Should call the platform-specific __gpio_{get,set}_value
> instead of generic gpio_{get,set}_value
>
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
>
>  static inline int gpio_get_value_cansleep(unsigned gpio)
>  {
>        might_sleep();
> -       return gpio_get_value(gpio);
> +       return __gpio_get_value(gpio);
>  }
>
>  static inline void gpio_set_value_cansleep(unsigned gpio, int value)
>  {
>        might_sleep();
> -       gpio_set_value(gpio, value);
> +       __gpio_set_value(gpio, value);
>  }

your change log says very little, and this change looks incorrect to
me.  __gpio_xxx type funcs exist in the GPIOLIB case, not in the
!GPIOLIB case.  your patch is changing the !GPIOLIB case.  so i don't
see how this could work: you're now calling funcs which are not
guaranteed to exist.

i notice this because i'm seeing build failures for somethings that
are using asm-generic/gpio.h, but not GPIOLIB.

so could you explain why exactly you need this and why you think this
is the right route to go ?
-mike
