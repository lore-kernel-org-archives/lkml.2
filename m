Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab2HGPSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:18:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab2HGPSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:18:35 -0400
Date: Tue, 7 Aug 2012 17:15:12 +0200
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
Message-ID: <20120807151512.GB13476@redhat.com>
References: <20120803162912.GA19767@redhat.com> <501FED75.5060206@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501FED75.5060206@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Today I noticed by accident that starting from Aug 4 (at least)
all my emails went to nowhere. I am resending some of them...

On 08/06, Sebastian Andrzej Siewior wrote:
>
> On 08/03/2012 06:29 PM, Oleg Nesterov wrote:
>
>> Assuming this series passes the review of course. And it would
>> be really nice if someone reviews 2/2, I am not confident that
>> I fully understand this DEBUGCTLMSR_BTF magic.
>
> Here is how the processor disables the BTF:
>
> | The processor clears the BTF flag when it generates a debug
> | exception. The debugger must set the BTF flag before resuming program
> | execution to continue single-stepping on branches.
>
> This was a quote from "253668-039US, May 2011" page 16-17.

OK, thanks,

> So I think __switch_to_extra() should set the bit before putting the
> task on the CPU.

Why?

> If this bit is enabled on the wrong CPU then in will
> remain set forever if single steeping has not been / will not be
> enabled.

I don't follow, could you explain in details?

Just in case, X86_EFLAGS_TF sits in task_pt_regs(next), it has no
effect until the task returns to usermode. We only need to ensure
DEBUGCTLMSR_BTF was set/cleared correctly when it actually returns.

Oleg.

