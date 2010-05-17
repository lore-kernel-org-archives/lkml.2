Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab0EQJza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:55:30 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:63698 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab0EQJz3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:55:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=F7c43AqG0Oy5dQFspymN55VsdiR3uP9zHFZy1G8MS6R3xnFxKNv7b2sdwP0Y4jJChH
         JWf0epetbppNXqF99IhlLOxQVtZ/8cbKPsEaEvVLzYTbDyg44FOFlM8/XJwCL6LWQGZr
         uoykt7VUZkAYCoFGT/XFbrPgDx2LwiFyX9oaM=
MIME-Version: 1.0
In-Reply-To: <1273641798-26579-1-git-send-email-jassi.brar@samsung.com>
References: <1273641798-26579-1-git-send-email-jassi.brar@samsung.com>
Date: Mon, 17 May 2010 02:55:28 -0700
X-Google-Sender-Auth: sJ53lrJgZju79hmmu3CZ360WCls
Message-ID: <AANLkTinAmHkVBii9nTZ5tNYU21whHy8awP55nGEc-8Tp@mail.gmail.com>
Subject: Re: [PATCH] DMA: PL330: Add dma api driver
From: Dan Williams <dan.j.williams@intel.com>
To: Jassi Brar <jassi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       jy0922.shim@samsung.com, linus.ml.walleij@gmail.com,
       maciej.sosnowski@intel.com, ben-linux@fluff.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jassi,

Looks good, one comment:

On Tue, May 11, 2010 at 10:23 PM, Jassi Brar <jassi.brar@samsung.com> wrote:
> Add DMA Engine API driver for the PL330 DMAC.
> This driver is supposed to be reusable by various
> platforms that have one or more PL330 DMACs.
> Atm, DMA_SLAVE and DMA_MEMCPY capabilities have been
> implemented.
>
> Signed-off-by: Jassi Brar <jassi.brar@samsung.com>
[..]
> +static void dma_pl330_rqcb(void *token, enum pl330_op_err err)
> +{
> +       struct dma_pl330_desc *desc = token;
> +       struct dma_pl330_chan *pch = desc->pchan;
> +       unsigned long flags;
> +
> +       /* If desc aborted */
> +       if (!pch)
> +               return;
> +
> +       spin_lock_irqsave(&pch->lock, flags);
> +
> +       desc->status = DONE;
> +
> +       spin_unlock_irqrestore(&pch->lock, flags);

I don't think you need the lock here.  Assigning an integer is atomic,
and you reschedule the tasklet.

Since this patch depends on the generic bits in Russell's tree I need
to wait until after the ARM tree is pulled to take it through the dma
tree.  So, for now...

Acked-by: Dan Williams <dan.j.williams@intel.com>
