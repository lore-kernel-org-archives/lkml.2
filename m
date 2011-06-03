Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab1FCNCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:02:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50452 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab1FCNCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:02:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JJ+Cq/40lET6fBxFCkm2r3iIGVW1egRe+1QEUEotpywiVp6ri2N+bLEf0WeJsO+RZ/
         sJ5CTMJiEyrfCwShBWlbebFojYrhEhr8EWDhaknzyXgn3QxByq/j1Y/kEEgl2F3/hVMW
         VppCf24dL95bJuAXgl6asrrsgnpiEwH8VpWYo=
MIME-Version: 1.0
In-Reply-To: <1307078050.4167.1.camel@phoenix>
References: <1307078050.4167.1.camel@phoenix>
Date: Fri, 3 Jun 2011 15:02:07 +0200
Message-ID: <BANLkTikNC8F2TPY2TFHuHtU=-xhwef2ikw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mtd: pxa3xx_nand: fix a memory leak
From: Daniel Mack <zonque@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Lei Wen <adrian.wenl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc Lei Wen)

On Fri, Jun 3, 2011 at 7:14 AM, Axel Lin <axel.lin@gmail.com> wrote:
> In pxa3xx_nand_remove, we should call nand_release instead of
> mtd_device_unregister to properly free bad block table memory
> and bad block descriptor memory.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mtd/nand/pxa3xx_nand.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
> index 1fb3b3a..f7040ea 100644
> --- a/drivers/mtd/nand/pxa3xx_nand.c
> +++ b/drivers/mtd/nand/pxa3xx_nand.c
> @@ -1119,7 +1119,7 @@ static int pxa3xx_nand_remove(struct platform_device *pdev)
>        clk_put(info->clk);
>
>        if (mtd) {
> -               mtd_device_unregister(mtd);
> +               nand_release(mtd);
>                kfree(mtd);
>        }
>        return 0;
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
