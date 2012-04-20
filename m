Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab2DTWdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:33:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab2DTWdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:33:53 -0400
Date: Fri, 20 Apr 2012 15:33:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, peterz@infradead.org, mingo@elte.hu,
        hpa@zytor.com, tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] sched: add type checks to for_each_cpu_mask()
Message-Id: <20120420153351.53085ed9.akpm@linux-foundation.org>
In-Reply-To: <1334441685-4438-3-git-send-email-levinsasha928@gmail.com>
References: <1334441685-4438-1-git-send-email-levinsasha928@gmail.com>
	<1334441685-4438-3-git-send-email-levinsasha928@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Apr 2012 18:14:44 -0400
Sasha Levin <levinsasha928@gmail.com> wrote:

> Add type checks to assert that 'mask' is 'struct cpumask *'. This check
> would have detected the bug fixed in e3831ed ("sched: Fix incorrect usage
> of for_each_cpu_mask() in select_fallback_rq()"):
> 
> kernel/sched/core.c: In function 'select_fallback_rq':
> kernel/sched/core.c:1273:2: warning: comparison of distinct pointer types lacks a cast
> kernel/sched/core.c:1284:3: warning: comparison of distinct pointer types lacks a cast
> 
> ...
>
> @@ -809,6 +810,7 @@ int __next_cpu(int n, const cpumask_t *srcp);
>  #define next_cpu(n, src)	__next_cpu((n), &(src))
>  #define any_online_cpu(mask) cpumask_any_and(&mask, cpu_online_mask)
>  #define for_each_cpu_mask(cpu, mask)			\
> +	typecheck(struct cpumask *, (mask));		\
>  	for ((cpu) = -1;				\
>  		(cpu) = next_cpu((cpu), (mask)),	\
>  		(cpu) < NR_CPUS; )

and int __next_cpu(int n, const cpumask_t *srcp);

I'm mystified.  Why didn't the next_cpu() call generate a warning when
passed the wrong type?
