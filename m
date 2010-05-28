Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0E1T0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 15:26:06 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:48112 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070Ab0E1TZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 15:25:59 -0400
MIME-Version: 1.0
In-Reply-To: <1275069378-21548-1-git-send-email-alexandre.bounine@idt.com>
References: <1275069378-21548-1-git-send-email-alexandre.bounine@idt.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 28 May 2010 13:25:35 -0600
X-Google-Sender-Auth: 8FW3FFy5yRu_-lnXy3Q5JGz96NQ
Message-ID: <AANLkTim2ScQBZ0nqazd1hIxL2lQqxZO_rT0aMmts2Sk4@mail.gmail.com>
Subject: Re: [PATCH -next] RapidIO,powerpc/85xx: fix device node pointer
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Matt Porter <mporter@kernel.crashing.org>,
       Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
       Thomas Moll <thomas.moll@sysgo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 11:56 AM, Alexandre Bounine
<alexandre.bounine@idt.com> wrote:
> Fixes compile problem caused by overlapped patches.
>
> Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
> Cc: Matt Porter <mporter@kernel.crashing.org>
> Cc: Li Yang <leoli@freescale.com>
> Cc: Kumar Gala <galak@kernel.crashing.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Thomas Moll <thomas.moll@sysgo.com>

Looks correct.  I've got a few other related patches, I'll pick this
up and send it to Linus through my tree.

g.

> ---
>  arch/powerpc/sysdev/fsl_rio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
> index cd37e49..30e1626 100644
> --- a/arch/powerpc/sysdev/fsl_rio.c
> +++ b/arch/powerpc/sysdev/fsl_rio.c
> @@ -1426,7 +1426,7 @@ int fsl_rio_setup(struct of_device *dev)
>        port->iores.flags = IORESOURCE_MEM;
>        port->iores.name = "rio_io_win";
>
> -       priv->pwirq   = irq_of_parse_and_map(dev->node, 0);
> +       priv->pwirq   = irq_of_parse_and_map(dev->dev.of_node, 0);
>        priv->bellirq = irq_of_parse_and_map(dev->dev.of_node, 2);
>        priv->txirq = irq_of_parse_and_map(dev->dev.of_node, 3);
>        priv->rxirq = irq_of_parse_and_map(dev->dev.of_node, 4);
> --
> 1.7.0.5
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
