Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab0ETArW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 20:47:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33859 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab0ETArU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 20:47:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 20 May 2010 09:43:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Thomas Renninger <trenn@suse.de>
Cc: peterz@infradead.org, mike@android.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, menage@google.com,
       containers@lists.linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 2/2] scheduler: cgroups cpuaccouting: Make cpuusage
 atomic
Message-Id: <20100520094311.999d3d92.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1274295539-7798-3-git-send-email-trenn@suse.de>
References: <1274264877.5605.10541.camel@twins>
	<1274295539-7798-3-git-send-email-trenn@suse.de>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 20:58:59 +0200
Thomas Renninger <trenn@suse.de> wrote:

> and avoid locking on 32 bit.
> This resolves an ugly dependency in cgroups_cpuaccount.c
> to per_cpu runqueues lock variable.
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: linux-kernel@vger.kernel.org
> CC: mike@android.com
> CC: menage@google.com
> CC: lizf@cn.fujitsu.com
> CC: containers@lists.linux-foundation.org
> CC: mingo@elte.hu
> CC: peterz@infradead.org
> ---
>  kernel/cgroup_cpuaccount.c |   39 +++++++++------------------------------
>  kernel/sched.c             |   11 -----------
>  kernel/sched.h             |    7 -------
>  3 files changed, 9 insertions(+), 48 deletions(-)
>  delete mode 100644 kernel/sched.h
> 
> diff --git a/kernel/cgroup_cpuaccount.c b/kernel/cgroup_cpuaccount.c
> index 0ad356a..0a53487 100644
> --- a/kernel/cgroup_cpuaccount.c
> +++ b/kernel/cgroup_cpuaccount.c
> @@ -10,8 +10,6 @@
>  
>  #include <asm/cputime.h>
>  
> -#include "sched.h"
> -
>  /*
>   * CPU accounting code for task groups.
>   *
> @@ -23,7 +21,7 @@
>  struct cpuacct {
>  	struct cgroup_subsys_state css;
>  	/* cpuusage holds pointer to a u64-type object on every cpu */
> -	u64 __percpu *cpuusage;
> +	atomic64_t __percpu *cpuusage;

Hmmm...how about adding seq_counter for 32bit rather than atomic64_t ?

Thanks,
-Kame

