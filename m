Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab2HGEgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 00:36:46 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14175 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab2HGEgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 00:36:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 06 Aug 2012 21:36:45 -0700
Message-ID: <50209B59.7040201@nvidia.com>
Date: Tue, 7 Aug 2012 13:36:41 +0900
From: jinyoungp <jinyoungp@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120426 Thunderbird/13.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
CC: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: Re: [PATCH 2/3] backlight: aat2870: remove goto out
References: <003f01cd73b6$77ce18d0$676a4a70$%han@samsung.com>
In-Reply-To: <003f01cd73b6$77ce18d0$676a4a70$%han@samsung.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-send.

Acked-by: Jinyoung Park <jinyoungp@nvidia.com>

Thanks,
Jinyoung.

On 08/06/2012 06:32 PM, Jingoo Han wrote:
> This patch removes goto out, which makes code a bit smaller.
>
> Cc: Jin Park <jinyoungp@nvidia.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>   drivers/video/backlight/aat2870_bl.c |   13 ++++---------
>   1 files changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/video/backlight/aat2870_bl.c b/drivers/video/backlight/aat2870_bl.c
> index 7ff7522..619a1e0 100644
> --- a/drivers/video/backlight/aat2870_bl.c
> +++ b/drivers/video/backlight/aat2870_bl.c
> @@ -135,14 +135,12 @@ static int aat2870_bl_probe(struct platform_device *pdev)
>
>   	if (!pdata) {
>   		dev_err(&pdev->dev, "No platform data\n");
> -		ret = -ENXIO;
> -		goto out;
> +		return -ENXIO;
>   	}
>
>   	if (pdev->id != AAT2870_ID_BL) {
>   		dev_err(&pdev->dev, "Invalid device ID, %d\n", pdev->id);
> -		ret = -EINVAL;
> -		goto out;
> +		return -EINVAL;
>   	}
>
>   	aat2870_bl = devm_kzalloc(&pdev->dev,
> @@ -151,8 +149,7 @@ static int aat2870_bl_probe(struct platform_device *pdev)
>   	if (!aat2870_bl) {
>   		dev_err(&pdev->dev,
>   			"Failed to allocate memory for aat2870 backlight\n");
> -		ret = -ENOMEM;
> -		goto out;
> +		return -ENOMEM;
>   	}
>
>   	memset(&props, 0, sizeof(struct backlight_properties));
> @@ -163,8 +160,7 @@ static int aat2870_bl_probe(struct platform_device *pdev)
>   	if (IS_ERR(bd)) {
>   		dev_err(&pdev->dev,
>   			"Failed allocate memory for backlight device\n");
> -		ret = PTR_ERR(bd);
> -		goto out;
> +		return PTR_ERR(bd);
>   	}
>
>   	aat2870_bl->pdev = pdev;
> @@ -201,7 +197,6 @@ static int aat2870_bl_probe(struct platform_device *pdev)
>
>   out_bl_dev_unregister:
>   	backlight_device_unregister(bd);
> -out:
>   	return ret;
>   }
>
>

