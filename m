Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab1E3Ndy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:33:54 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:64599 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab1E3Ndx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:33:53 -0400
X-AuditID: b753bd60-a3cc8ba000003bac-6d-4de39c3bed4a
X-AuditID: b753bd60-a3cc8ba000003bac-6d-4de39c3bed4a
Message-ID: <4DE39C31.1070600@hitachi.com>
Date: Mon, 30 May 2011 22:31:29 +0900
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        pp-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH -tip v4 0/7] perf: Introduce branch sub commands
References: <20110526050246.30011.86048.stgit@localhost6.localdomain6> <20110526132833.GC21815@nowhere> <4DDE7EAD.7000603@gmail.com>
In-Reply-To: <4DDE7EAD.7000603@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/27 1:24), David Ahern wrote:
>
>
> On 05/26/2011 07:28 AM, Frederic Weisbecker wrote:
>> (Adding David Ahern in Cc)
>>
>> Ok that's all good except this needs to use the "perf script" centralized
>> dump.
>>
>> Currently running "perf script" without an actual script dumps
>> the events by default, whatever kind of event they are: hardware,
>> software, tracepoints, ...
>> So we want the branch output to be supported there, so we can reuse
>> some code and interface.
>>
>> For example, "perf script -f branch:comm,tid,sym" would print the
>> comm, tid and the sym for to and from addresses.
>>
>> That's better than creating a new set of options in a new command
>> that people need to relearn while everybody could simply get
>> familiarized with common perf script options.
>>
>> Of course we can still have a "perf branch" command, which could
>> be a tiny shortcut that maps to perf record and perf script.
>>
>> Like:
>>
>> 	perf branch record
>> 	perf branch [trace] -f tid,sym,comm
>>
>> Would map to:
>>
>> 	perf record branch:u
>> 	perf script -f branch:tid,sym,comm
>>
>> And may be if one day we can do something more tricky than a
>> linear output for branches (like source code coloring/browsing),
>> then it may be implemented inside perf branch and not rely on
>> another subcommand. Until then we are only dealing with raw linear
>> dump, and that's a core job for perf script where we want to
>> centralize that kind of facility.
>
> I mentioned that when v3 was posted.
>
> The sample address can be converted to symbols and the output can be
> added to perf-script rather easily. Attached is an example. I was going
> to submit it back in April and got distracted. I'll rebase, move the
> addr->sym conversion to a function and submit later today.
OK.
I agreed with implementing it on perf script.
I'd like to try it.

Thank you.

>
> David
>
>>
>> Thanks.
>>
