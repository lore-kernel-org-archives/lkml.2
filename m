Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab1KKIgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 03:36:40 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38451 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab1KKIgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 03:36:38 -0500
MIME-Version: 1.0
In-Reply-To: <20111111120013.e425db4686acbd346e10a49b@canb.auug.org.au>
References: <20111111120013.e425db4686acbd346e10a49b@canb.auug.org.au>
Date: Fri, 11 Nov 2011 14:06:38 +0530
Message-ID: <CAJuYYwR6Vt4dbio3hATkLgYPbo2sVVpjH85DE+AUOAGS9-r0rA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the slave-dma tree with the s5p tree
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Boojin Kim <boojin.kim@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, joe@perches.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 11 November 2011 06:30, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Vinod,
>
> Today's linux-next merge of the slave-dma tree got a conflict in
> drivers/dma/pl330.c between commit c6e00b47067b ("DMA: PL330: Add device
> tree support") from the s5p tree and commit dab6538e29e6 ("DMA: PL330:
> Fix build warning") from the slave-dma tree.
>
> I fixed it up (see below) and can carry the fix as necessary.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc drivers/dma/pl330.c
> index a626e15,186b822..0000000
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@@ -870,8 -856,8 +870,8 @@@ pl330_probe(struct amba_device *adev, c
>        INIT_LIST_HEAD(&pd->channels);
>
>        /* Initialize channel parameters */
> -       num_chan = max(pdat ? pdat->nr_valid_peri : (u8)pi->pcfg.num_peri,
> -                       (u8)pi->pcfg.num_chan);
>  -      num_chan = max(pdat ? (int)pdat->nr_valid_peri : 0,
>  -                                      (int)pi->pcfg.num_chan);
> ++      num_chan = max(pdat ? (int)pdat->nr_valid_peri : (int)pi->pcfg.num_peri,
> ++                      (int)pi->pcfg.num_chan);
>        pdmac->peripherals = kzalloc(num_chan * sizeof(*pch), GFP_KERNEL);
>
>        for (i = 0; i < num_chan; i++) {
>

Thanks for the fix.
Also taking into account the suggestion from Joe Perches, this change could be

> -       num_chan = max(pdat ? pdat->nr_valid_peri : (u8)pi->pcfg.num_peri,
> -                       (u8)pi->pcfg.num_chan);
>  -      num_chan = max(pdat ? (int)pdat->nr_valid_peri : 0,
>  -                                      (int)pi->pcfg.num_chan);
> ++      num_chan = max_t(int, pdat ? pdat->nr_valid_peri : pi->pcfg.num_peri,
> ++                      pi->pcfg.num_chan);
>        pdmac->peripherals = kzalloc(num_chan * sizeof(*pch), GFP_KERNEL);
>

Regards,
Thomas.
