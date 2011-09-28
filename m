Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab1I1NxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:53:10 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:39803 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab1I1NxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:53:08 -0400
Message-ID: <4E8326BE.5010006@gmail.com>
Date: Wed, 28 Sep 2011 17:53:02 +0400
From: Andrew Vagin <avagin@gmail.com>
Reply-To: avagin@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Vagin <avagin@openvz.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 3/4] trace: add ability to collect call chain of non-current
 task.
References: <1317052535-1765247-1-git-send-email-avagin@openvz.org> <1317052535-1765247-4-git-send-email-avagin@openvz.org> <1317132351.15383.66.camel@twins> <20110927205548.GN18553@somewhere>
In-Reply-To: <20110927205548.GN18553@somewhere>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 12:55 AM, Frederic Weisbecker wrote:
> On Tue, Sep 27, 2011 at 04:05:51PM +0200, Peter Zijlstra wrote:
>> On Mon, 2011-09-26 at 19:55 +0400, Andrew Vagin wrote:
>>> Know issues:
>>> * Now call chains for non-current tasks are collected on x86 only,
>>>    but it may be done for other architectures simply.
>>> * It collects only kernel call chains, because we can't get direct
>>>    access to memory of other processes and this operation should be
>>>    fast enough.
>> Also, it changes the semantics of tracepoint, normally you return the
>> callchain leading to the tracepoint, this changes that.
>>
>>
>> I'm not entirely against it, as I can see the use, but I would like to
>> solicit other opinions.
> There is also a problem in perf tools because we are dealing with a
> callchain that doesn't belong to the current thread memory mapping and symbol
> space. I believe that's a problem once we deal with the userspace part of
> the callchain.
>
> That and the fact there are other ways to get that callchain like taking
> the one of the last sched_switch event from the waked thread.
>
> Perhaps we should use the sched_switch event and a post_sched_switch
> event, compute the time difference as a weight and use the callchain of any of
> those. Perhaps as a plugin in perf report?
>
> In any case that rather sounds like something that should be done in post-processing
> in userspace, in perf tools.
>
> We should probably avoid the remote callchains, sounds like asking for complications
> everywhere.
Thank you for comments and suggestions. I take timeout to think over them.
