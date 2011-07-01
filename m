Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab1GABWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 21:22:16 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49646 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab1GABWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 21:22:14 -0400
X-AuditID: b753bd60-a467eba0000050a4-13-4e0d214356c2
X-AuditID: b753bd60-a467eba0000050a4-13-4e0d214356c2
Message-ID: <4E0D2141.4080608@hitachi.com>
Date: Fri, 01 Jul 2011 10:22:09 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC][PATCH] kprobes: Add separate preempt_disabling for kprobes
References: <1309440213.26417.76.camel@gandalf.stny.rr.com>	 <1309449117.26417.90.camel@gandalf.stny.rr.com> <1309470997.12449.614.camel@twins>
In-Reply-To: <1309470997.12449.614.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/01 6:56), Peter Zijlstra wrote:
> On Thu, 2011-06-30 at 11:51 -0400, Steven Rostedt wrote:
>>
>> To solve this, I've added a per_cpu variable called
>> kprobe_preempt_disabled, that is set by the kprobe code. If it is set,
>> the preempt_schedule() will not preempt the code.

Sorry for replying so late :(

> Damn this is ugly. Can we step back and see if we can make the
> requirement for kprobe to disable preemption go away?

As I replied right now, I think we can just eliminate that
disabling preemption code. At least we'd better try it.
I agree with you, introducing this kind of complexity
just for kprobes is not what I want. :(

> Why does it have to do that anyway? Isn't it keeping enough per-task
> state to allow preemption over the single step?

preemption itself must not happen on single stepping, but it seems
impossible to do heavy context switching with setting TF bit...

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
