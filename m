Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab2D0EjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 00:39:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40765 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2D0EjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 00:39:11 -0400
X-AuditID: cbfee60e-b7b3bae000007458-8c-4f9a22edbc9f
Date: Fri, 27 Apr 2012 04:39:09 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] PM: devfreq: init performance/powersave governor
To: Xiaoguang Chen <chenxg@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "khilman@ti.com" <khilman@ti.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "mturquette@ti.com" <mturquette@ti.com>, "rjw@sisk.pl" <rjw@sisk.pl>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120427043352411@myungjoo.ham
Msgkey: 20120427043352411@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120427043352411@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <15852322.15281335501548956.JavaMail.weblogic@epml25>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3R4dHfA019033

> Performance and powersave governor's get_target_freq
> is not called if driver chooses one of these two governors.
> Add init function in governor profile to call update_devfreq
> which will call get_target_freq subsequently.
> 
> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Hello Xiaoguang,


Yes, if we do not call any QoS, min/max, OPP interfaces or enable polling, we need to call this at init. In fact, this is a bugfix patch.

Thank you!

Cheers!
MyungJoo.



> ---
>  drivers/devfreq/governor_performance.c |    7 +++++++
>  drivers/devfreq/governor_powersave.c   |    7 +++++++
>  2 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/devfreq/governor_performance.c b/drivers/devfreq/governor_performance.c
> index 574a06b..af75ddd 100644
> --- a/drivers/devfreq/governor_performance.c
> +++ b/drivers/devfreq/governor_performance.c
> @@ -10,6 +10,7 @@
>   */
>  
>  #include <linux/devfreq.h>
> +#include "governor.h"
>  
>  static int devfreq_performance_func(struct devfreq *df,
>  				    unsigned long *freq)
> @@ -25,8 +26,14 @@ static int devfreq_performance_func(struct devfreq *df,
>  	return 0;
>  }
>  
> +static int performance_init(struct devfreq *devfreq)
> +{
> +	return update_devfreq(devfreq);
> +}
> +
>  const struct devfreq_governor devfreq_performance = {
>  	.name = "performance",
> +	.init = performance_init,
>  	.get_target_freq = devfreq_performance_func,
>  	.no_central_polling = true,
>  };
> diff --git a/drivers/devfreq/governor_powersave.c b/drivers/devfreq/governor_powersave.c
> index d742d4a..fec0cdb 100644
> --- a/drivers/devfreq/governor_powersave.c
> +++ b/drivers/devfreq/governor_powersave.c
> @@ -10,6 +10,7 @@
>   */
>  
>  #include <linux/devfreq.h>
> +#include "governor.h"
>  
>  static int devfreq_powersave_func(struct devfreq *df,
>  				  unsigned long *freq)
> @@ -22,8 +23,14 @@ static int devfreq_powersave_func(struct devfreq *df,
>  	return 0;
>  }
>  
> +static int powersave_init(struct devfreq *devfreq)
> +{
> +	return update_devfreq(devfreq);
> +}
> +
>  const struct devfreq_governor devfreq_powersave = {
>  	.name = "powersave",
> +	.init = powersave_init,
>  	.get_target_freq = devfreq_powersave_func,
>  	.no_central_polling = true,
>  };
> -- 
> 1.7.0.4
> 
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
