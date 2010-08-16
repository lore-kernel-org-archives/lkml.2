Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab0HPF2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 01:28:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38541 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab0HPF2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 01:28:44 -0400
From: Kukjin Kim <kgene.kim@samsung.com>
To: "=?utf-8?Q?'Uwe_Kleine-K=C3=B6nig'?=" 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org
Cc: "'Maxim Levitsky'" <maximlevitsky@gmail.com>,
        "'David Brownell'" <david-b@pacbell.net>,
        "'Alan Stern'" <stern@rowland.harvard.edu>, linux-mmc@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>
References: <1276809814-28683-1-git-send-email-maximlevitsky@gmail.com>
 <1281691473-15481-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-reply-to: <1281691473-15481-1-git-send-email-u.kleine-koenig@pengutronix.de>
Subject: RE: [PATCH] mmc: build fix: mmc_pm_notify is only available with
 CONFIG_PM=y
Date: Mon, 16 Aug 2010 14:28:33 +0900
Message-id: <003901cb3d03$ec038140$c40a83c0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acs6yWqDpJkkbk6iQ/2IwdLzSypqtwCOhAxw
Content-language: ko
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-Konig wrote:
> 
> This fixes a build breakage introduced by
> 
> 	4c2ef25 (mmc: fix all hangs related to mmc/sd card insert/removal during
> suspend/resume)
> 
> Cc: Maxim Levitsky <maximlevitsky@gmail.com>
> Cc: David Brownell <david-b@pacbell.net>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: linux-mmc@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

> ---
>  drivers/mmc/core/host.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> index 0efe631..d80cfdc 100644
> --- a/drivers/mmc/core/host.c
> +++ b/drivers/mmc/core/host.c
> @@ -86,7 +86,9 @@ struct mmc_host *mmc_alloc_host(int extra, struct device
> *dev)
>  	init_waitqueue_head(&host->wq);
>  	INIT_DELAYED_WORK(&host->detect, mmc_rescan);
>  	INIT_DELAYED_WORK_DEFERRABLE(&host->disable,
> mmc_host_deeper_disable);
> +#ifdef CONFIG_PM
>  	host->pm_notify.notifier_call = mmc_pm_notify;
> +#endif
> 
>  	/*
>  	 * By default, hosts do not support SGIO or large requests.
> --
> 1.7.1
> 

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

