Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab2FSKTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:19:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24504 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab2FSKTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:19:09 -0400
X-AuditID: cbfee60d-b7f056d000004fc9-7f-4fe0521b9f03
Date: Tue, 19 Jun 2012 10:19:07 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 1/2] extcon: Set platform drvdata in gpio_extcon_probe()
 and fix irq leak
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Lockwood <lockwood@android.com>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120619101425158@myungjoo.ham
Msgkey: 20120619101425158@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120619101425158@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <22448380.601061340101146820.JavaMail.weblogic@epml24>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t/tGbrSQQ/8DV63SVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MDa97mAu6BCpO7jrE2sB4gb+LkZNDSEBdYtGSk2xdjBwcEgIm
	En9/R4CEJQTEJC7cWw8U5gIqmc8o8eLDFyaQBIuAqsS7nmOMIPVsAuYS92cEgYSFBWIlduy9
	zwpiiwikSHROns8O0sssMIVR4t20dUwQu5Qk1ux7xQJi8woISpyc+YQFYpmqxIptL5lAZvIK
	qEk86BGDCEtIzJp+gRXC5pWY0f4UqlxOYtrXNcwQtrTE+VkbGGFuXvz9MVScX+LY7R1MEG/x
	Sjy5HwwzZvfmL2wQtoDE1DMHoVq1JNb29UPZfBJrFr5lgRmz69RysJHMAooSU7ofskPYWhJf
	fuxjQ/cJr4CTxKFVH9kmMMrOQpKahaR9FpJ2ZDULGFlWMYqmFiQXFCelpxrrFSfmFpfmpesl
	5+duYgTH8jPeHYxzGywOMQpwMCrx8P72feAvxJpYVlyZe4hRgoNZSYR31f/7/kK8KYmVValF
	+fFFpTmpxYcYpTlYlMR5p1hf8BcSSE8sSc1OTS1ILYLJMnFwSjUw5m2dlGusYtLjz8LZs263
	38oZry5dZLLtbrP22SQ1Ja4svzNdXPzqvNUnYu5peG64M/3Q/2PH3j3hvz5Z/fjyZQF39izk
	Znff9vHvftaFmzjqedUeNj3TrleZfpaby11m/ZorfP/FFt2R1nl5f/arlkkbZ0/z8c2Mebpo
	vhDHjmMyjLYH8ty/GiuxFGckGmoxFxUnAgBcj5TR4QIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5JAK5Zh027180

> Add missing platform_set_drvdata() in gpio_extcon_probe(), otherwise calling
> platform_get_drvdata in gpio_extcon_remove() returns NULL.
> 
> Also add missing free_irq call in gpio_extcon_remove().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thanks!


Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

I'll apply this patch to the extcon-for-next.
I would appear in http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next soon after syncing servers.


Cheers!
MyungJoo

> ---
>  drivers/extcon/extcon_gpio.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/extcon/extcon_gpio.c b/drivers/extcon/extcon_gpio.c
> index fe7a07b..8a0dcc1 100644
> --- a/drivers/extcon/extcon_gpio.c
> +++ b/drivers/extcon/extcon_gpio.c
> @@ -125,6 +125,7 @@ static int __devinit gpio_extcon_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		goto err_request_irq;
>  
> +	platform_set_drvdata(pdev, extcon_data);
>  	/* Perform initial detection */
>  	gpio_extcon_work(&extcon_data->work.work);
>  
> @@ -146,6 +147,7 @@ static int __devexit gpio_extcon_remove(struct platform_device *pdev)
>  	struct gpio_extcon_data *extcon_data = platform_get_drvdata(pdev);
>  
>  	cancel_delayed_work_sync(&extcon_data->work);
> +	free_irq(extcon_data->irq, extcon_data);
>  	gpio_free(extcon_data->gpio);
>  	extcon_dev_unregister(&extcon_data->edev);
>  	devm_kfree(&pdev->dev, extcon_data);
> -- 
> 1.7.9.5
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
