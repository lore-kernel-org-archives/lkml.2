Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280Ab2EDVSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:18:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53579 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759927Ab2EDVSO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:18:14 -0400
Message-ID: <1336166273.6509.79.camel@twins>
Subject: Re: [PATCH] sched: Enable arch-specific asym packing option in
 sched domain
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Diwakar Tundlam <dtundlam@nvidia.com>
Cc: "'Ingo Molnar'" <mingo@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Christoph Lameter'" <cl@gentwo.org>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Michael Neuling <mikey@neuling.org>
Date: Fri, 04 May 2012 23:17:53 +0200
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF0FF@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF0FF@HQMAIL04.nvidia.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 13:28 -0700, Diwakar Tundlam wrote:
> Add arch specific (weak) routine to set (or not set) the ASYM_PACKING
> sched domain flag. This change itself does nothing, but allows archs
> that require asym-packing option to set it by implementing the arch
> specific routine to turn it on.
>     
> The weak symbol is already defined in sched_fair.c but was mis-spelled
> in the header file. Fixed spelling error in the weak symbol definition.
>     
> Change-Id: Ibdf38e0a40f76ee3c1829f08b5feedcf900a1b89

This does not go in a patch..

> Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
> ---
>  include/linux/sched.h    |    2 +-
>  include/linux/topology.h |    1 +
>  2 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index c569719..cf793f0 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -903,7 +903,7 @@ static inline int sd_balance_for_package_power(void)
>         return SD_PREFER_SIBLING;
>  }
>  
> -extern int __weak arch_sd_sibiling_asym_packing(void);
> +extern int __weak arch_sd_sibling_asym_packing(void);
>  
>  /*
>   * Optimise SD flags for power savings:
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index b480403..eb09cd4 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -168,6 +168,7 @@ int arch_update_cpu_topology(void);
>                                 | 0*SD_SHARE_CPUPOWER                   \
>                                 | 0*SD_SHARE_PKG_RESOURCES              \
>                                 | 0*SD_SERIALIZE                        \
> +                               | arch_sd_sibling_asym_packing()        \
>                                 | sd_balance_for_package_power()        \
>                                 | sd_power_saving_flags()               \
>                                 ,                                       \


I think you just wrecked Power7 here..

(also your patch seems white-space challenged)
