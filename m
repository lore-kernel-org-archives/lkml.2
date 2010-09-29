Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab0I2VU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 17:20:58 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:44176 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab0I2VU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 17:20:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VHyuTOG+C2v6/aSClfoPqMvbWybETOozYr1Yh73S5+d046LI2SqX4dMj1U3di5YiWl
         R8lkKBloALYQGyuMWESIvQUOu43wey7zfQKJyzjq8Ojbq4C1mmLng3ta90jFVMn4+UaG
         m+QyASMWRKSTH5pEuWiDVGbA5+FopjTU7gEJg=
MIME-Version: 1.0
In-Reply-To: <1285628277-26894-5-git-send-email-iws@ovro.caltech.edu>
References: <1285628277-26894-1-git-send-email-iws@ovro.caltech.edu>
	<1285628277-26894-5-git-send-email-iws@ovro.caltech.edu>
Date: Wed, 29 Sep 2010 14:19:32 -0700
X-Google-Sender-Auth: VYH8ECZ_s2IXMqfDMbTBBGWuVdw
Message-ID: <AANLkTinYG4LqtEXxM5pdA0vavahtqbt6=yV341pnFmZw@mail.gmail.com>
Subject: Re: [PATCH 4/4] ste_dma40: implement support for scatterlist to
 scatterlist copy
From: Dan Williams <dan.j.williams@intel.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        =?ISO-8859-1?Q?Per_Frid=E9n?= <per.friden@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 3:57 PM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:
> Now that the DMAEngine API has support for scatterlist to scatterlist
> copy, implement support for the STE DMA40 DMA controller.
>
> Cc: Linus Walleij <linus.ml.walleij@gmail.com>
> Cc: Per Fridén <per.friden@stericsson.com>
> Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
> ---
>  drivers/dma/ste_dma40.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 17e2600..cd48859 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -1857,6 +1857,18 @@ err:
>        return NULL;
>  }
>
> +static struct dma_async_tx_descriptor *
> +d40_prep_sg(struct dma_chan *chan,
> +           struct scatterlist *dst_sg, unsigned int dst_nents,
> +           struct scatterlist *src_sg, unsigned int src_nents,
> +           unsigned long dma_flags)
> +{
> +       if (dst_nents != src_nents)
> +               return -EINVAL;

I suspect you wanted "return NULL;" here.  I can fix that up.

Linus, Per ack?

--
Dan
