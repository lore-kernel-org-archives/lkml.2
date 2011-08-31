Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab1HaN0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:26:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33656 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab1HaN0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:26:37 -0400
Message-ID: <4E5E3684.8030307@ti.com>
Date: Wed, 31 Aug 2011 14:26:28 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jin Park <jinyoungp@nvidia.com>
Subject: Re: [PATCH 1/2 RESEND] regulator: aat2870: Fix the logic of checking
 if no id is matched in aat2870_get_regulator
References: <1314629299.2753.1.camel@phoenix>
In-Reply-To: <1314629299.2753.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/11 15:48, Axel Lin wrote:
> In current implementation, the pointer ri is not NULL if no id is matched.
> Fix it by checking i == ARRAY_SIZE(aat2870_regulators) if no id is matched.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/aat2870-regulator.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
> index cd41045..11d1ab4 100644
> --- a/drivers/regulator/aat2870-regulator.c
> +++ b/drivers/regulator/aat2870-regulator.c
> @@ -159,7 +159,7 @@ static struct aat2870_regulator *aat2870_get_regulator(int id)
>  			break;
>  	}
>  
> -	if (!ri)
> +	if (i == ARRAY_SIZE(aat2870_regulators))
>  		return NULL;
>  
>  	ri->enable_addr = AAT2870_LDO_EN;

Both applied.

Thanks

Liam
