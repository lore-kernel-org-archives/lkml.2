Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab0JVE4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 00:56:38 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39110 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab0JVE4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 00:56:37 -0400
X-AuditID: b753bd60-a7533ba000000226-ca-4cc11981b488
Message-ID: <4CC1197C.5040103@hitachi.com>
Date: Fri, 22 Oct 2010 13:56:28 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for trace_sched_wakeup.c
References: <1287508282.16971.386.camel@gandalf.stny.rr.com>	 <20101019184111.GA17266@elte.hu> <20101020154045.GA18353@elte.hu>	 <20101020164324.GC7348@redhat.com>  <4CBFAC70.30602@hitachi.com>	 <1287645744.3488.57.camel@twins>	 <1287658862.16971.569.camel@gandalf.stny.rr.com> <1287659008.3488.102.camel@twins>
In-Reply-To: <1287659008.3488.102.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/10/21 20:03), Peter Zijlstra wrote:
> On Thu, 2010-10-21 at 07:01 -0400, Steven Rostedt wrote:
>> On Thu, 2010-10-21 at 09:22 +0200, Peter Zijlstra wrote:
>>> On Thu, 2010-10-21 at 11:58 +0900, Masami Hiramatsu wrote:
>>>
>>>> It seems there can be a bug in stop_machine() routine under
>>>> heavy use. usually that is called just once at a time, but jump
>>>> label and optprobe might call it heavily (thousands times?).
>>>> So some racy situation can be happen easily.
>>>
>>> There are people doing hotplug stress testing, that too results in heavy
>>> stop_machine usage.
>>
>> But with hotplug, isn't there a bit more time between stop machine
>> calls? That is, you need to do a bit of work to bring down or up a CPU,
>> and that will slow down the number of stop machine calls together.
>>
>> Here, we do a simple change and call stop machine() several times.
>>
>> Although, I agree, I do not think the bug is in stop machine itself, but
>> perhaps the way we are using it might have some niche anomaly that we
>> are hitting.
> 
> Possibly, but wouldn't it make sense to batch up the work and simply
> call stop_machine only once? I mean, if you already know you're going to
> do this...
> 

Yeah, here is what I had tried;

http://sourceware.org/ml/systemtap/2010-q2/msg00294.html

I agree that the crash will just disappear with this API,
but it will be just hidden, still remains inside kernel.

Anyway, this batch patching is needed from performance
viewpoint too. I'll rework on it.

Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
