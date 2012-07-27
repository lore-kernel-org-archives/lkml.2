Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab2G0XX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 19:23:28 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54890 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2G0XX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 19:23:27 -0400
MIME-Version: 1.0
In-Reply-To: <1343112660-12245-1-git-send-email-blogic@openwrt.org>
References: <1343112660-12245-1-git-send-email-blogic@openwrt.org>
Date: Sat, 28 Jul 2012 01:23:26 +0200
Message-ID: <CACRpkdZi+-V+-LGKiws-c=t0ZjvjV=CFxpuZCBwf9i_q5P+6UQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] OF: pinctrl: MIPS: lantiq: implement lantiq/xway
 pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 8:50 AM, John Crispin <blogic@openwrt.org> wrote:

> Implement support for pinctrl on lantiq/xway socs. The IO core found on these
> socs has the registers for pinctrl, pinconf and gpio mixed up in the same
> register range. As the gpio_chip handling is only a few lines, the driver also
> implements the gpio functionality. This obseletes the old gpio driver that was
> located in the arch/ folder.
>
> Signed-off-by: John Crispin <blogic@openwrt.org>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

I still ACK it, just a comment:

> +/* these are the offsets to our registers */
> +#define GPIO_BASE(p)           (REG_OFF * PORT(p))
> +#define GPIO_OUT(p)            GPIO_BASE(p)
> +#define GPIO_IN(p)             (GPIO_BASE(p) + 0x04)
> +#define GPIO_DIR(p)            (GPIO_BASE(p) + 0x08)
> +#define GPIO_ALT0(p)           (GPIO_BASE(p) + 0x0C)
> +#define GPIO_ALT1(p)           (GPIO_BASE(p) + 0x10)
> +#define GPIO_OD(p)             (GPIO_BASE(p) + 0x14)
> +#define GPIO_PUDSEL(p)         (GPIO_BASE(p) + 0x1c)
> +#define GPIO_PUDEN(p)          (GPIO_BASE(p) + 0x20)
> +
> +/* the 1/2 port needs special offsets for some registers */
> +#define GPIO3_OD               (GPIO_BASE(0) + 0x24)
> +#define GPIO3_PUDSEL           (GPIO_BASE(0) + 0x28)
> +#define GPIO3_PUDEN            (GPIO_BASE(0) + 0x2C)
> +#define GPIO3_ALT1             (GPIO_BASE(PINS) + 0x24)
> +
> +/* macros to help us access the registers */
> +#define gpio_getbit(m, r, p)   (!!(ltq_r32(m + r) & BIT(p)))
> +#define gpio_setbit(m, r, p)   ltq_w32_mask(0, BIT(p), m + r)
> +#define gpio_clearbit(m, r, p) ltq_w32_mask(BIT(p), 0, m + r)

These are a bit confusing since much of this stuff is not dealing with
GPIO at all (but some pulling, open draining etc).

Consider renaming some of these some day.

Yours,
Linus Walleij
