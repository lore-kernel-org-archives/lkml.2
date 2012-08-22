Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab2HVKEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:04:33 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17600 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab2HVKEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:04:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 22 Aug 2012 03:04:28 -0700
Message-ID: <5034AA28.5050306@nvidia.com>
Date: Wed, 22 Aug 2012 15:15:12 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "rabin.vincent@gmail.com" <rabin.vincent@gmail.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: disable supply regulator if it is enabled
 for boot-on
References: <1344938848-29606-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1344938848-29606-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rabin,
Is it resolved the issue you mentioned?

Thanks,
Laxman

On Tuesday 14 August 2012 03:37 PM, Laxman Dewangan wrote:
> If supply regulator is enabled because of boot-on (not always-on)
> then disable regulator need to be call if regulator have some
> user or full constraint has been enabled.
> This will make sure that reference count of supply regulator
> is in sync with child regulator's state.
>
> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> Reported-by: Rabin Vincent<rabin.vincent@gmail.com>
> ---
>   drivers/regulator/core.c |    7 ++++++-
>   1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 0fffeae..4632909 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -3614,8 +3614,11 @@ static int __init regulator_init_complete(void)
>
>   		mutex_lock(&rdev->mutex);
>
> -		if (rdev->use_count)
> +		if (rdev->use_count) {
> +			if (rdev->supply&&  c->boot_on)
> +				regulator_disable(rdev->supply);
>   			goto unlock;
> +		}
>
>   		/* If we can't read the status assume it's on. */
>   		if (ops->is_enabled)
> @@ -3634,6 +3637,8 @@ static int __init regulator_init_complete(void)
>   			if (ret != 0) {
>   				rdev_err(rdev, "couldn't disable: %d\n", ret);
>   			}
> +			if (rdev->supply)
> +				regulator_disable(rdev->supply);
>   		} else {
>   			/* The intention is that in future we will
>   			 * assume that full constraints are provided

