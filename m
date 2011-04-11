Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab1DKEyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 00:54:32 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43684 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab1DKEyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 00:54:31 -0400
X-AuditID: b753bd60-9e1fcba000000f4e-9d-4da28984a7cc
X-AuditID: b753bd60-9e1fcba000000f4e-9d-4da28984a7cc
Message-ID: <4DA2897B.3030404@hitachi.com>
Date: Mon, 11 Apr 2011 13:54:19 +0900
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        pp-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v3 3/6] perf branch trace: print pid and command
References: <20110324113137.20235.42265.stgit@localhost6.localdomain6> <20110324113209.20235.61900.stgit@localhost6.localdomain6> <4D8B79E6.2050603@gmail.com> <4D8C6B1B.70409@hitachi.com> <4D8CAE74.9080805@gmail.com> <4D906450.1040809@hitachi.com> <4D909BBB.5020500@gmail.com> <20110401151313.GC2335@nowhere> <4D9996C8.4020703@hitachi.com> <20110406125226.GB1867@nowhere>
In-Reply-To: <20110406125226.GB1867@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/04/06 21:52), Frederic Weisbecker wrote:
> On Mon, Apr 04, 2011 at 07:00:40PM +0900, Akihiro Nagai wrote:
>> (2011/04/02 0:13), Frederic Weisbecker wrote:
>>> On Mon, Mar 28, 2011 at 08:31:23AM -0600, David Ahern wrote:
>>>> On 03/28/11 04:34, Akihiro Nagai wrote:
>>>>> >from is sample->ip? to is sample->addr? In the above example
>>>>>> 0x39d3015260 is the value from sample->addr, 1526f is sample->ip which
>>>>>> resolves to _dl_next_ld_env_entry from /lib64/ld-2.13.so.
>>>>> Yes.
>>>>> In this example, resolved address is only sample->ip (branch from).
>>>>> We need the resolved address of sample->addr (branch to) too, because
>>>>> both of them are addresses of execution code.
>>>>
>>>> Ok, now I understand. In that case add conversion of sample->addr to
>>>> symbols to perf-script.
>>>
>>> I agree that we should rather use perf script for branch dumps.
>>> Sorry Akihiro, I think we suggested you to create this dedicated
>>> perf branch by the past. But then perf script became the vanilla dump
>>> tool in the middle and it seems more suitable today.
>>>
>>> We can still create a perf branch later in order to produce some more
>>> advanced post-processing tools. But for sample dumps perf script (which starts
>>> to show itself as a misnomer BTW) seems to be the right place.
>> Finally, I would like to create coverage test tools using BTS on perf.
>> I'm working on the project "Btrax" that is a coverage test tool using BTS.
>> The URL is: http://sourceforge.net/projects/btrax/
>
> Cool, what is this tool doing? How is it different from perf branch?
Btrax provides following functions by analyzing BTS logs.
  1. Show executed/unexecuted codes with colors in HTML.
  2. Calculate the ratio of executed codes and all codes of tracee programs.

Finally, I would like to add similar functions to Btrax to perf branch.
Because,
  1. I think the combination of BTS and other perf functions realizes
     cool stuff.
  2. Currently, Btrax is out of tree. So, some people cannot use it
     because of unsupported kernel versions. I want many people to use it.

>
>>
>> And, I would like to implement other functions on perf-branch too.
>> For example, call graph, source code browser like perf-annotate which
>> can show executed codes.
>> So, I wolud like to continue to develop perf-branch.
>
> And you're very welcome to do so. Such features have a nice potential
> I think.
Thank you. I believe it too.

>
> Thanks.

