Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab0HIWpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 18:45:23 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55779 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab0HIWpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 18:45:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z6hmUH2WEU+GdOoQAA8aHE0K3HFRUfp6Ynq1ujxEk14csdQn01l+XMjGuZPTtRLyE6
         kNuDg0w3WUQ5P/1pSNuj9lBjTZRzxoQkNVxw6bJPZXaZ07gG5UDTgiWuDWVpDlmPoWb5
         92/deNOx7gRnhQGXBUz39vQZEwaRjXHwBiWvg=
MIME-Version: 1.0
In-Reply-To: <1281344743-2029-2-git-send-email-s.hauer@pengutronix.de>
References: <1281344743-2029-1-git-send-email-s.hauer@pengutronix.de>
	<1281344743-2029-2-git-send-email-s.hauer@pengutronix.de>
Date: Tue, 10 Aug 2010 00:45:17 +0200
Message-ID: <AANLkTimtQrmrW-pNWX=0J9GMsGrS-5-LZKkxdHDSuSxW@mail.gmail.com>
Subject: Re: [PATCH 1/8] ARM i.MX dma: implement wrapper for dma functions
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
        linux kernel <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/9 Sascha Hauer <s.hauer@pengutronix.de>:

> Currently there is only one i.MX DMA implementation in the tree,
> the one for i.MX1/21/27. The SDMA support for i.MX25/31/35/51 can
> be implemented similarly. This wrapper for the DMA is implemented
> so that drivers do not have to care about the implementation
> present and don't have to #ifdef DMA support
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> (...)
> +struct imx_dma_operations {
> +       int (*config_channel)(int channel, struct imx_dma_config *cfg);
> +       int (*setup_single)(int channel, dma_addr_t mem, int dma_length,
> +               unsigned int dmamode);
> +       int (*setup_sg)(int channel, struct scatterlist *sg,
> +                       unsigned int sgcount, unsigned int dma_length,
> +                       unsigned int dmamode);
> +       void (*enable)(int channel);
> +       void (*disable)(int channel);
> +       int (*request)(enum imx_dma_prio);
> +       void (*free)(int channel);
> +       int num_channels;
> +};

This is just getting *so* close to the drivers/dma dmaengine API.

We decided to use the damengine for all our DMA drivers and we
haven't regretted one bit.

There has been some noise about too many drivers stacking up
below arch/arm instead of going to the apropriate subsystem, can't
you atleast contemplate using the dmaengine and help us improve
that subsystem?

I sent some patches to Dan which essentially is a single-buffer
(non-sglist) API, which is all I see missing to fit this need.

Yours,
Linus Walleij
