Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2HGPuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:50:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab2HGPuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:50:08 -0400
Date: Tue, 7 Aug 2012 17:46:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ptrace: DEBUGCTLMSR_BTF fixes
Message-ID: <20120807154635.GA14753@redhat.com>
References: <20120803162912.GA19767@redhat.com> <501FED75.5060206@linutronix.de> <20120807151512.GB13476@redhat.com> <50213685.3010208@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50213685.3010208@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07, Sebastian Andrzej Siewior wrote:
>
> On 08/07/2012 05:15 PM, Oleg Nesterov wrote:
>>> So I think __switch_to_extra() should set the bit before putting the
>>> task on the CPU.
>>
>> Why?
>
> Pardon me? __switch_to_extra() enables BTF before putting the task on
> CPU. This is fine. I was trying to say that there is no need to touch
> the debug register in debugger's context since __switch_to_extra() does
> it.

And this is what the changelog says and the patch does? Confused.

>>> If this bit is enabled on the wrong CPU then in will
>>> remain set forever if single steeping has not been / will not be
>>> enabled.
>>
>> I don't follow, could you explain in details?
>
> The SMP case where the debugger runs on CPU0 and tracee on CPU1.
> Without your "current != child" check the enable_block_step() enables
> block stepping on CPU0 and switch_to_extra() on CPU1.

Sure, and after the patch it doesn't touch BTF if current != child.

>> Just in case, X86_EFLAGS_TF sits in task_pt_regs(next), it has no
>> effect until the task returns to usermode. We only need to ensure
>> DEBUGCTLMSR_BTF was set/cleared correctly when it actually returns.
>
> Exactly. And __switch_to_extra() is perfect for the job (if we ignore
> uprobes for a moment).

Exactly.



Ah. I guess I simply misunderstood your original email. Sorry. Somehow
I thought you think that __switch_to_extra() needs fixes too.

Sorry for noise.

Oleg.

