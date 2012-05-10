Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2EJBdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 21:33:07 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:43160 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab2EJBdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 21:33:03 -0400
Message-ID: <4FAB1AC9.1050306@gmail.com>
Date: Wed, 09 May 2012 21:32:57 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, anton@samba.org,
        Arnd Bergmann <arnd@arndb.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, kosaki.motohiro@gmail.com
Subject: Re: [PULL] cpumask: finally make them variable size w/ CPUMASK_OFFSTACK.
References: <87ipg5c2bk.fsf@rustcorp.com.au>
In-Reply-To: <87ipg5c2bk.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/9/12 2:10 AM), Rusty Russell wrote:
> Hi Ingo,
>
>          I finally rebased this on top of your tip tree, and tested it
> locally.  Some more old-style cpumask usages have crept in, but it's a
> fairly simple series.
>
> The final result is that if you enable CONFIG_CPUMASK_OFFSTACK, then
> 'struct cpumask' becomes an undefined type.  You can't accidentally take
> the size of it, assign it, or pass it by value.  And thus it's safe for
> us to make it smaller if nr_cpu_ids<  NR_CPUS, as the final patch does.
>
> It unfortunately requires the lglock cleanup patch, which Al already has
> queued, so I've included it here.

Hi

Thanks this effort. This is very cleaner than I expected.
However I should NAK following one patch. sorry. because of, lru-drain is
called from memory reclaim context. It mean, additional allocation may not
work. Please just use bare NR_CPUS bitmap instead. space wasting is minor
issue than that.

> commit fab26054c0500d426cf1bc2ce227a6a428dc815e
> Author: Rusty Russell<rusty@rustcorp.com.au>
> Date:   Wed May 9 14:55:15 2012 +0930
>
>      page_alloc: use cpumask_var_t.
>
>      The BSS trick works, but it still wastes space.  Especially since there's
>      a nice fallback in the case where we fail to allocate a temporary cpumask.
>
>      Signed-off-by: Rusty Russell<rusty@rustcorp.com.au>



Other patches looks very goold.
	Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Thanks.

