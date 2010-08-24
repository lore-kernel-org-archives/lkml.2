Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab0HXFsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 01:48:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43432 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab0HXFsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 01:48:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=WsCPdZqiLD+pSxAl0pmtQOg+wtIWhXgJ1+Zd8tWuTWTevoAc/kSc7yCIskUUclg8A8
         Eo83UMk3T/604Wu63ySjxAhpTWMwx3KuHsRgjJC4I7X3quoJ4SU6WDzY8LcajLuDSMo2
         /jxqmdcAWLhJK5PUN5wXWX9AFM+kUaJFpNtaU=
MIME-Version: 1.0
In-Reply-To: <1282628645.6074.1.camel@mola>
References: <1282628645.6074.1.camel@mola>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 24 Aug 2010 13:47:45 +0800
Message-ID: <AANLkTim7c6_rvOw6-TXB2=P6iWY3Rq76WUiqBxf0jaA2@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: da903x - fix da903x_add_subdevs error path
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mike Rapoport <mike@compulab.co.il>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7O5mDUH018774

On Tue, Aug 24, 2010 at 1:44 PM, Axel Lin <axel.lin@gmail.com> wrote:
> This patch fixes da903x_add_subdevs error path:
> 1. return -ENOMEM if platform_device_alloc() fail.
> 2. call platform_device_put() if platform_device_add() fail.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
> Â drivers/mfd/da903x.c | Â  Â 8 +++++++-
> Â 1 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
> index c07aece..2fadbae 100644
> --- a/drivers/mfd/da903x.c
> +++ b/drivers/mfd/da903x.c
> @@ -470,13 +470,19 @@ static int __devinit da903x_add_subdevs(struct da903x_chip *chip,
> Â  Â  Â  Â  Â  Â  Â  Â subdev = &pdata->subdevs[i];
>
> Â  Â  Â  Â  Â  Â  Â  Â pdev = platform_device_alloc(subdev->name, subdev->id);
> + Â  Â  Â  Â  Â  Â  Â  if (!pdev) {
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  ret = -ENOMEM;
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  goto failed;
> + Â  Â  Â  Â  Â  Â  Â  }
>
> Â  Â  Â  Â  Â  Â  Â  Â pdev->dev.parent = chip->dev;
> Â  Â  Â  Â  Â  Â  Â  Â pdev->dev.platform_data = subdev->platform_data;
>
> Â  Â  Â  Â  Â  Â  Â  Â ret = platform_device_add(pdev);
> - Â  Â  Â  Â  Â  Â  Â  if (ret)
> + Â  Â  Â  Â  Â  Â  Â  if (ret) {
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  platform_device_put(pdev);
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â goto failed;
> + Â  Â  Â  Â  Â  Â  Â  }
> Â  Â  Â  Â }
> Â  Â  Â  Â return 0;
>
> --
> 1.7.2
>
>
>
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
