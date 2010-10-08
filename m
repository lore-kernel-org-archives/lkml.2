Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab0JHAPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:15:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58084 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab0JHAPB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:15:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MmRrqgyxZnZd9A2Z3iOAKeV8G6KszfF+yVIfSV3ycUyfnPSnF2kE0uOvs5vAL6JGRN
         3gqn4yZaPLJe6jLXfX6BDFJMIr6P0Wkjri7LYGd7a6dVlJxW9Hw+qOFscsgUp8a++MWO
         DtawVwVRe4v5QcNxJM2pMWnyXSGta8C9GOlxE=
MIME-Version: 1.0
In-Reply-To: <1285854995-6569-4-git-send-email-s.hauer@pengutronix.de>
References: <1285854995-6569-1-git-send-email-s.hauer@pengutronix.de>
	<1285854995-6569-4-git-send-email-s.hauer@pengutronix.de>
Date: Thu, 7 Oct 2010 17:14:59 -0700
X-Google-Sender-Auth: xqkv-UqC39eG7D83_Wf2X8HjHU0
Message-ID: <AANLkTi=YY_bZ0mFy6dA18-mifM52H7wNJVHqgvfxR6zc@mail.gmail.com>
Subject: Re: [PATCH 3/4] dmaengine: Add Freescale i.MX SDMA support
From: Dan Williams <dan.j.williams@intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 6:56 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> This patch adds support for the Freescale i.MX SDMA engine.
>

Applied, this set, however...

> +static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
> +               struct dma_chan *chan, struct scatterlist *sgl,
> +               unsigned int sg_len, enum dma_data_direction direction,
> +               unsigned long flags)
> +{
> +       struct sdma_channel *sdmac = to_sdma_chan(chan);
> +       struct sdma_engine *sdma = sdmac->sdma;
> +       int ret, i, count;
> +       int channel = chan->chan_id;
> +       struct scatterlist *sg;
> +
> +       if (sdmac->status == DMA_IN_PROGRESS)
> +               return NULL;
> +       sdmac->status = DMA_IN_PROGRESS;

...shouldn't this be an atomic test and set operation to ensure a
single user at a time?

--
Dan
