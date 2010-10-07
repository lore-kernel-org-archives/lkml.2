Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131Ab0JGHmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 03:42:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173Ab0JGHmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 03:42:22 -0400
Date: Thu, 7 Oct 2010 00:42:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Assign CPUs to nodes in round-robin manner on Fake
 NUMA.
Message-Id: <20101007004252.599b6888.akpm@linux-foundation.org>
In-Reply-To: <201009301734.10787.knikanth@suse.de>
References: <201009301734.10787.knikanth@suse.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010 17:34:10 +0530 Nikanth Karthikesan <knikanth@suse.de> wrote:

> Assign CPUs to nodes in round-robin manner on Fake NUMA.
> 
> commit d9c2d5ac6af87b4491bff107113aaf16f6c2b2d9
> "x86, numa: Use near(er) online node instead of roundrobin for NUMA"
> changed NUMA initialization on Intel to choose the nearest online node or
> first node. Fake NUMA would be better of with round-robin initialization,
> instead of the all CPUS on first node. Change the choice of first node, back
> to round-robin.
> 

Why would fake NUMA "be better off with round-robin initialization"?

> 
> ---
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 85f69cd..47dd171 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -283,9 +283,7 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
>  	/* Don't do the funky fallback heuristics the AMD version employs
>  	   for now. */
>  	node = apicid_to_node[apicid];
> -	if (node == NUMA_NO_NODE)
> -		node = first_node(node_online_map);
> -	else if (!node_online(node)) {
> +	if (node == NUMA_NO_NODE || !node_online(node)) {
>  		/* reuse the value from init_cpu_to_node() */
>  		node = cpu_to_node(cpu);
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
