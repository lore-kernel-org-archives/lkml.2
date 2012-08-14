Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab2HNI0C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:26:02 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34883 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab2HNIZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:25:59 -0400
MIME-Version: 1.0
In-Reply-To: <1344527635-6163-8-git-send-email-lee.jones@linaro.org>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
	<1344527635-6163-8-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 10:25:59 +0200
Message-ID: <CACRpkdbYP3FNNC1nR9c6aYRsqpeaBJjQO4GKeuk05NUBkNcRpg@mail.gmail.com>
Subject: Re: [PATCH 7/8] mfd: Use the AB8500's IRQ domain to convert hwirq to virq
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:53 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Before the AB8500 had its own IRQ domain, the IRQ handler would take
> the fired local IRQ (hwirq) and add it to the irq_base to convert it
> to an IRQ number which Linux would understand (virq). However, the
> IRQ base is not always used anymore since we can make use of Linear
> domains. It's better to use the AB8500 hwirq -> virq mapping helper
> function to convert them instead. That's what we do here.
>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This looks better that what was in there before so
Acked-by: Linus Walleij <linus.walleij@linaro.org>

However:

> @@ -501,8 +501,9 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
>                 do {
>                         int bit = __ffs(value);
>                         int line = i * 8 + bit;
> +                       int virq = ab8500_irq_get_virq(ab8500, line);
>
> -                       handle_nested_irq(ab8500->irq_base + line);
> +                       handle_nested_irq(virq);
>                         value &= ~(1 << bit);

Still this ab8500_irq_get_virq() business. But is this a static local function
in the ab8500-core.c now? Then it's fine, it's the kernel-wide interface
that is the problem.

Yours,
Linus Walleij
