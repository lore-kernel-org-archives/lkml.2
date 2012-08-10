Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab2HJJjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 05:39:52 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:21890
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758271Ab2HJJjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 05:39:51 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202hzz8275bhz2dh2a8h668h839h944hd25hf0ah107ah)
Date: Fri, 10 Aug 2012 17:41:41 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <galak@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH 3/4] cpu: export cpu hotplug disable/enable functions as
 global functions
Message-ID: <20120810094141.GA17891@localhost.localdomain>
References: <1344329006-10645-1-git-send-email-chenhui.zhao@freescale.com>
 <1344329006-10645-3-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1344329006-10645-3-git-send-email-chenhui.zhao@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 04:43:25PM +0800, Zhao Chenhui wrote:
> The cpufreq driver of mpc85xx will disable/enable cpu hotplug temporarily.
> Therefore, the related functions should be exported.
> 
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> ---
>  include/linux/cpu.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> index ce7a074..df8f73d 100644
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -146,6 +146,8 @@ void notify_cpu_starting(unsigned int cpu);
>  extern void cpu_maps_update_begin(void);
>  extern void cpu_maps_update_done(void);
>  
> +extern void cpu_hotplug_disable_before_freeze(void);
> +extern void cpu_hotplug_enable_after_thaw(void);
>  #else	/* CONFIG_SMP */
>  
>  #define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
> @@ -167,6 +169,8 @@ static inline void cpu_maps_update_done(void)
>  {
>  }
>  
> +static inline void cpu_hotplug_disable_before_freeze(void)	{}
> +static inline void cpu_hotplug_enable_after_thaw(void)	{}
>  #endif /* CONFIG_SMP */
>  extern struct bus_type cpu_subsys;
>  
> -- 
> 1.6.4.1
> 

Hi kumar,

I will not use these API in the 4/4 patch. please ignore this patch.

-Chenhui

