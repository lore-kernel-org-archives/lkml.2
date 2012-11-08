Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab2KHNGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:06:40 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60069 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab2KHNGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:06:38 -0500
MIME-Version: 1.0
In-Reply-To: <20121107154837.05c74508452d69930b624280@canb.auug.org.au>
References: <20121107154837.05c74508452d69930b624280@canb.auug.org.au>
Date: Thu, 8 Nov 2012 14:06:37 +0100
Message-ID: <CACRpkdb4LVG8TG58DmUMHRL3r0r4hn7wh-y47metBwth5c52-A@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (pinctrl
 tree related)
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shiraz Hashim <shiraz.hashim@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 5:48 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Caused by commit e8321df59155 ("gpiolib: iron out include ladder
> mistakes") (and some earlier ones) from the pinctrl tree.
>
> I added this patch for today (there may be a better return value from
> gpiochip_add_pin_range):
(..)
> +struct gpio_chip;
> +
>  static inline int
>  gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
>                        unsigned int pin_base, unsigned int npins)
>  {
> +       return 0;
>  }

Bah, I happened to put these prototypes just above the actual definition
of struct gpio_chip :-P

Fixing up and respinning the patch, I've added the compulsory return
value as well.

Yours,
Linus Walleij
