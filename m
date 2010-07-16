Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750955Ab0GPEHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 00:07:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:5867 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab0GPEHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 00:07:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,212,1278313200"; 
   d="scan'208";a="818658393"
Message-ID: <4C3FDAF1.7030107@linux.intel.com>
Date: Thu, 15 Jul 2010 21:07:13 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Ai Li <aili@codeaurora.org>
CC: akpm@linux-foundation.org, dwalker@codeaurora.org, mingo@elte.hu,
        shemminger@vyatta.com, czoccolo@gmail.com, len.brown@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] cpuidle: extend cpuidle and menu governor to handle dynamic
 states
References: <1279225825-31069-1-git-send-email-aili@codeaurora.org>
In-Reply-To: <1279225825-31069-1-git-send-email-aili@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/15/2010 1:30 PM, Ai Li wrote:

I'm ok with the general idea, but have a few comments about the 
implementation
> Signed-off-by: Ai Li<aili@codeaurora.org>
> ---
>   drivers/cpuidle/governors/menu.c |   59 +++++++++++++++++++++++++++++--------
>   include/linux/cpuidle.h          |    4 ++
>   2 files changed, 50 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index 1b12870..b3854cc 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -271,6 +271,9 @@ static int menu_select(struct cpuidle_device *dev)
>
>   	detect_repeating_patterns(data);
>
> +	if (dev->prepare)
> +		dev->prepare(dev, data->predicted_us);
>    

I don't like the idea of passing predicted_us here.
the states and their updates should be independent of how long we think 
we'll be idle;
it's up to the menu governor to then pick a good one, not for the 
platform to muck with things
based on this.

Also I would like the cpuidle code, not the governor, to call this 
prepare function.
The need to call ->prepare is governor independent....



+ if (dev->compare_power) {

I'm not a big fan of this as a flag; either we always do this, which I 
can understand, or we sort things, which is also fine with me.
Doing this condition like this.... not a fan.

