Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab2DNFAF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 01:00:05 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25907 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab2DNFAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 01:00:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6679"; a="179378868"
Message-ID: <4F890452.1060709@codeaurora.org>
Date: Fri, 13 Apr 2012 22:00:02 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: core: Add checking set_mode callback in regulator_set_optimum_mode
References: <1334314167.4244.1.camel@phoenix>
In-Reply-To: <1334314167.4244.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/13/2012 3:49 AM, Axel Lin wrote:
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 1bd71a8..f241671 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -2340,6 +2340,11 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
>  	 */
>  	ret = -EINVAL;
>  
> +	if (!rdev->desc->ops->set_mode) {
> +		rdev_err(rdev, "no set_mode operation\n");
> +		goto out;
> +	}
> +
>  	/* get output voltage */

regulator_set_mode() just returns an error silently if there isn't a
set_mode() op. Why print an error in this case?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

