Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab2FERQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:16:53 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:44661 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab2FERQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:16:52 -0400
Message-ID: <4FCE3ECB.4040806@linux.vnet.ibm.com>
Date: Tue, 05 Jun 2012 22:45:55 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        rusty@rustcorp.com.au, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:smp/hotplug] smp: Remove num_booting_cpus()
References: <tip-43cc7e86f3200b094e2960b732623aeec00b482d@git.kernel.org>
In-Reply-To: <tip-43cc7e86f3200b094e2960b732623aeec00b482d@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12060517-2000-0000-0000-000007D04D57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 09:22 PM, tip-bot for Thomas Gleixner wrote:

> Commit-ID:  43cc7e86f3200b094e2960b732623aeec00b482d
> Gitweb:     http://git.kernel.org/tip/43cc7e86f3200b094e2960b732623aeec00b482d
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Tue, 15 May 2012 17:26:16 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Tue, 5 Jun 2012 17:32:30 +0200
> 
> smp: Remove num_booting_cpus()
> 
> No users.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>


Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  arch/m32r/include/asm/smp.h |    5 -----
>  arch/x86/include/asm/smp.h  |    5 -----
>  include/linux/smp.h         |    1 -
>  3 files changed, 0 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/m32r/include/asm/smp.h b/arch/m32r/include/asm/smp.h
> index cf7829a..c689b82 100644
> --- a/arch/m32r/include/asm/smp.h
> +++ b/arch/m32r/include/asm/smp.h
> @@ -79,11 +79,6 @@ static __inline__ int cpu_number_map(int cpu)
>  	return cpu;
>  }
> 
> -static __inline__ unsigned int num_booting_cpus(void)
> -{
> -	return cpumask_weight(&cpu_callout_map);
> -}
> -
>  extern void smp_send_timer(void);
>  extern unsigned long send_IPI_mask_phys(const cpumask_t*, int, int);
> 
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index f483945..2ffa95d 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -169,11 +169,6 @@ void x86_idle_thread_init(unsigned int cpu, struct task_struct *idle);
>  void smp_store_cpu_info(int id);
>  #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
> 
> -/* We don't mark CPUs online until __cpu_up(), so we need another measure */
> -static inline int num_booting_cpus(void)
> -{
> -	return cpumask_weight(cpu_callout_mask);
> -}
>  #else /* !CONFIG_SMP */
>  #define wbinvd_on_cpu(cpu)     wbinvd()
>  static inline int wbinvd_on_all_cpus(void)
> diff --git a/include/linux/smp.h b/include/linux/smp.h
> index a34d4f1..dd6f06b 100644
> --- a/include/linux/smp.h
> +++ b/include/linux/smp.h
> @@ -177,7 +177,6 @@ static inline int up_smp_call_function(smp_call_func_t func, void *info)
>  	} while (0)
> 
>  static inline void smp_send_reschedule(int cpu) { }
> -#define num_booting_cpus()			1
>  #define smp_prepare_boot_cpu()			do {} while (0)
>  #define smp_call_function_many(mask, func, info, wait) \
>  			(up_smp_call_function(func, info))
> 

