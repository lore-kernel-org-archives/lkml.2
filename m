Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab2FFQCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:02:12 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49563 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790Ab2FFQCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:02:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120606073909.GI17808@gmail.com>
References: <1337268092-6765-1-git-send-email-h.mitake@gmail.com>
	<4FB52636.3040604@linux.intel.com>
	<CAMO-S2g9fkg_KH0CPOsB_7GQTN2mu8zir+UZDp6=VC+7XDrfrg@mail.gmail.com>
	<CAMO-S2gyzK3VTQcTRw+FAO9ui_gy=1z=MVxUYM9sPN51KrDgkg@mail.gmail.com>
	<4FCE4D24.5040307@linux.intel.com>
	<20120606073909.GI17808@gmail.com>
Date: Thu, 7 Jun 2012 01:02:08 +0900
Message-ID: <CAMO-S2j_3tT3WEYiiSo1MWwRctMhKdaNOSTRUx+2Vpvp+eYCHQ@mail.gmail.com>
Subject: Re: [PATCH] perf bench: add new benchmark subsystem and suite "futex wait"
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
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

On Wed, Jun 6, 2012 at 4:39 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Darren Hart <dvhart@linux.intel.com> wrote:
>
>> On 05/20/2012 02:37 AM, Hitoshi Mitake wrote:
>> > On Sun, May 20, 2012 at 5:32 PM, Hitoshi Mitake <h.mitake@gmail.com> wrote:
>> >> On Fri, May 18, 2012 at 1:24 AM, Darren Hart <dvhart@linux.intel.com> wrote:
>> >>> On 05/17/2012 08:21 AM, Hitoshi Mitake wrote:
>> >>>> Hi Ingo, Eric and Darren,
>> >>>> (CCed perf and futex folks)
>> >>>>
>> >>>> I wrote this patch for adding new subsystem "futex" and its suite "wait" to perf
>> >>>> bench on tip/master. This is based on futextest by Darren Hart.
>> >>>>
>> >>>> Could you allow me to import your source code of futextest to perf bench, Darren?
>> >>>>
>> >>>
>> >>> I do have some concerns I'd like to address first.
>> >>>
>> >>> What is advantage of incorporating this into perf as opposed to running
>> >>> it with perf?
>> >>
>> >> The main and direct advantage is that perf bench can share useful
>> >> utilities stored under tools/perf/util/ directory e.g. parse-options[ch].
>> >>
>> >
>> > BTW, I often feel parse-options.[ch] of perf (this was come from git,
>> > right?) is very useful not only for perf and git but also other
>> > projects. So I think these stuff are worth independence as a
>> > library. If the library contains unified feature for parsing and
>> > evaluating configuration files, the hell of managing configurable
>> > options will be reduced. e.g. I often use "strace -e open <command>"
>> > to detect configuration files read by the <command>...
>> >
>> > I thought that if perf bench can be independent from perf with such
>> > efforts, it can be smaller sized and statically linked binary. From my
>> > experience, this will be good for embedded systems people.
>> >
>> > This independence also has risk: less people can find it or is
>> > attracted even if it stays in the kernel tree (e.g. tools/bench/). But
>> > it seems that very few people know about perf bench, so this will not
>> > be a serious problem ;)
>> >
>> > I'd like to hear your opinion.
>>
>> I haven't been involved with perf tools/bench so I haven't
>> really formed an opinion. Ingo and Arnaldo, would either of
>> you care to weigh in on the pros/cons of merging futextest
>> into perf?
>
> No objections from me - 'perf bench futex' seems rather natural
> to type to me and it would certainly make futex performance
> testing easier and more widespread.
>
> So it all depends on whether you'd like to host it upstream and
> within tools/perf/bench/.
>
> I'd rather not split it from the main perf binary, if embedded
> wants a small static binary (do they really?) we could add
> support for minimal builds of perf, with just a few [even one]
> subcommand activated or so.


Sorry, I meant that the main problem is not size of binary, dependency
of libraries and headers for building perf.

Preparing cross compilers is hard. Preparing libraries and headers for
them are also hard. So I think making build process of perf is
suitable for embedded systems.

As Arnaldo says, menuconfig approach might be promising.
# I couldn't come up with the idea...

Thanks,


-- 
Hitoshi Mitake
h.mitake@gmail.com
