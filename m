Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945940Ab2JSQkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:40:53 -0400
Received: from mail.x86-64.org ([217.9.48.20]:37056 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964795Ab2JSQkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:40:49 -0400
Date: Fri, 19 Oct 2012 18:40:45 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: stable@vger.kernel.org, tony.luck@intel.com, bp@amd64.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        miaox@cn.fujitsu.com, laijs@cn.fujitsu.com, wency@cn.fujitsu.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 1/2] Replace if statement with WARN_ON_ONCE() in
 cmci_rediscover().
Message-ID: <20121019164045.GE11958@aftab.osrc.amd.com>
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com>
 <1350625528-1385-2-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350625528-1385-2-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 01:45:27PM +0800, Tang Chen wrote:
> cmci_rediscover() is only called by the CPU_POST_DEAD event handler,
> which means the corresponding cpu has already dead. As a result, it
> won't be accessed in the for_each_online_cpu loop.
> So, we could change the if(cpu == dying) statement into a WARN_ON_ONCE().
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce_intel.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> index 38e49bc..481d152 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> @@ -180,8 +180,8 @@ void cmci_rediscover(int dying)
>  	cpumask_copy(old, &current->cpus_allowed);
>  
>  	for_each_online_cpu(cpu) {
> -		if (cpu == dying)
> -			continue;
> +		WARN_ON_ONCE(cpu == dying);

Ok, I don't understand that:

we want to warn that the rediscovering is happening on a dying cpu?? And
before that, we simply jumped over it and didn't do the rediscovering
there? Why should we warn at all?

Huh?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
