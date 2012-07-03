Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab2GCJxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:53:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42460 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2GCJx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:53:29 -0400
X-AuditID: cbfee612-b7fbe6d000007898-d6-4ff2c117e639
Date: Tue, 03 Jul 2012 09:53:27 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] PM: Devfreq: fix userspace governor frequency bug
To: Xiaoguang Chen <chenxg@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "mturquette@ti.com" <mturquette@ti.com>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120703094839361@myungjoo.ham
Msgkey: 20120703094839361@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120703094839361@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <27961064.113941341309207263.JavaMail.weblogic@epml05>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t/tmbriBz/5Gzx8aGlxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgytj9+zFawS6ji95E/zA2MPwS7GDk5hATUJRYtOckGYksImEj0
	TTnBCGGLSVy4tx4ozgVUM59RYmH7KxaQBIuAisSj41eBijg42AT0JGZ+TgYJCwu4SXxofc8M
	YosIZEn0L/rBDtLLLDCTUeLnwR9sEMuUJNbsg5jDKyAocXLmExaIZaoSh1d9ZIWIq0l8/jYX
	6iAJiVnTL7BC2LwSM9qfQtXLSUz7uoYZwpaWOD9rA9zRi78/horzSxy7vYMJ5E6Q3if3g2HG
	7N78BWq8gMTUMwehWrUkFrf9Zoew+STWLHzLAjNm16nlzDC997fMZQKxmQUUJaZ0P2SHsLUk
	vvzYx4buLV4BJ4mvl38zTmCUm4UkNQtJ+ywk7chqFjCyrGIUTS1ILihOSk+10CtOzC0uzUvX
	S87P3cQIjvNnQjsYlzVYHGIU4GBU4uH13fXJX4g1say4MvcQowQHs5II79UtQCHelMTKqtSi
	/Pii0pzU4kOM0hwsSuK8fdYX/IUE0hNLUrNTUwtSi2CyTBycUg2MScx6zT9OHGMROx1ozBVY
	dD1Eji8hP6JQLHtuBMOa8A/n7aq7e+qUF04UbS3cvviR1yHxGZG1XGcPyzW++jz1zP0PQRcW
	BdU2Lany3fB/S+5DASV+pQfGnmVHKq10+KY+SNdkStjM4LKMI/7BhcmrO2+nrxdk2ryQq6PE
	/ejfndk7W3as+zlNiaU4I9FQi7moOBEAJM650O8CAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q639rZ9f015017

> The frequency set by userspace governor may not the
> same as the final frequency. If this condition happens,
> then "cat set_freq" will return a wrong value which is
> inconsistant with the real frequency.
> 
> This patch updates data->user_frequency after calling
> of update_devfreq. use devfreq->revious_freq as the
> final user_frequency.
> 
> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>

No, this is not a bug.

---- quoting Documentation/ABI/testing/sysfs-class-devfreq ----
What:           /sys/class/devfreq/.../userspace/set_freq
Date:           September 2011
Contact:        MyungJoo Ham <myungjoo.ham@samsung.com>
Description:
                The /sys/class/devfreq/.../userspace/set_freq shows and
                sets the requested frequency for the devfreq object if         
                userspace governor is in effect.
---- quote ended ----

set_freq shows the requested frequency, not the actual frequency value.

If you want to see the actual current frequency intended by devfreq,
use "cur_freq".



Cheers!
MyungJoo


> ---
>  drivers/devfreq/governor_userspace.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/devfreq/governor_userspace.c b/drivers/devfreq/governor_userspace.c
> index 0681246..85ad80a 100644
> --- a/drivers/devfreq/governor_userspace.c
> +++ b/drivers/devfreq/governor_userspace.c
> @@ -59,6 +59,7 @@ static ssize_t store_freq(struct device *dev, struct device_attribute *attr,
>  	err = update_devfreq(devfreq);
>  	if (err == 0)
>  		err = count;
> +	data->user_frequency = devfreq->previous_freq;
>  	mutex_unlock(&devfreq->lock);
>  	return err;
>  }
> -- 
> 1.7.0.4
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
