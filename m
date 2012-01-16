Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab2APAyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 19:54:36 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:42180 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2APAyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 19:54:35 -0500
X-AuditID: cbfee60e-b7c59ae000007ec6-7a-4f137541d1d5
Date: Mon, 16 Jan 2012 00:54:25 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] devfreq: exynos4_bus: Use dev_get_drvdata at appropriate
 places
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120116004754490@myungjoo.ham
Msgkey: 20120116004754490@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120116004754490@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <11334034.8991326675264300.JavaMail.weblogic@epml24>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0G0t4H3008155

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Looks good. I'll apply this one.

> ---
>  drivers/devfreq/exynos4_bus.c |   16 ++++------------
>  1 files changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
> index cd563da..0b67537 100644
> --- a/drivers/devfreq/exynos4_bus.c
> +++ b/drivers/devfreq/exynos4_bus.c
> @@ -622,9 +622,7 @@ static int exynos4_bus_setvolt(struct busfreq_data *data, struct opp *opp,
>  static int exynos4_bus_target(struct device *dev, unsigned long *_freq)
>  {
>   int err = 0;
> - struct platform_device *pdev = container_of(dev, struct platform_device,
> -          dev);
> - struct busfreq_data *data = platform_get_drvdata(pdev);
> + struct busfreq_data *data = dev_get_drvdata(dev);
>   struct opp *opp = devfreq_recommended_opp(dev, _freq);
>   unsigned long old_freq = opp_get_freq(data->curr_opp);
>   unsigned long freq = opp_get_freq(opp);
> @@ -689,9 +687,7 @@ static int exynos4_get_busier_dmc(struct busfreq_data *data)
>  static int exynos4_bus_get_dev_status(struct device *dev,
>            struct devfreq_dev_status *stat)
>  {
> - struct platform_device *pdev = container_of(dev, struct platform_device,
> -          dev);
> - struct busfreq_data *data = platform_get_drvdata(pdev);
> + struct busfreq_data *data = dev_get_drvdata(dev);
>   int busier_dmc;
>   int cycles_x2 = 2; /* 2 x cycles */
>   void __iomem *addr;
> @@ -739,9 +735,7 @@ static int exynos4_bus_get_dev_status(struct device *dev,
>  
>  static void exynos4_bus_exit(struct device *dev)
>  {
> - struct platform_device *pdev = container_of(dev, struct platform_device,
> -          dev);
> - struct busfreq_data *data = platform_get_drvdata(pdev);
> + struct busfreq_data *data = dev_get_drvdata(dev);
>  
>   devfreq_unregister_opp_notifier(dev, data->devfreq);
>  }
> @@ -1087,9 +1081,7 @@ static __devexit int exynos4_busfreq_remove(struct platform_device *pdev)
>  
>  static int exynos4_busfreq_resume(struct device *dev)
>  {
> - struct platform_device *pdev = container_of(dev, struct platform_device,
> -          dev);
> - struct busfreq_data *data = platform_get_drvdata(pdev);
> + struct busfreq_data *data = dev_get_drvdata(dev);
>  
>   busfreq_mon_reset(data);
>   return 0;
> -- 
> 1.7.5.4
> 
> 


------- Original Message -------
Sender : Axel Lin<axel.lin@gmail.com>
Date : 2012-01-14 17:56 (GMT+09:00)
Title : [PATCH] devfreq: exynos4_bus: Use dev_get_drvdata at appropriate places

Signed-off-by: Axel Lin 
---
drivers/devfreq/exynos4_bus.c |   16 ++++------------
1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
index cd563da..0b67537 100644
--- a/drivers/devfreq/exynos4_bus.c
+++ b/drivers/devfreq/exynos4_bus.c
@@ -622,9 +622,7 @@ static int exynos4_bus_setvolt(struct busfreq_data *data, struct opp *opp,
static int exynos4_bus_target(struct device *dev, unsigned long *_freq)
{
int err = 0;
- struct platform_device *pdev = container_of(dev, struct platform_device,
-     dev);
- struct busfreq_data *data = platform_get_drvdata(pdev);
+ struct busfreq_data *data = dev_get_drvdata(dev);
struct opp *opp = devfreq_recommended_opp(dev, _freq);
unsigned long old_freq = opp_get_freq(data->curr_opp);
unsigned long freq = opp_get_freq(opp);
@@ -689,9 +687,7 @@ static int exynos4_get_busier_dmc(struct busfreq_data *data)
static int exynos4_bus_get_dev_status(struct device *dev,
      struct devfreq_dev_status *stat)
{
- struct platform_device *pdev = container_of(dev, struct platform_device,
-     dev);
- struct busfreq_data *data = platform_get_drvdata(pdev);
+ struct busfreq_data *data = dev_get_drvdata(dev);
int busier_dmc;
int cycles_x2 = 2; /* 2 x cycles */
void __iomem *addr;
@@ -739,9 +735,7 @@ static int exynos4_bus_get_dev_status(struct device *dev,

static void exynos4_bus_exit(struct device *dev)
{
- struct platform_device *pdev = container_of(dev, struct platform_device,
-     dev);
- struct busfreq_data *data = platform_get_drvdata(pdev);
+ struct busfreq_data *data = dev_get_drvdata(dev);

devfreq_unregister_opp_notifier(dev, data->devfreq);
}
@@ -1087,9 +1081,7 @@ static __devexit int exynos4_busfreq_remove(struct platform_device *pdev)

static int exynos4_busfreq_resume(struct device *dev)
{
- struct platform_device *pdev = container_of(dev, struct platform_device,
-     dev);
- struct busfreq_data *data = platform_get_drvdata(pdev);
+ struct busfreq_data *data = dev_get_drvdata(dev);

busfreq_mon_reset(data);
return 0;
-- 
1.7.5.4






 MyungJoo Ham (ÇÔ¸íÁÖ)
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
