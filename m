Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab2IJNFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:05:19 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56634 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760Ab2IJNFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:05:15 -0400
MIME-Version: 1.0
In-Reply-To: <1347016499-29354-17-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-17-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Sep 2012 06:05:13 -0700
Message-ID: <CACRpkdaAwaUwr9njGCRDssyNVFv8TgeZeKVeFj=MUA_fA_jesw@mail.gmail.com>
Subject: Re: [PATCH 16/19] mfd: Provide the tc3589x with its own IRQ domain
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> In preparation for Device Tree enablement all IRQ controllers
> should control their own IRQ domain. This patch provides just
> that.
>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

It's always nice to have irqdomains added, excellent patch!

> +       if (base) {
> +               tc3589x->domain = irq_domain_add_legacy(
> +                       NULL, TC3589x_NR_INTERNAL_IRQS, base,
> +                       0, &tc3589x_irq_ops, tc3589x);
>         }
> +       else {
> +               tc3589x->domain = irq_domain_add_linear(
> +                       NULL, TC3589x_NR_INTERNAL_IRQS,
> +                       &tc3589x_irq_ops, tc3589x);
> +       }

This is especially elegant, well done.
Not my subsystem, but FWIW:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
