Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab1LNVOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:14:51 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49838 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1LNVOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:14:50 -0500
MIME-Version: 1.0
In-Reply-To: <1323876538-20406-4-git-send-email-robherring2@gmail.com>
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com> <1323876538-20406-4-git-send-email-robherring2@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 14 Dec 2011 14:14:28 -0700
X-Google-Sender-Auth: J42GwjFVcd1WdUjEfsR2JA8DRnE
Message-ID: <CACxGe6sqTx4h3vPgq+XrAoqLTiDMB-vcS5C9GgYssdsSYV_0qA@mail.gmail.com>
Subject: Re: [PATCH 3/9] irq: convert generic-chip to use irq_domain
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
> Add irq domain support to irq generic-chip. This enables users of
> generic-chip to support dynamic irq assignment needed for DT interrupt
> binding. Users must be converted to use irq_data.hwirq for determining
> local interrupt numbers rather than using the Linux irq number.
>
> irq_base is kept for now as there are a few users of it. Once they
> are converted to use the irq domain, it can be removed.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/irq.h       |    2 +-
>  kernel/irq/Kconfig        |    1 +
>  kernel/irq/generic-chip.c |   57 ++++++++++++++++++++++++++++----------------
>  3 files changed, 38 insertions(+), 22 deletions(-)
>
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index bff29c5..9ba8a30 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -664,7 +664,7 @@ struct irq_chip_generic {
>        raw_spinlock_t          lock;
>        void __iomem            *reg_base;
>        unsigned int            irq_base;
> -       unsigned int            irq_cnt;
> +       struct irq_domain       *domain;

Instead of making domain a pointer, why not embed the structure inside
irq_chip_generic?  I don't see a reason for keeping it separate.

After changing that you can add my Acked-by for this patch.

g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
