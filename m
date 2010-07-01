Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0GAJSC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 05:18:02 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:60539 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab0GAJR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 05:17:59 -0400
X-AuditID: b753bd60-a8003ba000007d15-12-4c2c5d443a68
Message-ID: <4C2C5D41.40807@hitachi.com>
Date: Thu, 01 Jul 2010 18:17:53 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCHv7 2.6.35-rc3-tip 0/11]  Uprobes Patches:
References: <20100629183454.32537.63582.sendpatchset@localhost6.localdomain6> <20100701050216.GI23231@linux.vnet.ibm.com> <20100701081942.GA19826@elte.hu>
In-Reply-To: <20100701081942.GA19826@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:
> 
>> Hi Ingo,
>>
>> I have addressed all comments to the uprobes patchset.  We have few todos 
>> (most of them are features over the current code) which I plan to work in 
>> the immediate future.
>>
>> So would it be possible for this patchset to be picked into the tip tree. 
>> Getting these patches merged into the tip tree would help in getting more 
>> comments/feedback and testing.
> 
> If Masami-san, PeterZ and Arnaldo is happy with it being tried in its current 
> form then we could try it.

At least ftrace/perf side, it's almost good for me. (but I need time to test it)

> Assuming everyone is reasonably happy about the code, here are some open areas 
> as i see them, before we can think about pushing things from -tip towards 
> upstream:
> 
> - One thing i havent seen is the ability to 'list' potential probe points:
>   i.e. function names. Often the user will not know precisely where to look 
>   and what to type. This leaves our probe capability under-utilized in 
>   practice.

It will be the next step for perf-(u)probe, debuginfo support. Since
the perf-(k)probe already support in which function the probe is put,
I think if perf-(u)probe support debuginfo, it's easy to be implemented.

> - On a similar note, it might also make sense to extend the Newt interface to 
>   perf report to integrate probes: if a function looks high-overhead, then a 
>   probe point could be inserted and the app could be traced straight away. We 
>   already allow per function actions in the Newt interface, such as assembly 
>   annotation - the adding of a probe point would be quite useful.

Hmm, does that mean that user puts a new probe point from Newt interface?
That's a good idea:)

> - [ Optional: Another interesting area to look at would be the scripting 
>     engine: allow trace scripts to insert probes if they are not present yet. ]

Sure, that's what I hope. :)

> - Plus the security model is an open question as well. Right now it's
>   root-only, but it would make sense to allow users to insert probes into 
>   their own apps. This brings up the next point:

Hmm, put a probe in user-space(by owner) may be good. But
inside the kernel, there are more sensitive informations...

> - Proper syscall integration and more unification with kprobes and with the 
>   TRACE_EVENT() universe. As far as API design goes, 
>   /sys/kernel/debug/tracing/uprobe_events is quite sucky as a concept.

Yeah, we can extend the interface and merge it. But removing all
debugfs interfaces should be discussed.

Thank you,

> 
> Thanks,
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

