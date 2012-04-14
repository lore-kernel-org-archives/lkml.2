Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab2DNVSz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 17:18:55 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:33999 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab2DNVSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 17:18:54 -0400
Message-ID: <4F89E9A3.3020800@linux.vnet.ibm.com>
Date: Sun, 15 Apr 2012 02:48:27 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/3] Extend type checking macros
References: <1334441685-4438-1-git-send-email-levinsasha928@gmail.com>
In-Reply-To: <1334441685-4438-1-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12041421-5564-0000-0000-000002346A33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2012 03:44 AM, Sasha Levin wrote:

> Commit e3831ed ("sched: Fix incorrect usage of for_each_cpu_mask() in
> select_fallback_rq()") fixes a very non obvious bug in select_fallback_rq()
> which was caused by passing 'struct cpumask' instead of 'struct cpumask *'
> to a macro in include/linux/cpumask.h
> 


Good heavens! I just found out that *each* *and* *every* *one* of the
existing 12 users of for_each_cpu_mask() are wrong!! Unbelievable!

> This bug was quite a pain to debug since it doesn't raise any warnings or
> erros during compilation, and the assumption of the kernel hackers who try
> to fix a bug is that if the compiler didn't complain, they passed the right
> types to functions.
> 
> This series of patches adds some more type checking macros to the forgotten
> include/linux/typecheck.h, it modified for_each_cpu_mask() to use those
> macros to trigger a warning when needed (this is a nice demonstration of how
> the bug mentioned before would have been visible with these checks), and
> modifies min()/max() and friend to use these macros as well to show their
> value in reducing duplicate code and improving readability.
> 
> Sasha Levin (3):
>   typecheck: extend typecheck.h with more useful typechecking macros
>   sched: add type checks to for_each_cpu_mask()


I think it would be better to correct and move the existing 12 users of
for_each_cpu_mask() to for_each_cpu() and simply get rid of the obsolete
for_each_cpu_mask() macro. After all, why do we need 2 macros that do the
exact same thing?

>   kernel.h: use new typechecking macros in min()/max() and friends
> 
>  include/linux/cpumask.h   |    4 ++-
>  include/linux/kernel.h    |   47 ++++++++++++++------------------------------
>  include/linux/typecheck.h |   42 ++++++++++++++++++++++++++++++++-------
>  3 files changed, 52 insertions(+), 41 deletions(-)
> 


Regards,
Srivatsa S. Bhat

