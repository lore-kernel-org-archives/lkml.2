Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab2EIIpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:45:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55602 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab2EIIpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:45:03 -0400
Date: Wed, 9 May 2012 10:44:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, anton@samba.org,
        Arnd Bergmann <arnd@arndb.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PULL] cpumask: finally make them variable size w/
 CPUMASK_OFFSTACK.
Message-ID: <20120509084453.GA6429@gmail.com>
References: <87ipg5c2bk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ipg5c2bk.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Hi Ingo,
> 
>         I finally rebased this on top of your tip tree, and tested it
> locally.  Some more old-style cpumask usages have crept in, but it's a
> fairly simple series.

Cool! Most of it looks pretty sane. I have a question about the 
gist of the series:

> commit 898eb73305e2277be91b931c5a75484f8c87ae36
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Wed May 9 15:01:15 2012 +0930
> 
>     cpumask: remove struct cpumask definition when CONFIG_CPUMASK_OFFSTACK=y
>     
>     We're about to change CONFIG_CPUMASK_OFFSTACK so it only allocate
>     nr_cpu_ids bits for all cpumasks.  We need to make sure that when
>     CONFIG_CPUMASK_OFFSTACK is set:
>     
>     1) Noone uses the old bitmap ops, which use NR_CPUS bits (use cpumask_*)
>     2) Noone uses assignment of struct cpumask (use cpumask_copy)
>     3) Noone passes a struct cpumask (pass a pointer)
>     4) Noone declares them on the stack (use cpumask_var_t)
>     
>     So we finally remove the definition of struct cpumask when
>     CONFIG_CPUMASK_OFFSTACK=y.  This means that these usages will hit a compile
>     error the moment that config option is turned on.
>     
>     Note that it also means you can't declare a static cpumask.  You
>     should avoid this anyway (use cpumask_var_t), but there's a
>     deliberately-ugly workaround for special cases, using DECLARE_BITMAP()
>     and to_cpumask().
>     
>     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>     Cc: Arnd Bergmann <arnd@arndb.de>
>     Cc: anton@samba.org
>     Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>     Cc: Mike Travis <travis@sgi.com>

Is there any good reason to not remove it altogether, regardless 
of whether the OFFSTACK config is set? I mean, triggering build 
failures for a relatively rarely turned on config option is 
asking for constant maintenance trouble.

Thanks,

	Ingo
