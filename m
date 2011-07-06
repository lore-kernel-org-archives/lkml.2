Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab1GFTbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:31:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49246 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714Ab1GFTbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:31:08 -0400
Message-ID: <4E14B7F6.2050401@ti.com>
Date: Wed, 6 Jul 2011 20:31:02 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jin Park <jinyoungp@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/2] regulator: aat2870: Fix the logic of checking if
 no id is matched in aat2870_get_regulator
References: <1309923277.26847.5.camel@phoenix>
In-Reply-To: <1309923277.26847.5.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/11 04:34, Axel Lin wrote:
> In current implementation, the pointer ri is not NULL if no id is matched.
> Fix it by checking i == ARRAY_SIZE(aat2870_regulators) if no id is matched.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
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

Can you resend both of these to Samuel with Mark's Ack as aat2870 went upstream via MFD.

Liam
