Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1FCNAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:00:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38282 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab1FCNAS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:00:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xcM/uDFXUwzqqLUAEEllned/Fd3oezUPBgm9jUZolny5mr2FV1j91x7jMYoaJ802E1
         2Wj6w+SarfuzIzgCdW+kqvu82pjWZizR6yNqOz2xsOSXcrSxh+B+Wwl0RfoIzcFZYkFa
         EpSe77+ygcOISIJmM7tVRyHdO2x5CQs6hdl+s=
MIME-Version: 1.0
In-Reply-To: <1307086473.7474.1.camel@phoenix>
References: <1307086473.7474.1.camel@phoenix>
Date: Fri, 3 Jun 2011 15:00:18 +0200
Message-ID: <BANLkTinfOmA1cW6Ktuka1NS+7D0RhFqMvw@mail.gmail.com>
Subject: Re: [PATCH] mtd: pxa3xx_nand: remove unused variable 'mtd'
From: Daniel Mack <zonque@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Eric Miao <eric.y.miao@gmail.com>, linux-mtd@lists.infradead.org,
        Lei Wen <adrian.wenl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc Lei Wen)

On Fri, Jun 3, 2011 at 9:34 AM, Axel Lin <axel.lin@gmail.com> wrote:
> Remove unused variable 'mtd' to eliminate below warning.
>
>  CC      drivers/mtd/nand/pxa3xx_nand.o
> drivers/mtd/nand/pxa3xx_nand.c: In function 'pxa3xx_nand_suspend':
> drivers/mtd/nand/pxa3xx_nand.c:1167: warning: unused variable 'mtd'
> drivers/mtd/nand/pxa3xx_nand.c: In function 'pxa3xx_nand_resume':
> drivers/mtd/nand/pxa3xx_nand.c:1180: warning: unused variable 'mtd'
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Lei, I had the same patch queued up on my side and dropped it now. Can
you apply this one?

Thanks,
Daniel



> ---
>  drivers/mtd/nand/pxa3xx_nand.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
> index 1fb3b3a..5cae8ae 100644
> --- a/drivers/mtd/nand/pxa3xx_nand.c
> +++ b/drivers/mtd/nand/pxa3xx_nand.c
> @@ -1164,7 +1164,6 @@ static int pxa3xx_nand_probe(struct platform_device *pdev)
>  static int pxa3xx_nand_suspend(struct platform_device *pdev, pm_message_t state)
>  {
>        struct pxa3xx_nand_info *info = platform_get_drvdata(pdev);
> -       struct mtd_info *mtd = info->mtd;
>
>        if (info->state) {
>                dev_err(&pdev->dev, "driver busy, state = %d\n", info->state);
> @@ -1177,7 +1176,6 @@ static int pxa3xx_nand_suspend(struct platform_device *pdev, pm_message_t state)
>  static int pxa3xx_nand_resume(struct platform_device *pdev)
>  {
>        struct pxa3xx_nand_info *info = platform_get_drvdata(pdev);
> -       struct mtd_info *mtd = info->mtd;
>
>        nand_writel(info, NDTR0CS0, info->ndtr0cs0);
>        nand_writel(info, NDTR1CS0, info->ndtr1cs0);
> --
> 1.7.4.1
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
