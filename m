Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab2DQKKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 06:10:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57484 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab2DQKKC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 06:10:02 -0400
Message-ID: <1334657383.28150.78.camel@twins>
Subject: Re: A quick view of the performance benchmark for semaphore-like
 and mutex
From: Peter Zijlstra <peterz@infradead.org>
To: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Tue, 17 Apr 2012 12:09:43 +0200
In-Reply-To: <491D6B4EAD0A714894D8AD22F4BDE043B15DCF@SCYBEXDAG03.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE043B15DCF@SCYBEXDAG03.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-17 at 09:36 +0000, Chen, Dennis (SRDC SW) wrote:
> Just as a quick & rough test, with below changes based on mutex (almost the same as semaphore):
> 
> --- /home/dennis/Linux/linux-3.3.2-sem/kernel/mutex.c   2012-04-17 14:59:49.823177615 +0800
> +++ ./mutex.c   2012-04-17 17:00:12.963059284 +0800
> @@ -140,6 +140,7 @@ __mutex_lock_common(struct mutex *lock,
>         preempt_disable();
>         mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
>  
> +#if 0
>  #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
>         /*
>          * Optimistic spinning.
> @@ -195,6 +196,7 @@ __mutex_lock_common(struct mutex *lock,
>                 arch_mutex_cpu_relax();
>         }
>  #endif
> +#endif
>         spin_lock_mutex(&lock->wait_lock, flags);
>  
>         debug_mutex_lock_common(lock, &waiter);


or you do:

echo NO_OWNER_SPIN > /debug/sched_features


