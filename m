Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab2AZOAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:00:08 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:45565 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2AZOAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:00:06 -0500
X-Greylist: delayed 19237 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jan 2012 09:00:05 EST
X-AuditID: b753bd60-99794ba000007b1b-38-4f215c625f7c
X-AuditID: b753bd60-99794ba000007b1b-38-4f215c625f7c
Message-ID: <4F215C5E.4090006@hitachi.com>
Date: Thu, 26 Jan 2012 22:59:58 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andi Kleen <ak@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Luis Goncalves <lgoncalv@redhat.com>
Subject: Re: [PATCH RT 1/2 v2] x86: Do not disable preemption in int3 on 32bit
References: <20120125143231.196670014@goodmis.org>  <20120125143520.086175333@goodmis.org> <4F211126.1090204@hitachi.com> <1327584811.22710.80.camel@gandalf.stny.rr.com>
In-Reply-To: <1327584811.22710.80.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/26 22:33), Steven Rostedt wrote:
> On Thu, 2012-01-26 at 17:39 +0900, Masami Hiramatsu wrote:
>> (2012/01/25 23:32), Steven Rostedt wrote:
>>> Preemption must be disabled before enabling interrupts in do_trap
>>> on x86_64 because the stack in use for int3 and debug is a per CPU
>>> stack set by th IST. But in 32bit, the stack still belongs to the
>>> current task and there is no problem in scheduling out the task.
>>>
>>> Keep preemption enabled on X86_32 when enabling interrupts for
>>> do_trap().
>>>
>>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>>
>> Hmm, I think you'd better change caller side, because the
>> function itself has "preempt" in its name. I think it can
>> easily mislead other people.
> 
> How about if we rename it to
> 
> conditional_preempt_sti/cli() ?
> 
> Then it can be both a conditional preempt as well as interrupts being
> disabled. The condition on preempt is "is 32 bits? don't preempt :
> preempt";

Better. If the functions are only for signaling, how
about using the "signal" in name? :)

conditional_sti/cli_for_signal()

Thanks,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
