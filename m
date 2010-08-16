Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab0HPMW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:22:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55411 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab0HPMW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=UAxseu1iQmMCfQfJFrl5M8V33mYRGmB8oosMSKzKSMSB4Xt8cIRiffodYoaJhBsTai
         ii5bji70ozSXtHLUSSE4gmNkjxs4Uudd/3cx0Pzb09kb1bNEDcj1azH+3hh+I9Be9eBl
         Gihoo3vv/DXV5HGMmSUF6PmwGmWCe7MP1GT2I=
MIME-Version: 1.0
In-Reply-To: <1281948641.29696.1.camel@mola>
References: <1281948641.29696.1.camel@mola>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 16 Aug 2010 20:22:05 +0800
Message-ID: <AANLkTi=YSS0-Nf4MWOw30YDrCdrkmtzLhv7DXfsoJTjX@mail.gmail.com>
Subject: Re: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for samsung2GbX8
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Lei Wen <leiwen@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ed Lei and Haojian.

On Mon, Aug 16, 2010 at 4:50 PM, Axel Lin <axel.lin@gmail.com> wrote:
> This patch adds timing settings for samsung2GbX8 and
> fixes the cmdset settings. samsung2GbX8 is large page.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mtd/nand/pxa3xx_nand.c |   16 ++++++++++++++--
>  1 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
> index 4d89f37..47c0442 100644
> --- a/drivers/mtd/nand/pxa3xx_nand.c
> +++ b/drivers/mtd/nand/pxa3xx_nand.c
> @@ -227,9 +227,21 @@ static struct pxa3xx_nand_flash samsung512MbX16 = {
>        .chip_id        = 0x46ec,
>  };
>
> +static struct pxa3xx_nand_timing samsung2GbX8_timing = {
> +       .tCH    = 5,
> +       .tCS    = 20,
> +       .tWH    = 10,
> +       .tWP    = 12,
> +       .tRH    = 10,
> +       .tRP    = 12,
> +       .tR     = 25000,
> +       .tWHR   = 60,
> +       .tAR    = 10,
> +};
> +
>  static struct pxa3xx_nand_flash samsung2GbX8 = {
> -       .timing         = &samsung512MbX16_timing,
> -       .cmdset         = &smallpage_cmdset,
> +       .timing         = &samsung2GbX8_timing,
> +       .cmdset         = &largepage_cmdset,
>        .page_per_block = 64,
>        .page_size      = 2048,
>        .flash_width    = 8,
> --
> 1.7.2
>
>
>
>
