Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab1KKEJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 23:09:55 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11921 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1KKEJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 23:09:54 -0500
X-AuditID: cbfee60e-b7bc4ae000007958-40-4ebc9fff191e
Date: Fri, 11 Nov 2011 04:09:35 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 2/2] devfreq: separate error paths from successful path
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Kevin Hilman <khilman@ti.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Mike Turquette <mturquette@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20111111040646184@myungjoo.ham
Msgkey: 20111111040646184@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20111111040646184@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <1640445.17731320984574558.JavaMail.weblogic@epml10>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAB4ACs1006545

Sender : Axel Lin<axel.lin@gmail.com> Date : 2011-11-10 16:30 (GMT+09:00)
> I think this change improves readability.
> 
> Signed-off-by: Axel Lin 

I agree. It makes it easier to read.

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
> drivers/devfreq/devfreq.c |   15 +++++++--------
> 1 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 59d24e9..c189b82 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -347,7 +347,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
> if (!IS_ERR(devfreq)) {
> dev_err(dev, "%s: Unable to create devfreq for the device. It already has one. ", __func__);
> err = -EINVAL;
> - goto out;
> + goto err_out;
> }
> }
> 
> @@ -356,7 +356,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
> dev_err(dev, "%s: Unable to create devfreq for the device ",
> __func__);
> err = -ENOMEM;
> - goto out;
> + goto err_out;
> }
> 
> mutex_init(&devfreq->lock);
> @@ -399,17 +399,16 @@ struct devfreq *devfreq_add_device(struct device *dev,
>    devfreq->next_polling);
> }
> mutex_unlock(&devfreq_list_lock);
> - goto out;
> +out:
> + return devfreq;
> +
> err_init:
> device_unregister(&devfreq->dev);
> err_dev:
> mutex_unlock(&devfreq->lock);
> kfree(devfreq);
> -out:
> - if (err)
> - return ERR_PTR(err);
> - else
> - return devfreq;
> +err_out:
> + return ERR_PTR(err);
> }
> 
> /**
> -- 
> 1.7.5.4
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
