Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab2APLNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 06:13:22 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54182 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2APLNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 06:13:21 -0500
Message-ID: <4F140642.6060105@linux.vnet.ibm.com>
Date: Mon, 16 Jan 2012 16:43:06 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: jhbird.choi@samsung.com
CC: linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Len Brown <len.brown@intel.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] cpuidle: fix an incorrect NULL pointer check
References: <1326494567-579-1-git-send-email-jhbird.choi@samsung.com>
In-Reply-To: <1326494567-579-1-git-send-email-jhbird.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011611-4790-0000-0000-000000E16C07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2012 04:12 AM, jhbird.choi@samsung.com wrote:

> From: Jonghwan Choi <jhbird.choi@samsung.com>
> 
> "cpu_dev" should be checked instead of "dev".
> 
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/cpuidle/cpuidle.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 59f4261..7771810 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -294,7 +294,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
>  	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
>  	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
> 
> -	if (!dev)
> +	if (!cpu_dev)
>  		return -EINVAL;
>  	if (!try_module_get(cpuidle_driver->owner))
>  		return -EINVAL;


Reviewed-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>

Cheers
Deepthi

