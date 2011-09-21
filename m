Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140Ab1IUETS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 00:19:18 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58447 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab1IUETR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 00:19:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110921133456.3072657340220296eec6d7b6@canb.auug.org.au>
References: <20110921133456.3072657340220296eec6d7b6@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 20 Sep 2011 22:18:56 -0600
X-Google-Sender-Auth: CcKD5LFLkQWVuKCbcYDxG01zoRQ
Message-ID: <CACxGe6vHDGQnr=h-oC1sfqqO2yKiYBj_opmVtugjqojy_zHZFQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the spi tree with the arm tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Stephen.  I'll drop the offending hunk from my tree.

g.

On Tue, Sep 20, 2011 at 9:34 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> Today's linux-next merge of the spi tree got a conflict in
> drivers/spi/spi-pl022.c between commit 67fc8b9fe70c ("PM: add runtime PM
> support to core Primecell driver") from the arm tree and commit
> 4eb389a89154 ("spi/spi-pl022: Resolve formatting issues") from the spi
> tree.
>
> The former removes the lines modified by the latter, so I just removed
> the lines (see below).
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc drivers/spi/spi-pl022.c
> index 3520cf9,02b2eda..0000000
> --- a/drivers/spi/spi-pl022.c
> +++ b/drivers/spi/spi-pl022.c
> @@@ -2235,8 -2237,11 +2225,10 @@@ pl022_probe(struct amba_device *adev, c
>   err_start_queue:
>   err_init_queue:
>        destroy_queue(pl022);
> -       pl022_dma_remove(pl022);
> +       if (platform_info->enable_dma)
> +               pl022_dma_remove(pl022);
> +
>        free_irq(adev->irq[0], pl022);
>  -      pm_runtime_disable(&adev->dev);
>   err_no_irq:
>        clk_put(pl022->clk);
>   err_no_clk:
> @@@ -2429,9 -2404,10 +2422,8 @@@ static struct amba_driver pl022_driver
>        .id_table       = pl022_ids,
>        .probe          = pl022_probe,
>        .remove         = __devexit_p(pl022_remove),
>  -      .suspend        = pl022_suspend,
>  -      .resume         = pl022_resume,
>  };
>
> -
>  static int __init pl022_init(void)
>  {
>        return amba_driver_register(&pl022_driver);
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
