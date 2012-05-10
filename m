Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2EJGml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 02:42:41 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:39905 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab2EJGmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 02:42:40 -0400
Message-ID: <4FAB6363.4080808@gmail.com>
Date: Thu, 10 May 2012 02:42:43 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, anton@samba.org,
        Arnd Bergmann <arnd@arndb.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PULL] cpumask: finally make them variable size w/ CPUMASK_OFFSTACK.
References: <87ipg5c2bk.fsf@rustcorp.com.au> <4FAB1AC9.1050306@gmail.com> <871umsdbm0.fsf@rustcorp.com.au> <4FAB2B5B.4020902@gmail.com> <87vck4bppw.fsf@rustcorp.com.au>
In-Reply-To: <87vck4bppw.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/10/12 12:54 AM), Rusty Russell wrote:
> On Wed, 09 May 2012 22:43:39 -0400, KOSAKI Motohiro<kosaki.motohiro@gmail.com>  wrote:
>>> Or is there a reason we shouldn't even try to allocate here?
>>
>> 1) your code always use GFP_KERNEL. it is trouble maker when alloc_pages w/ GFP_ATOMIC.
>
> Oh :(
>
> How about the below instead?

This code still slow than original. when calling reclaim path, new allocation is almost always
fail. then, your code almost always invoke all cpu batch invalidation. i.e. many ipi.


>> 2) When CONFIG_CPUMASK_OFFSTACK=n and NR_CPUS is relatively large, cpumask on stack may
>> cause stack overflow. because of, alloc_pages() can be called from
>> very deep call stack.
>
> You can't have large NR_CPUS without CONFIG_CPUMASK_OFFSTACK=y,
> otherwise you'll get many other stack overflows, too.

Original code put cpumask bss instead stack then. :-)


