Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab0D1RqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:46:06 -0400
Received: from mail.openrapids.net ([64.15.138.104]:53492 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755488Ab0D1RqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:46:02 -0400
Date: Wed, 28 Apr 2010 13:46:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Greg KH <gregkh@suse.de>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [169/197] modules: fix incorrect percpu usage
Message-ID: <20100428174600.GA4205@Krystal>
References: <20100422191857.GA13268@kroah.com> <20100422190922.517802235@kvm.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100422190922.517802235@kvm.kroah.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:45:17 up 95 days, 20:22,  7 users,  load average: 0.04, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (gregkh@suse.de) wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
> Mainline does not need this fix, as commit
> 259354deaaf03d49a02dbb9975d6ec2a54675672 fixed the problem by refactoring.
> 
> Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is needed
> for per cpu pointers).
> 
> Introduced by commit:
> 
> module.c: commit 6b588c18f8dacfa6d7957c33c5ff832096e752d3
> 
> This patch should be queued for the stable branch, for kernels 2.6.29.x to
> 2.6.33.x.  (tested on 2.6.33.1 x86_64)

Tejun, should this patch be applied to 2.6.32.x, or will it cause problems on
ia64 ?

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
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  kernel/module.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -555,7 +555,7 @@ static void percpu_modcopy(void *pcpudes
>  	int cpu;
>  
>  	for_each_possible_cpu(cpu)
> -		memcpy(pcpudest + per_cpu_offset(cpu), from, size);
> +		memcpy(per_cpu_ptr(pcpudest, cpu), from, size);
>  }
>  
>  #else /* ... !CONFIG_SMP */
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
