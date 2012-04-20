Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2DTGiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 02:38:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33941 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2DTGiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 02:38:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120419182917.2F64E3E0700@localhost>
References: <1334756420-12019-1-git-send-email-linus.walleij@stericsson.com>
	<1334787792.3143.19.camel@pasglop>
	<20120419182917.2F64E3E0700@localhost>
Date: Fri, 20 Apr 2012 08:38:05 +0200
Message-ID: <CACRpkdYpPLNnuivcN9CsG6ZHsZ7=AOkYv9OSGjfiLFi1ouh03g@mail.gmail.com>
Subject: Re: [PATCH] irqdomain: print a warning if domains contain IRQ 0
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 8:29 PM, Grant Likely <grant.likely@secretlab.ca> wrote:

> This is indeed specific to the legacy domain.  I think the patch is
> good and it will help weed out unintended irq0 users.  However, it
> requires the following additional fix I think.  It will need to be
> tested to make sure it doesn't break PowerPC ISA users.
>
> g.
>
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index d0995bd..31f1f88 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -138,7 +138,7 @@ static inline struct irq_domain *irq_domain_add_legacy_isa(
>                                const struct irq_domain_ops *ops,
>                                void *host_data)
>  {
> -       return irq_domain_add_legacy(of_node, NUM_ISA_INTERRUPTS, 0, 0, ops,
> +       return irq_domain_add_legacy(of_node, NUM_ISA_INTERRUPTS-1, 1, 1, ops,
>                                     host_data);

Hm, so what does this do? If I fold it into my patch I need some
kind of blurb...

I'm guessing it bumps the ISA IRQs with one to avoid using IRQ0 which
seems like a valid patch on its own, and that the old code was
used for actively ignoring IRQ 0 on ISA (not used or whatever)?

Yours,
Linus Walleij
