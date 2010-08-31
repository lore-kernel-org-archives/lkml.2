Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab0HaFvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 01:51:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50241 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab0HaFvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 01:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X7R5QNbJ9Lc+icAhHj4LkS7SUUDf0fCH/AutWkGy02kUFOZ0T0qdKeUPtULtJ6J6/f
         X0/M7bXglI3EvLW2jsriLcDtW76onv9+FoDGSlX+VcTxJ60kgC2WbEE7+Rz1kWdeiA+d
         kOK8Q6qOHHtkmsq3YIZiTiJL3j6cTQL6gYpkM=
MIME-Version: 1.0
In-Reply-To: <1282813011-6187-2-git-send-email-mark.brown314@gmail.com>
References: <1282813011-6187-1-git-send-email-mark.brown314@gmail.com>
	<1282813011-6187-2-git-send-email-mark.brown314@gmail.com>
Date: Tue, 31 Aug 2010 13:51:06 +0800
Message-ID: <AANLkTinn_Yb+jGOcpc139X2cW0ax5Ev23ovjpp9NrPJC@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa3xx: fix build error when CONFIG_MTD_PARTITIONS
 is not defined
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: "Mark F. Brown" <mark.brown314@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, dedekind1 <dedekind1@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 4:56 PM, Mark F. Brown <mark.brown314@gmail.com> wrote:
> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
> ---
>  drivers/mtd/nand/pxa3xx_nand.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
> index 4d89f37..4d01cda 100644
> --- a/drivers/mtd/nand/pxa3xx_nand.c
> +++ b/drivers/mtd/nand/pxa3xx_nand.c
> @@ -1320,6 +1320,7 @@ static int pxa3xx_nand_probe(struct platform_device *pdev)
>                goto fail_free_irq;
>        }
>
> +#ifdef CONFIG_MTD_PARTITIONS
>        if (mtd_has_cmdlinepart()) {
>                static const char *probes[] = { "cmdlinepart", NULL };
>                struct mtd_partition *parts;
> @@ -1332,6 +1333,9 @@ static int pxa3xx_nand_probe(struct platform_device *pdev)
>        }
>
>        return add_mtd_partitions(mtd, pdata->parts, pdata->nr_parts);
> +#else
> +       return 0;
> +#endif
>
>  fail_free_irq:
>        free_irq(irq, info);
> @@ -1364,7 +1368,9 @@ static int pxa3xx_nand_remove(struct platform_device *pdev)
>        platform_set_drvdata(pdev, NULL);
>
>        del_mtd_device(mtd);
> +#ifdef CONFIG_MTD_PARTITIONS
>        del_mtd_partitions(mtd);
> +#endif
>        irq = platform_get_irq(pdev, 0);
>        if (irq >= 0)
>                free_irq(irq, info);
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Hi Mark,

Don't forget to cc maintainer of mtd tree. I loop them now.

Thanks
Haojian
