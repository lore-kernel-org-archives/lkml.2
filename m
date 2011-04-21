Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1DUTn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:43:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:14332 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1DUTn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:43:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=FfhyZhnHkajJ9rOWyYMIugj/JRVoaOErpdy6rJ0rirmYahhQRIEUKDdmMjsZa/EFxO
         NZVJsgwQNGvnRG3h+xmA==
Date: Thu, 21 Apr 2011 12:43:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        x86@kernel.org
Subject: Re: [patch 2/2] x86, numa: Fix cpu nodemasks for NUMA emulation and
 CONFIG_DEBUG_PER_CPU_MAPS
In-Reply-To: <20110421144621.7339.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1104211241280.5829@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104201918110.12634@chino.kir.corp.google.com> <alpine.DEB.2.00.1104201918470.12634@chino.kir.corp.google.com> <20110421144621.7339.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011, KOSAKI Motohiro wrote:

> From aaca24826696f7911bd66380baa18cfbe4f4b18e Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Thu, 21 Apr 2011 14:01:42 +0900
> Subject: [PATCH] Fix
> 
> debug_cpumask_set_cpu() has tree return statement. we have change
> rest two return statement.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  arch/x86/mm/numa.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index 0471b1d6..745258d 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -220,7 +220,7 @@ void debug_cpumask_set_cpu(int cpu, int node, bool enable)
>  
>  	if (node == NUMA_NO_NODE) {
>  		/* early_cpu_to_node() already emits a warning and trace */
> -		return NULL;
> +		return;
>  	}
>  	mask = node_to_cpumask_map[node];
>  	if (!mask) {
> @@ -238,7 +238,7 @@ void debug_cpumask_set_cpu(int cpu, int node, bool enable)
>  	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
>  		enable ? "numa_add_cpu" : "numa_remove_cpu",
>  		cpu, node, buf);
> -	return mask;
> +	return;
>  }
>  
>  # ifndef CONFIG_NUMA_EMU

Yes, it looks like Ingo fixed that up when it was merged in the latest 
git as 7a6c6547825a, thanks for pointing it out.
