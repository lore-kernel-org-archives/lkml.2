Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab1LASLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:11:07 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40839 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab1LASLG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:11:06 -0500
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <alpine.DEB.2.00.1112010853430.31445@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1111300011260.7107@cl320.eecs.utk.edu>
	<1322654092.2921.256.camel@twins>
	<CA+55aFwyYdN7HOkP0xanUOWd12zZhdqHCjnsWtdrs5LOxjg+Gg@mail.gmail.com>
	<alpine.DEB.2.00.1112010853430.31445@cl320.eecs.utk.edu>
Date: Thu, 1 Dec 2011 10:11:05 -0800
Message-ID: <CAMsRxfJmXXxDrofY3PDOLWRC7E-o6mANiTSJwYbyMTgOT_J0UA@mail.gmail.com>
Subject: Re: perf_event self-monitoring overhead regression
From: stephane eranian <eranian@googlemail.com>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince,

I take it your test is all about self-monitoring, single event, single thread.
Did you try breaking down the cost using  TSC and rdtsc() to pinpoint where the
regression is coming from in the 3 perf_event syscalls you're using?


On Thu, Dec 1, 2011 at 5:59 AM, Vince Weaver <vweaver1@eecs.utk.edu> wrote:
> On Wed, 30 Nov 2011, Linus Torvalds wrote:
>
>> On Wed, Nov 30, 2011 at 3:54 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>
>> So bisect works really well for clear bugs that are 100% repeatable
>> and have a very clear "did it happen or not" signature, but I'd be
>> very leery indeed of using it with some performance anomaly.
>
> In this case, the bisection case is pretty clean.  I run 1000 of the tests
> and check the median value, and the values are always 7280us for good and
> 7440us for bad.
>
> The problem is when it starts bisecting into the merges it drops from a
> post-3.0 kernel into a much earlier 3.0-rc kernel (due to the ARM merge
> history) and suddenly then the test becomes meaningless as it starts
> returning other values such as 6880us.  This is because the problem I am
> tracking has ben gradually getting worse over time, and so I guess by
> going back to a 3.0-rc it gets earlier than some other change that made
> performance worse, and thus it becomes impossible to know if a commit is
> good or not.
>
>> That said, maybe you can get the timings to be unambiguous enough by
>> using 'rdtsc' in user space, and try the bisect again.
>
> I'll try but I'm guessing your first thought that this might be
> un-bisectabe is probably true.
>
> Thanks,
>
> Vince
>
