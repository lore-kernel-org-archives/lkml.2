Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab2LVDGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:06:11 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48156 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2LVDF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:05:57 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-05-50d523938d5e
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tejun Heo'" <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-24-git-send-email-tj@kernel.org>
In-reply-to: <1356141435-17340-24-git-send-email-tj@kernel.org>
Subject: RE: [PATCH 23/25] video/exynos: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 19:05:51 -0800
Message-id: <00af01cddff1$4170db40$c45291c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ/4CUv+xedZ2SKZIakOfxpmulFtgJKzeF9lq3J7KA=
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t8zfd3JylcDDFaskbe4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZO5oXsxfc5q2Yve8scwPjBO4uRk4OCQETib3dv1ghbDGJC/fW
	s3UxcnEICSxjlLj98xYbTNHXO6eYIRLTGSVeLD8NVTWPSeJAyykWkCo2AQ2Jw++fsYPYIgK2
	EvPffGIEsZkFEiSOTvnCDGILCRRJtN+aClbPKWAv8eLlKSYQW1jAW6L7+30wm0VAVWLhnJ1g
	m3kFLCX+HOhlgrAFJX5MvscCMVNLYv3O40wQtrzE5jVvmSEuVZDYcfY1I8QNVhKzHr1mh6gR
	l5j04CE7xHwBiW+TDwHN4QCql5XYdADsMQmBRewS8/50sEDMkZQ4uOIGywRGiVlIVs9CsnoW
	ktWzkKxYwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyMkuqR2MK5ssDjEKMDBqMTDq9l6
	JUCINbGsuDL3EKMEB7OSCK+a0tUAId6UxMqq1KL8+KLSnNTiQ4w+QJdPZJYSTc4HRn5eSbyh
	sbGJmYmpibmlqbkpDmElcd5mj5QAIYH0xJLU7NTUgtQimHFMHJxSDYzq17j6/lWWLr69Q7n6
	4A+OS/mNDAH/556xUhCdckHxzbxrZRLfV84ztb//obWr2cxsk/rRGwmnFD8dnfxpyv6TzByT
	DewTeB7tmBpXHt3yLLO3+1qM4pk/BnlTWAosZtl6O2uWyzZdF+L83reHNWXuvvOPH6vpS154
	yGq7e/XcEzuuP/kxXYJJiaU4I9FQi7moOBEAimGkEdsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t9jQd3JylcDDF73SVlc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjB3Ni9kLbvNWzN53lrmB
	cQJ3FyMnh4SAicTXO6eYIWwxiQv31rN1MXJxCAlMZ5R4sfw0lDOPSeJAyykWkCo2AQ2Jw++f
	sYPYIgK2EvPffGIEsZkFEiSOTvkCNklIoEii/dZUsHpOAXuJFy9PMYHYwgLeEt3f74PZLAKq
	Egvn7GQDsXkFLCX+HOhlgrAFJX5MvscCMVNLYv3O40wQtrzE5jVvoS5VkNhx9jUjxA1WErMe
	vWaHqBGXmPTgIfsERqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yf
	u4kRHLvPpHYwrmywOMQowMGoxMOr2XolQIg1say4MvcQowQHs5IIr5rS1QAh3pTEyqrUovz4
	otKc1OJDjD5An05klhJNzgemlbySeENjEzMjSyMzCyMTc3McwkrivM0eKQFCAumJJanZqakF
	qUUw45g4OKUaGPVv31Fuz/cyXVbFwrYw4fDvcsFf628tmB66JJ197VFVtg0n+M5sMLJf3PUw
	zv7YS2uvdQtTHkv9swxPZlf1sl2nPuvz3pzKUuF5CXM+OYU8+Pre23ryLo2sDYfPHeDQPGPi
	9CIyRNXjWeQuc45ZMQnXzojP/pX37vQK7jWPtEMOvfL697DqM6MSS3FGoqEWc1FxIgDyeh1r
	CgMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> 
> There's no need to test whether a (delayed) work item in pending
> before queueing, flushing or cancelling it.  Most uses are unnecessary
> and quite a few of them are buggy.
> 
> Remove unnecessary pending tests from exynos_dp_core.  Only compile
> tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

> ---
> Please let me know how this patch should be routed.  I can take it
> through the workqueue tree if necessary.
> 
Cc'ed Jingoo and Florian.

Now the exynos dp driver are being handled by Jingoo so let's waiting for
his opinion to take this by himself or not. 

- Kukjin Kim

> Thanks.
> 
>  drivers/video/exynos/exynos_dp_core.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/video/exynos/exynos_dp_core.c
> b/drivers/video/exynos/exynos_dp_core.c
> index 28fd686..3002a6a 100644
> --- a/drivers/video/exynos/exynos_dp_core.c
> +++ b/drivers/video/exynos/exynos_dp_core.c
> @@ -1121,8 +1121,7 @@ static int __devexit exynos_dp_remove(struct
> platform_device *pdev)
> 
>  	disable_irq(dp->irq);
> 
> -	if (work_pending(&dp->hotplug_work))
> -		flush_work(&dp->hotplug_work);
> +	flush_work(&dp->hotplug_work);
> 
>  	if (pdev->dev.of_node) {
>  		if (dp->phy_addr)
> @@ -1144,8 +1143,7 @@ static int exynos_dp_suspend(struct device *dev)
>  	struct exynos_dp_platdata *pdata = dev->platform_data;
>  	struct exynos_dp_device *dp = dev_get_drvdata(dev);
> 
> -	if (work_pending(&dp->hotplug_work))
> -		flush_work(&dp->hotplug_work);
> +	flush_work(&dp->hotplug_work);
> 
>  	if (dev->of_node) {
>  		if (dp->phy_addr)
> --
> 1.8.0.2

