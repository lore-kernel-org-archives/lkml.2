Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2JOU0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:26:34 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47933 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab2JOU0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:26:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Tu, Xiaobing" <xiaobing.tu@intel.com>
Cc: "davej@redhat.com" <davej@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Tang, Guifang" <guifang.tang@intel.com>
Subject: Re: Fix memory leak in cpufreq stats.
Date: Mon, 15 Oct 2012 22:30:04 +0200
Message-ID: <3402692.Elm8oBRUJI@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <EE928378561BF1449699C96571234A740FE66C2A@SHSMSX102.ccr.corp.intel.com>
References: <EE928378561BF1449699C96571234A740FE66C2A@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 of October 2012 02:48:28 Tu, Xiaobing wrote:
> 
> Fix memory leak in cpufreq stats.
> 
> When system enter sleep, non-boot CPUs will be disable.
> Cpufreq stats sysfs is created when the CPU is up, but it is not freed when
> the CPU going down. This will cause memory leak.
> signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
> signed-off-by: guifang tang <guifang.tang@intel.com>

I will push this patch for v3.7 in the -rc3 time frame if no one objects.

Thanks,
Rafael


> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> index b40ee14..3998316 100644
> --- a/drivers/cpufreq/cpufreq_stats.c
> +++ b/drivers/cpufreq/cpufreq_stats.c
> @@ -328,6 +328,7 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
>                 cpufreq_update_policy(cpu);
>                 break;
>         case CPU_DOWN_PREPARE:
> +       case CPU_DOWN_PREPARE_FROZEN:
>                 cpufreq_stats_free_sysfs(cpu);
>                 break;
>         case CPU_DEAD:
> 
> Br
> XiaoBing Tu
> PSI@System Integration Shanghai
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
