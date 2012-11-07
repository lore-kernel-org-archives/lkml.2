Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab2KGGym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 01:54:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:28425 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab2KGGyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 01:54:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,726,1344236400"; 
   d="scan'208";a="165388686"
Message-ID: <1352271274.2137.34.camel@rzhang1-mobl4>
Subject: Re: [PATCH V3 2/5] Thermal: fix bug of counting cpu frequencies.
From: Zhang Rui <rui.zhang@intel.com>
To: "hongbo.zhang" <hongbo.zhang@linaro.org>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, amit.kachhap@linaro.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, "hongbo.zhang" <hongbo.zhang@linaro.com>
Date: Wed, 07 Nov 2012 14:54:34 +0800
In-Reply-To: <1351615741-24134-3-git-send-email-hongbo.zhang@linaro.com>
References: <1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
	 <1351615741-24134-1-git-send-email-hongbo.zhang@linaro.com>
	 <1351615741-24134-3-git-send-email-hongbo.zhang@linaro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 17:48 +0100, hongbo.zhang wrote:
> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
> 
> In the while loop for counting cpu frequencies, if table[i].frequency equals
> CPUFREQ_ENTRY_INVALID, index i won't be increased, so this leads to an endless
> loop, what's more the index i cannot be referred as cpu frequencies number if
> there is CPUFREQ_ENTRY_INVALID case.
> 
> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
> Reviewed-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>

applied to thermal-next.

thanks,
rui
> ---
>  drivers/thermal/cpu_cooling.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index b6b4c2a..bfd62b7 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -245,6 +245,7 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
>  	struct cpumask *maskPtr;
>  	unsigned int cpu;
>  	struct cpufreq_frequency_table *table;
> +	unsigned long count = 0;
>  
>  	mutex_lock(&cooling_cpufreq_lock);
>  	list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
> @@ -263,13 +264,14 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
>  		goto return_get_max_state;
>  	}
>  
> -	while (table[i].frequency != CPUFREQ_TABLE_END) {
> +	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
>  		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>  			continue;
> -		i++;
> +		count++;
>  	}
> -	if (i > 0) {
> -		*state = --i;
> +
> +	if (count > 0) {
> +		*state = --count;
>  		ret = 0;
>  	}
>  


