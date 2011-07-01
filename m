Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab1GANPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:15:16 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59420 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab1GANPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:15:13 -0400
X-AuditID: b753bd60-a46b0ba0000019f4-0d-4e0dc85dc91f
X-AuditID: b753bd60-a46b0ba0000019f4-0d-4e0dc85dc91f
Message-ID: <4E0DC859.6050405@hitachi.com>
Date: Fri, 01 Jul 2011 22:15:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] kprobes: Add separate preempt_disabling for kprobes
References: <1309440213.26417.76.camel@gandalf.stny.rr.com>	 <1309449117.26417.90.camel@gandalf.stny.rr.com>	 <4E0D5682.3050806@hitachi.com> <1309522789.26417.128.camel@gandalf.stny.rr.com>
In-Reply-To: <1309522789.26417.128.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/01 21:19), Steven Rostedt wrote:
> On Fri, 2011-07-01 at 14:09 +0900, Masami Hiramatsu wrote:
> 
>> BTW, on my tip tree, add_preempt_count (a.k.a. inc_preempt_count())
>> is marked as __kprobes, so it can not be probed. Is there any change?
>>
> 
> That is when debug or preempt tracer is enabled. Otherwise it's
> hardcoded into whatever calls it:
> 
> #if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
>   extern void add_preempt_count(int val);
>   extern void sub_preempt_count(int val);
> #else
> # define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
> # define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
> #endif
> 
> 
> Anyway, it still doesn't help the place that reads preempt_count() and
> then later uses the result. I hit the crash in schedule_bug() where it
> increments preempt count, then reads it to see if it is only 1.

Ah, I see, that what I need...
I've made a fix patch for that, so could you test that?

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
