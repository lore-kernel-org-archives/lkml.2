Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab1KDMVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:21:47 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:42510 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab1KDMVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:21:46 -0400
Message-ID: <4EB3D8BE.7050600@linux.vnet.ibm.com>
Date: Fri, 04 Nov 2011 17:51:18 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Robert Lee <rob.lee@linaro.org>
CC: rjw@sisk.pl, len.brown@intel.com, hpa@linux.intel.com,
        daniel.lezcano@linaro.org, amit.kucheria@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org
Subject: Re: [PATCH] pm: remove useless array definition in cpuidle_structure
References: <1320356693-18982-1-git-send-email-rob.lee@linaro.org>
In-Reply-To: <1320356693-18982-1-git-send-email-rob.lee@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11110412-3352-0000-0000-00000091DDB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 November 2011 03:14 AM, Robert Lee wrote:
> From: Daniel Lezcano <daniel.lezcano@linaro.org>
> 
> All the modules name are ro-data, it is never copied to the array.
> 
> eg.
> 
> static struct cpuidle_driver intel_idle_driver = {
>         .name = "intel_idle",
>         .owner = THIS_MODULE,
> };
> 
> It safe to assign the pointer of this ro-data to a const char *.
> By this way we save 12 bytes.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Robert Lee <rob.lee@linaro.org>
> ---
>  include/linux/cpuidle.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index b51629e..16f9dce 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -117,8 +117,8 @@ static inline int cpuidle_get_last_residency(struct cpuidle_device *dev)
>   ****************************/
> 
>  struct cpuidle_driver {
> -	char			name[CPUIDLE_NAME_LEN];
> -	struct module 		*owner;
> +	const char    *name;
> +	struct module *owner;
>  };
> 
>  #ifdef CONFIG_CPU_IDLE

This looks good, and makes it fool-proof by  not allowing one to tamper the name of the driver.
Tested OK on x86 (both Intel idle and ACPI)

Tested-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Reviewed-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>

