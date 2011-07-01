Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab1GAMBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:01:08 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54055 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab1GAMBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:01:05 -0400
X-AuditID: b753bd60-a50caba000003bac-41-4e0db6fe6095
X-AuditID: b753bd60-a50caba000003bac-41-4e0db6fe6095
Message-ID: <4E0DB6FC.20904@hitachi.com>
Date: Fri, 01 Jul 2011 21:01:00 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: ananth@in.ibm.com
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [BUG] kprobes crashing because of preempt count
References: <1309440213.26417.76.camel@gandalf.stny.rr.com> <4E0D1EE3.6080607@hitachi.com> <20110701113626.GB23752@in.ibm.com>
In-Reply-To: <20110701113626.GB23752@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/01 20:36), Ananth N Mavinakayanahalli wrote:
> On Fri, Jul 01, 2011 at 10:12:03AM +0900, Masami Hiramatsu wrote:
>> (2011/06/30 22:23), Steven Rostedt wrote:
> 
> ...
> 
>>> Do we really need to have preemption disabled throughout this? Is it
>>> because we don't want to migrate or call schedule? Not sure what the
>>> best way to fix this is. Perhaps we add a kprobe_preempt_disable() that
>>> is checked as well?
>>
>> I think the best way to do that is just removing preemption disabling
>> code, because
>> - breakpoint exception itself disables interrupt (at least on x86)
>> - While single stepping, interrupts also be disabled.
> 
> On 64-bit powerpc, kprobe handlers are run with interrupts enabled
> (MSR_EE = 1), but most instructions (including loads/stores) are
> emulated, so for the most part, we don't take the sstep exception.

Yeah, it seems that same thing is done on arm too. And I'm sure that
However, I'm still not sure that entire int3 exec path can run without
calling inc_preempt_count.
It seems that the function is very primitive, and I doubt we can
allow to put kprobes on that...

Thank you,

> 
> Ananth


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
