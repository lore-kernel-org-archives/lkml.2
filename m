Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab0EGI73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:59:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:52091 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab0EGI72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:59:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P6qHQMpEum0DJE1a7fHrUNZGfTxknQfdJskc6eEL8LvdTSutG1Sk/Z+alNGhpG3OQc
         7roUxlaGZK2f39jYNUSYQ9JTAUIm4dY2RC3wcfyenuRRWE9E+QevM+g0CV9C+hiEYZiD
         aqVVy/VM8NPGSGhUd60LaQcmUQzt7+9uMUiB0=
MIME-Version: 1.0
In-Reply-To: <1273215671-3090-1-git-send-email-jassisinghbrar@gmail.com>
References: <1273215671-3090-1-git-send-email-jassisinghbrar@gmail.com>
Date: Fri, 7 May 2010 10:59:26 +0200
Message-ID: <i2r63386a3d1005070159tf0879839u24c1c1f11466970d@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMA: PL330: Add async dma api driver
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       dan.j.williams@intel.com, ben-linux@fluff.org, jy0922.shim@samsung.com,
       maciej.sosnowski@intel.com, Jassi Brar <jassi.brar@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/7 Jassi Brar <jassisinghbrar@gmail.com>:

> Add ASYNC DMA Engine API driver for the PL330 DMAC.
> This driver is supposed to be reusable by various
> platforms that have one or more PL330 DMACs.
> Atm, DMA_SLAVE and DMA_MEMCPY capabilities have been
> implemented.
>
> Signed-off-by: Jassi Brar <jassi.brar@samsung.com>

This needs some updating to apply and compile on Dan Williams tree,
please clone async_tx from git.kernel.org and generate the patch on that
tree instead. (It's my updates for generic channel status etc that
collide.)

You'll also find these changes in Rothwell's -next tree.

> (...)

> +static void pl330_terminate_all(struct dma_chan *chan)

This needs to be converted to the new prototype and will look
something like this:

static int
pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)

> +static enum dma_status
> +pl330_is_tx_complete(struct dma_chan *chan, dma_cookie_t cookie,
> +               dma_cookie_t *done, dma_cookie_t *used)

This needs to be converted to the new prototype and will look
something like this:

static enum dma_status
pl330_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
                 struct dma_tx_state *txstate)

See the other drivers for examples, e.g. coh901318.c
coh901318_control() and coh901318_tx_status()

(...)
> +       pd->device_is_tx_complete = pl330_is_tx_complete;
> +       pd->device_prep_slave_sg = pl330_prep_slave_sg;
> +       pd->device_terminate_all = pl330_terminate_all;
> +       pd->device_issue_pending = pl330_issue_pending;

Consequential updates here.

Sorry for the mess, moving target as usual...

If you fix this and test it on async_tx it's:
Reviewed-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
