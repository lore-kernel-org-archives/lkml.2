Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab2LQSYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:24:22 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52724 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab2LQSYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:24:17 -0500
X-IronPort-AV: E=Sophos;i="4.84,303,1355126400"; 
   d="scan'208";a="14724086"
Message-ID: <50CF634F.1040708@codeaurora.org>
Date: Mon, 17 Dec 2012 10:24:15 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Fabio Baltieri <fabio.baltieri@linaro.org>
CC: John Stultz <johnstul@us.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] cpufreq: db8500: set CPUFREQ_CONST_LOOPS
References: <1354615845-2758-1-git-send-email-fabio.baltieri@linaro.org> <1354615845-2758-3-git-send-email-fabio.baltieri@linaro.org>
In-Reply-To: <1354615845-2758-3-git-send-email-fabio.baltieri@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/12 02:10, Fabio Baltieri wrote:
> As ux500 is being converted to timer based delay loops, and the timer
> used is not depending on CPUs clock frequency, set cpufreq_driver flag
> CPUFREQ_CONST_LOOPS to prevent cpufreq rescaling loops_for_jiffies.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>  drivers/cpufreq/db8500-cpufreq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/db8500-cpufreq.c b/drivers/cpufreq/db8500-cpufreq.c
> index 74b830b..e758891 100644
> --- a/drivers/cpufreq/db8500-cpufreq.c
> +++ b/drivers/cpufreq/db8500-cpufreq.c
> @@ -150,7 +150,7 @@ static int __cpuinit db8500_cpufreq_init(struct cpufreq_policy *policy)
>  }
>  
>  static struct cpufreq_driver db8500_cpufreq_driver = {
> -	.flags  = CPUFREQ_STICKY,
> +	.flags  = CPUFREQ_STICKY | CPUFREQ_CONST_LOOPS,
>  	.verify = db8500_cpufreq_verify_speed,
>  	.target = db8500_cpufreq_target,
>  	.get    = db8500_cpufreq_getspeed,

Wouldn't you want to fold this into the previous patch so bisection is
not broken? Otherwise you have a place where lpj is all screwed up when
cpufreq mucks with it.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

