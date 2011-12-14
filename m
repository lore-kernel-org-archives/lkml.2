Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab1LNQIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:08:43 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59954 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1LNQIm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:08:42 -0500
MIME-Version: 1.0
In-Reply-To: <1323876538-20406-3-git-send-email-robherring2@gmail.com>
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com> <1323876538-20406-3-git-send-email-robherring2@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 14 Dec 2011 09:08:20 -0700
X-Google-Sender-Auth: z9ZBIwNHroczYb9awaMeIeok3ME
Message-ID: <CACxGe6t6mtPt9LsQ77N06n5gWAAUcswhGNut9O==Drq5CJDMpQ@mail.gmail.com>
Subject: Re: [PATCH 2/9] irq: check domain hwirq range for DT translate
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, shawn.guo@freescale.com,
        Kukjin Kim <kgene.kim@samsung.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 8:28 AM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> A DT node may have more than 1 domain associated with it, so make sure
> the hwirq number is within range when doing DT translation.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  kernel/irq/irqdomain.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 200ce83..ae6441e 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -135,6 +135,9 @@ int irq_domain_simple_dt_translate(struct irq_domain *d,
>                return -EINVAL;
>        if (intsize < 1)
>                return -EINVAL;
> +       if ((intspec[0] < d->hwirq_base) ||
> +           (intspec[0] >= d->hwirq_base + d->nr_irq))
> +               return -EINVAL;
>
>        *out_hwirq = intspec[0];
>        *out_type = IRQ_TYPE_NONE;
> --
> 1.7.5.4
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
