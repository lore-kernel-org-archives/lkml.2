Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab2FXQIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 12:08:32 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42954 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2FXQIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 12:08:31 -0400
MIME-Version: 1.0
In-Reply-To: <4FD8C51C.4060404@linux.intel.com>
References: <1337268092-6765-1-git-send-email-h.mitake@gmail.com>
	<4FB52636.3040604@linux.intel.com>
	<CAMO-S2g9fkg_KH0CPOsB_7GQTN2mu8zir+UZDp6=VC+7XDrfrg@mail.gmail.com>
	<CAMO-S2gyzK3VTQcTRw+FAO9ui_gy=1z=MVxUYM9sPN51KrDgkg@mail.gmail.com>
	<4FCE4D24.5040307@linux.intel.com>
	<20120606073909.GI17808@gmail.com>
	<CAMO-S2j_3tT3WEYiiSo1MWwRctMhKdaNOSTRUx+2Vpvp+eYCHQ@mail.gmail.com>
	<CAMO-S2j1GkBDFv3qXVcXrDk_D8jkVc3nCYe7+KQU3qpinLf5wQ@mail.gmail.com>
	<4FD8C51C.4060404@linux.intel.com>
Date: Mon, 25 Jun 2012 01:08:30 +0900
Message-ID: <CAMO-S2g1mYSfxSEbc8oOctbnxxgd-Yv4J-XKtNdpqKyfxYHE5w@mail.gmail.com>
Subject: Re: [PATCH] perf bench: add new benchmark subsystem and suite "futex wait"
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Michel Lespinasse <walken@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 1:51 AM, Darren Hart <dvhart@linux.intel.com> wrote:
>
>
> On 06/07/2012 08:11 AM, Hitoshi Mitake wrote:
>> On Thu, Jun 7, 2012 at 1:02 AM, Hitoshi Mitake <h.mitake@gmail.com> wrote:
>>> On Wed, Jun 6, 2012 at 4:39 PM, Ingo Molnar <mingo@kernel.org> wrote:
>>>>
>>>> * Darren Hart <dvhart@linux.intel.com> wrote:
>>>>
>>>>> On 05/20/2012 02:37 AM, Hitoshi Mitake wrote:
>>>>>> On Sun, May 20, 2012 at 5:32 PM, Hitoshi Mitake <h.mitake@gmail.com> wrote:
>>>>>>> On Fri, May 18, 2012 at 1:24 AM, Darren Hart <dvhart@linux.intel.com> wrote:
>>>>>>>> On 05/17/2012 08:21 AM, Hitoshi Mitake wrote:
>>>>>>>>> Hi Ingo, Eric and Darren,
>>>>>>>>> (CCed perf and futex folks)
>>>>>>>>>
>>>>>>>>> I wrote this patch for adding new subsystem "futex" and its suite "wait" to perf
>>>>>>>>> bench on tip/master. This is based on futextest by Darren Hart.
>>>>>>>>>
>>>>>>>>> Could you allow me to import your source code of futextest to perf bench, Darren?
>>>>>>>>>
>>>>>>>>
>>>>>>>> I do have some concerns I'd like to address first.
>>>>>>>>
>>>>>>>> What is advantage of incorporating this into perf as opposed to running
>>>>>>>> it with perf?
>>>>>>>
>>>>>>> The main and direct advantage is that perf bench can share useful
>>>>>>> utilities stored under tools/perf/util/ directory e.g. parse-options[ch].
>>>>>>>
>>>>>>
>>>>>> BTW, I often feel parse-options.[ch] of perf (this was come from git,
>>>>>> right?) is very useful not only for perf and git but also other
>>>>>> projects. So I think these stuff are worth independence as a
>>>>>> library. If the library contains unified feature for parsing and
>>>>>> evaluating configuration files, the hell of managing configurable
>>>>>> options will be reduced. e.g. I often use "strace -e open <command>"
>>>>>> to detect configuration files read by the <command>...
>>>>>>
>>>>>> I thought that if perf bench can be independent from perf with such
>>>>>> efforts, it can be smaller sized and statically linked binary. From my
>>>>>> experience, this will be good for embedded systems people.
>>>>>>
>>>>>> This independence also has risk: less people can find it or is
>>>>>> attracted even if it stays in the kernel tree (e.g. tools/bench/). But
>>>>>> it seems that very few people know about perf bench, so this will not
>>>>>> be a serious problem ;)
>>>>>>
>>>>>> I'd like to hear your opinion.
>>>>>
>>>>> I haven't been involved with perf tools/bench so I haven't
>>>>> really formed an opinion. Ingo and Arnaldo, would either of
>>>>> you care to weigh in on the pros/cons of merging futextest
>>>>> into perf?
>>>>
>>>> No objections from me - 'perf bench futex' seems rather natural
>>>> to type to me and it would certainly make futex performance
>>>> testing easier and more widespread.
>>>>
>>>> So it all depends on whether you'd like to host it upstream and
>>>> within tools/perf/bench/.
>>>>
>>
>> There is another problem. futextest containts code not for benchmark,
>> for functional tests. My understand is: Darren doesn't like the
>> situation that the benchmark part is imported into perf bench and the
>> functional test part remains in futextest. Because this situation is
>> not good for maintenance.
>>
>> I think that the functional tests part is not suitable for perf bench
>> because of its purpose, but suitable for tools/ directly of Linux
>> kernel.
>>
>> If both of benchmark part and functional test part of futextest can be
>> imported into kernel source tree, maintenance problem will be solved.
>> Even if the benchmark part (in perf bench) and functional test part
>> are devided, they will be able to share common header files. For
>> example, these headers can be placed in tools/include directory.
>>
>> Thanks,
>
>
> If tools/testing is an appropriate place for functional and stress tests
> that would make this easier. I really like the idea of more testing for
> futexes and more eyes on the futextest code itself.
>
> Is completely integrating futextest into linux/tools/perf and
> linux/tools/testing the approach everyone would like to see us take here?

At least I think so. The part of futextest will be a good document and
integrating it into the kernel tree might be a good culture.

If the integration is allowed, I'd like to update the patch.
# But this will take a long time because my day job is busy phase, very sorry...

-- 
Hitoshi Mitake
h.mitake@gmail.com
