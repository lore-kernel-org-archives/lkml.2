Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab1JEVhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 17:37:40 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13294 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050Ab1JEVhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 17:37:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6490"; a="125116330"
Message-ID: <4E8CCE22.9050205@codeaurora.org>
Date: Wed, 05 Oct 2011 14:37:38 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: greg@kroah.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] drivercore: Add helper macro for platform_driver boilerplate
References: <20111004232403.10364.22050.stgit@ponder>
In-Reply-To: <20111004232403.10364.22050.stgit@ponder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/11 16:26, Grant Likely wrote:
> diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> index 27bb05a..991a678 100644
> --- a/include/linux/platform_device.h
> +++ b/include/linux/platform_device.h
> @@ -146,6 +146,21 @@ static inline void platform_set_drvdata(struct platform_device *pdev, void *data
>  	dev_set_drvdata(&pdev->dev, data);
>  }
>  
> +/* Helper macro for drivers that don't do anything special in module
> + * init/exit.  This eliminates a lot of boilerplate */
> +#define module_platform_driver(__platform_driver) \
> +int __platform_driver##_init(void) \
> +{ \
> +	return platform_driver_register(&(__platform_driver)); \
> +} \
> +module_init(__platform_driver##_init); \
> +void __platform_driver##_exit(void) \
> +{ \
> +	platform_driver_unregister(&(__platform_driver)); \
> +} \
> +module_exit(__platform_driver##_exit);
> +
> +
>

Can you add __init, __exit, and static as well?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

