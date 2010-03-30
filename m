Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0C3DgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 23:36:20 -0400
Received: from mail.openrapids.net ([64.15.138.104]:52115 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751666Ab0C3DgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 23:36:18 -0400
Date: Mon, 29 Mar 2010 23:36:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, stable <stable@kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] modules fix incorrect percpu usage
Message-ID: <20100330033617.GE7683@Krystal>
References: <20100330033211.GC7683@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100330033211.GC7683@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 23:34:33 up 66 days,  6:11,  4 users,  load average: 0.09, 0.12,
	0.04
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is needed
> for per cpu pointers).
> 
> Introduced by commit:
> 
> module.c: commit 6b588c18f8dacfa6d7957c33c5ff832096e752d3
> 
> This patch should be queued for the stable branch, for kernels 2.6.29.x to
> 2.6.33.x.
> (tested on 2.6.33.1 x86_64)

It's actually needed for mainline too (2.6.34-rc2).

Thanks,

Mathieu

> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Randy Dunlap <randy.dunlap@oracle.com>
> CC: Eric Dumazet <dada1@cosmosbay.com>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Tejun Heo <tj@kernel.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: stable <stable@kernel.org>
> ---
>  kernel/module.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/kernel/module.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/module.c	2010-03-29 23:47:05.000000000 -0400
> +++ linux-2.6-lttng/kernel/module.c	2010-03-29 23:47:27.000000000 -0400
> @@ -412,7 +412,7 @@ static void percpu_modcopy(void *pcpudes
>  	int cpu;
>  
>  	for_each_possible_cpu(cpu)
> -		memcpy(pcpudest + per_cpu_offset(cpu), from, size);
> +		memcpy(per_cpu_ptr(pcpudest, cpu), from, size);
>  }
>  
>  #else /* ... !CONFIG_SMP */
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
