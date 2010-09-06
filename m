Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0IFPVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:21:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175Ab0IFPVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:21:01 -0400
Message-ID: <4C8506B5.1040808@redhat.com>
Date: Mon, 06 Sep 2010 18:20:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
References: <4C84B088.5050003@redhat.com>	<1283772256.1930.303.camel@laptop>	<4C84D1CE.3070205@redhat.com>	<1283774045.1930.341.camel@laptop>	<4C84D77B.6040600@redhat.com>	<20100906124330.GA22314@elte.hu>	<4C84E265.1020402@redhat.com>	<20100906125905.GA25414@elte.hu>	<4C850147.8010908@redhat.com> <20100906163041.3677fd66@lxorguk.ukuu.org.uk>
In-Reply-To: <20100906163041.3677fd66@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/06/2010 06:30 PM, Alan Cox wrote:
>
>> For me the requirements are:
>> - turing complete (more than just filters)
> Needs infinite storage and may not terminate

Ow come on.  We can always terminate it by inserting checks and 
unwinding the stack; and obviously we'll limit storage.

>> - easy interface to kernel APIs (like hrtimers)
>> - safe to use by untrusted users
>>
>> The actual language doesn't really matter.
> It does for performance and audit. You don't want a JIT as it murders
> cache performance,

Strangely, everyone uses a jit these days unless they're memory 
constrained.  Yes it costs cache, but an interpreter is still slower.

> which means you want
>
> - no self modification

Right.

> - bounded run time

No, I want the ability to terminate the code at any time and clean up 
any resources used.  We have exactly the same requirements for ordinary 
userspace.

> - bounded memory use
> - trustable behaviour for access

Right.

> and usually minimal side effects since you want to optimise very
> heavily and side effects stop that (which is also why Fortran still kicks
> C's backside for crunching)
>
> Not sure you need/want to do the conversion in kernel.

I prefer bytecode as well.

> I'd have thought a
> sane way to handle it would have been to throw stuff at the kernel in
> some kind of semi-sane byte code that can be interpreted by a noddy
> interpreter but firstly when you get it have the kernel try and run a
> helper to compile it.

So you do want to jit?

-- 
error compiling committee.c: too many arguments to function

