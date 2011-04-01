Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473Ab1DARLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 13:11:41 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34854 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab1DARLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 13:11:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fbc3EV7KlruHUUnDQUBBdR3dERCVVSKyQCQ7vx50wnsM7pAKQAT4DIYrPoqFcR5P1R
         kNu2o1tgioR5B9owI899fvslweK4DE8Hnq1/qVGzr4guj5uratA+MPrYbuyJru8Kme40
         If0XPzw4h2oNH5zCNSam7hPCjbwL+TFQ/hQqs=
Message-ID: <4D96072E.4060902@gmail.com>
Date: Fri, 01 Apr 2011 11:11:10 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v3 3/6] perf branch trace: print pid and command
References: <20110324113137.20235.42265.stgit@localhost6.localdomain6> <20110324113209.20235.61900.stgit@localhost6.localdomain6> <4D8B79E6.2050603@gmail.com> <4D8C6B1B.70409@hitachi.com> <4D8CAE74.9080805@gmail.com> <4D906450.1040809@hitachi.com> <4D909BBB.5020500@gmail.com> <20110401151313.GC2335@nowhere>
In-Reply-To: <20110401151313.GC2335@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/01/11 09:13, Frederic Weisbecker wrote:
> On Mon, Mar 28, 2011 at 08:31:23AM -0600, David Ahern wrote:
>> On 03/28/11 04:34, Akihiro Nagai wrote:
>>>> from is sample->ip? to is sample->addr? In the above example
>>>> 0x39d3015260 is the value from sample->addr, 1526f is sample->ip which
>>>> resolves to _dl_next_ld_env_entry from /lib64/ld-2.13.so.
>>> Yes.
>>> In this example, resolved address is only sample->ip (branch from).
>>> We need the resolved address of sample->addr (branch to) too, because
>>> both of them are addresses of execution code.
>>
>> Ok, now I understand. In that case add conversion of sample->addr to
>> symbols to perf-script.
> 
> I agree that we should rather use perf script for branch dumps.
> Sorry Akihiro, I think we suggested you to create this dedicated
> perf branch by the past. But then perf script became the vanilla dump
> tool in the middle and it seems more suitable today.
> 
> We can still create a perf branch later in order to produce some more
> advanced post-processing tools. But for sample dumps perf script (which starts
> to show itself as a misnomer BTW) seems to be the right place.

perf-dump?

> 
> So, in this context, if we have PERF_SAMPLE_ADDR, we are going to always
> follow the ip with a "=>" and then resolve the address, etc...
> 
> Yeah it makes sense for this default mode. But what about when we'll want
> a function graph kind of output? This will require a totally different
> layout. Also PERF_SAMPLE_ADDR may be used for different context in the
> future.
> 
> Perhaps we want a kind of per evsel callback that makes its own
> interpretation of the pid/tid/dso/sym/etc... options asked by the
> user?

The print addr function can take the evsel as an input. It includes the
event type which can be used to decide what the address means.

> 
> But well, we can start simple and make and just do the => trick
> if we have PERF_SAMPLE_ADDR and resolve addr if the user asked
> the sym. Then when we have the graph output, have these per evsel
> display callbacks.

There is another email thread about page faults. The user wants sample
address resolved to symbols. I was going to look into it next week when
I get back from vacation.
