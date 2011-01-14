Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab1ANKIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 05:08:22 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49492 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab1ANKIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 05:08:17 -0500
X-AuditID: b753bd60-a1763ba000000f65-65-4d30208ebbf2
Message-ID: <4D30208B.7040902@hitachi.com>
Date: Fri, 14 Jan 2011 19:08:11 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        lkml <linux-kernel@vger.kernel.org>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH] perf-probe: make "perf-probe -L <function>" display the
 absolute path and absolute line number
References: <m38vyp85qv.fsf@gmail.com> <4D2EDBE4.3060608@hitachi.com>	<m34o9c8ual.fsf@gmail.com> <4D2FC17D.5010203@hitachi.com> <m3tyhb6eme.fsf@gmail.com>
In-Reply-To: <m3tyhb6eme.fsf@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/01/14 18:03), Franck Bui-Huu wrote:
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
> 
>> (2011/01/14 4:42), Franck Bui-Huu wrote:
> 
> [...]
> 
>>> Well, for consistency, I thought that the additional information
>>> (given inside angle brackets) should always be the same: a full path
>>> and an absolute line number which clearly identify which source file
>>> perf-probe is listing.
>>
>> No, that is NOT an additional information. That indicates from where
>> those lines are started
> 
> But this indication is currently not enough, it's too ambiguous to be
> usefull:
> 
>         <schedule:10>
> 
> there might be several 'schedule()' functions inside the kernel, also we
> don't know which kernel tree is used.

Right, so I didn't decline your idea itself.
I've just commented on the output format of the path information.


> BTW, if there're several 'do_something' functions defined inside the
> kernel, what is the behaviour of:
> 
>   $ perf probe do_something
> 
> Does it set a probe to all 'do_something' functions ? I don't think it's
> documented.

If do_something is an inline function, it tries to find all
functions. If it (the first one) is a normal function, it
just stopped after finding the first one.

If someone wants to put a probe on the specific function,
he can add some additional path information, like

 $ perf probe do_something@path/to/source.c


>> , and also gives you a hint how you can specify the actual probe
>> point. For example,
>>
>> $ perf probe -L schedule:10
>> <schedule:10>
>>      10         rq = cpu_rq(cpu);
>>      11         rcu_note_context_switch(cpu);
>>      12         prev = rq->curr;
>>
>> this indicates the lines started from 10th line of schedule(), and
> 
> but I'm not sure it's really usefull since you've asked for it when
> invoking perf-probe so it seems to be redundant.

If you list the lines of enough long function, the output will be
passed to pager and it flushes out the command line.

In that case, user will see only below output.

   </usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:3823>
        10         rq = cpu_rq(cpu);
        11         rcu_note_context_switch(cpu);
        12         prev = rq->curr;
        13         switch_count = &prev->nivcsw;

        15         release_kernel_lock(prev);

Hmm, how can he find the probe point from this? :)
Yeah, I know user must know what he has given. However, I'd like to
show users what actually he has given.

Thanks,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
