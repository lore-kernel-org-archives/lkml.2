Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab2LNXb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:31:58 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34202 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932786Ab2LNXb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:31:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sivaram Nair <sivaramn@nvidia.com>
Cc: ccross@android.com, santosh.shilimkar@ti.com, khilman@ti.com,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cpuidle: coupled: fix ready counter decrement
Date: Sat, 15 Dec 2012 00:37:03 +0100
Message-ID: <4511257.Msp501Wi5G@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1355474528-13094-1-git-send-email-sivaramn@nvidia.com>
References: <1355474528-13094-1-git-send-email-sivaramn@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 14, 2012 10:42:08 AM Sivaram Nair wrote:
> The ready_waiting_counts atomic variable is compared against the wrong
> online cpu count. The latter is computed incorrectly using logical-OR
> instead of bit-OR. This patch fixes that.

I'm queuing this up for submission as v3.8 material.

I suppose it should be marked for -stable too?

Rafael


> Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
> ---
>  drivers/cpuidle/coupled.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
> index 3265844..2a297f8 100644
> --- a/drivers/cpuidle/coupled.c
> +++ b/drivers/cpuidle/coupled.c
> @@ -209,7 +209,7 @@ inline int cpuidle_coupled_set_not_ready(struct cpuidle_coupled *coupled)
>  	int all;
>  	int ret;
>  
> -	all = coupled->online_count || (coupled->online_count << WAITING_BITS);
> +	all = coupled->online_count | (coupled->online_count << WAITING_BITS);
>  	ret = atomic_add_unless(&coupled->ready_waiting_counts,
>  		-MAX_WAITING_CPUS, all);
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
