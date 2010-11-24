Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab0KXAor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:44:47 -0500
Received: from mail.openrapids.net ([64.15.138.104]:33413 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754840Ab0KXAop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:44:45 -0500
Date: Tue, 23 Nov 2010 19:44:41 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thiscpuops upgrade 09/10] x86: this_cpu_cmpxchg and
	this_cpu_cmpxchg_double operations
Message-ID: <20101124004441.GA8264@Krystal>
References: <20101123235139.908255844@linux.com> <20101123235201.146063796@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101123235201.146063796@linux.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 19:43:33 up  5:46,  1 user,  load average: 0.03, 0.02, 0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> Provide support as far as the hardware capabilities of the x86 cpus
> allow.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 

[...]
> +#define percpu_cmpxchg16b(pcp, o1, o2, n1, n2)				\
> +({									\
> +	char __ret;							\
> +	typeof(o1) __o1 = o1;						\
> +	typeof(o1) __n1 = n1;						\
> +	typeof(o2) __o2 = o2;						\
> +	typeof(o2) __n2 = n2;						\
> +	asm("cmpxchg16b "__percpu_arg(1)"\n\tsetz %0\n\t"		\
> +		    : "=a"(__ret), "=m" (*pcp)				\
> +		    :  "b"(__n1), "c"(__n2), "a"(__o1), "d"(__o2));	\
> +	__ret;								\
> +})

Can we add a check to ensure that the target memory location is 16-byte aligned?
This is a documented limitation of cmpxchg16b.

Thanks,

Mathieu

> +
> +#define __this_cpu_cmpxchg_double_8(pcp, o1, o2, n1, n2) percpu_cmpxchg16b((pcp), o1, o2, n1, n2)
> +#define this_cpu_cmpxchg_double_8(pcp, o1, o2, n1, n2)	percpu_cmpxchg16b((pcp), o1, o2, n1, n2)
> +#define irqsafe_cmpxchg_double_8(pcp, o1, o2, n1, n2)	percpu_cmpxchg16b((pcp), o1, o2, n1, n2)
> +
>  #endif
>  
>  /* This is not atomic against other CPUs -- CPU preemption needs to be off */
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
