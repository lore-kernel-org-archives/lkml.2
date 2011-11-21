Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1KUQKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:10:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46071 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab1KUQKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:10:02 -0500
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=KUFFyxvNv1MA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=AQSfwKovIIyiS5fxFQQA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 3/3] rcu: Drive configuration directly from SMP and
 PREEMPT
From: Steven Rostedt <rostedt@goodmis.org>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1321707028-12487-4-git-send-email-jkacur@redhat.com>
References: <1321707028-12487-1-git-send-email-jkacur@redhat.com>
	 <1321707028-12487-4-git-send-email-jkacur@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 11:10:00 -0500
Message-ID: <1321891800.20742.11.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-11-19 at 13:50 +0100, John Kacur wrote:
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> This commit eliminates the possibility of running TREE_PREEMPT_RCU
> when SMP=n and of running TINY_RCU when PREEMPT=y.  People who really
> want these combinations can hand-edit init/Kconfig, but eliminating
> them as choices for production systems reduces the amount of testing
> required.  It will also allow cutting out a few #ifdefs.
> 
> Note that running TREE_RCU and TINY_RCU on single-CPU systems using
> SMP-built kernels is still supported.

With this patch, I can see the need for the first patch (although
there's things broken even for that), but is this really a stable fix?

This looks more of an added feature than a bug fix. It's a bug fix if we
consider running tree_rcu on UP a bug. Or better stated, will it break
anything if we do that?

-- Steve

> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> commit 8008e129dc90ff4f7a56cb033d6bd042afe3ed52 upstream
> Cherry-picked for v3.0-rt and fixed-up merge conflicts
> Note: This makes the depends lines for these options in init/Kconfig for v3.0-rt
> match those for v3.2-rc2-rt3
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  init/Kconfig |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 89e40a4..5c1147e 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -391,7 +391,7 @@ config TREE_RCU
>  
>  config TREE_PREEMPT_RCU
>  	bool "Preemptible tree-based hierarchical RCU"
> -	depends on PREEMPT
> +	depends on PREEMPT && SMP
>  	help
>  	  This option selects the RCU implementation that is
>  	  designed for very large SMP systems with hundreds or
> @@ -401,7 +401,7 @@ config TREE_PREEMPT_RCU
>  
>  config TINY_RCU
>  	bool "UP-only small-memory-footprint RCU"
> -	depends on !SMP && !PREEMPT_RT_FULL
> +	depends on !PREEMPT && !SMP
>  	help
>  	  This option selects the RCU implementation that is
>  	  designed for UP systems from which real-time response
> @@ -410,7 +410,7 @@ config TINY_RCU
>  
>  config TINY_PREEMPT_RCU
>  	bool "Preemptible UP-only small-memory-footprint RCU"
> -	depends on !SMP && PREEMPT && !PREEMPT_RT_FULL
> +	depends on PREEMPT && !SMP
>  	help
>  	  This option selects the RCU implementation that is designed
>  	  for real-time UP systems.  This option greatly reduces the


