Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946138Ab2LNX54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:57:56 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34236 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945965Ab2LNX5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:57:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sivaram Nair <sivaramn@nvidia.com>
Cc: rafael.j.wysocki@intel.com, daniel.lezcano@linaro.org, shuox.liu@intel.com,
        akpm@linux-foundation.org, yanmin_zhang@intel.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpuidle: fix sysfs output for power_usage
Date: Sat, 15 Dec 2012 01:03:02 +0100
Message-ID: <39891276.jhMMUpZpil@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1355491060-970-2-git-send-email-sivaramn@nvidia.com>
References: <1355491060-970-1-git-send-email-sivaramn@nvidia.com> <1355491060-970-2-git-send-email-sivaramn@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 14, 2012 03:17:37 PM Sivaram Nair wrote:
> cpuidle_state->power_usage is signed; so change the corresponding sysfs
> ops to output signed value instead of unsigned.

What's actually wrong with printing it as an unsigned int?

Rafael


> Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
> ---
>  drivers/cpuidle/sysfs.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> index 3409429..2fc79cd 100644
> --- a/drivers/cpuidle/sysfs.c
> +++ b/drivers/cpuidle/sysfs.c
> @@ -232,6 +232,13 @@ static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0644, show, store)
>  static ssize_t show_state_##_name(struct cpuidle_state *state, \
>  			 struct cpuidle_state_usage *state_usage, char *buf) \
>  { \
> +	return sprintf(buf, "%d\n", state->_name);\
> +}
> +
> +#define define_show_state_u_function(_name) \
> +static ssize_t show_state_##_name(struct cpuidle_state *state, \
> +			 struct cpuidle_state_usage *state_usage, char *buf) \
> +{ \
>  	return sprintf(buf, "%u\n", state->_name);\
>  }
>  
> @@ -270,7 +277,7 @@ static ssize_t show_state_##_name(struct cpuidle_state *state, \
>  	return sprintf(buf, "%s\n", state->_name);\
>  }
>  
> -define_show_state_function(exit_latency)
> +define_show_state_u_function(exit_latency)
>  define_show_state_function(power_usage)
>  define_show_state_ull_function(usage)
>  define_show_state_ull_function(time)
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
