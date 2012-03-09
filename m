Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269Ab2CIBxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 20:53:42 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49466 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab2CIBxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 20:53:40 -0500
X-AuditID: 9c930197-b7bd0ae000002080-a6-4f5962a1251e
Message-ID: <4F59629E.6090909@lge.com>
Date: Fri, 09 Mar 2012 10:53:34 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Ingo Molnar <mingo@elte.hu>
CC: Namhyung Kim <namhyung@gmail.com>, Arun Sharma <asharma@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        robert.richter@amd.com, ming.m.lin@intel.com, vweaver1@eecs.utk.edu,
        andi@firstfloor.org
Subject: Re: [RFC] perf report: Implement symbol filtering on TUI
References: <20120306062546.GA622@elte.hu> <1331085470-32594-1-git-send-email-namhyung.kim@lge.com> <20120307060724.GA4241@elte.hu> <4F5716A2.6070804@lge.com> <20120308104432.GB25949@elte.hu>
In-Reply-To: <20120308104432.GB25949@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-03-08 7:44 PM, Ingo Molnar wrote:
>
> * Namhyung Kim <namhyung.kim@lge.com>  wrote:
>
>> Hi, Ingo
>>
>> 2012-03-07 3:07 PM, Ingo Molnar wrote:
>>>
>>> * Namhyung Kim <namhyung.kim@lge.com>   wrote:
>>>
>>>> As Ingo requested, symbol filtering feature was missing on TUI.
>>>> Add 's' key to get input from user, and do simple filtering by
>>>> strstr(). To turn filtering off, just enter no name by pressing
>>>> 's' followed by ENTER.
>>>>
>>>> There should be many issues, but I just want to release this
>>>> to get some feedbacks.
>>>
>>> I'd love it if in addition to the hotkey, if I typed the obvious
>>> sequence:
>>>
>>>   $ perf report sched
>>>
>>> ... then it would turn into such a filter automagically.
>>>
>>
>> Oh, I implemented that already. Please test it! :)
>
> Cool - I tried it out and it works just as it should!
>
> I noticed two details:
>
>   - "perf report sched | less" does not work as expected - such
>     kinds of features should be GUI-frontend agnostic.
>

Will fix.


>   - unknown symbols are not matched, and thus they will show up
>     indiscrimnately even though I only want to see them if the
>    filter is something like '0x' or 'unknown'.
>

Since they have no symbol. :) In the current implementation, it will
actually show you such symbols if you enter '0x' or 'unknown' as a filter 
unless there're symbols that have those letters in its name.

I can think of 3 solutions for this now:

1. Adding a special filter keyword (like 'unknown'). But there's probably some 
symbols which have those letters.

2. If filter string consists of (hex-) digits only, it will only show hist 
entries doesn't have symbols, or tries to match based on its ip.

3. Implement zooming-in to "unknown" dso. Maybe it's a different issue, but I 
think it's good to have and it'll helps this too.

What do you guys think?


> Anyway, apart from these two details:
>
>   Tested-by: Ingo Molnar <mingo@elte.hu>
>

Thanks for testing and suggestions.
Namhyung


