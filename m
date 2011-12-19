Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab1LSC3r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 21:29:47 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10005 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1LSC3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 21:29:45 -0500
X-AuditID: cbfee60f-b7bceae00000240c-ab-4eeea1973fe3
Date: Mon, 19 Dec 2011 02:29:43 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] misc: Fix irq leak in max8997_muic_probe error path
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: =?euc-kr?Q?=B1=E8=B5=BF=B1=D9?= <dg77.kim@samsung.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20111219021631990@myungjoo.ham
Msgkey: 20111219021631990@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20111219021631990@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <24320092.1406411324261782944.JavaMail.weblogic@epml05>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBJ2Ts8V027606

> Current code does not properly free allocated irqs if request_threaded_irq
> returns error, fix it.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thanks for pointing that out.

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
>  drivers/misc/max8997-muic.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/misc/max8997-muic.c b/drivers/misc/max8997-muic.c
> index 74a9448..409b7fc 100644
> --- a/drivers/misc/max8997-muic.c
> +++ b/drivers/misc/max8997-muic.c
> @@ -566,10 +566,6 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
>  				"failed: irq request (IRQ: %d,"
>  				" error :%d)\n",
>  				muic_irq->irq, ret);
> -
> -			for (i = i - 1; i >= 0; i--)
> -				free_irq(muic_irq->irq, info);
> -
>  			goto err_irq;
>  		}
>  	}
> @@ -583,6 +579,8 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
>  	return ret;
>  
>  err_irq:
> +	while (--i >= 0)
> +		free_irq(pdata->irq_base + muic_irqs[i].irq, info);
>  	sysfs_remove_group(&pdev->dev.kobj, &max8997_muic_group);
>  err_sysfs:
>  err_pdata:
> -- 
> 1.7.5.4
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
