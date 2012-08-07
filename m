Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab2HGPjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:39:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:52912 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab2HGPjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:39:02 -0400
Message-ID: <50213685.3010208@linutronix.de>
Date: Tue, 07 Aug 2012 17:38:45 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ptrace: DEBUGCTLMSR_BTF fixes
References: <20120803162912.GA19767@redhat.com> <501FED75.5060206@linutronix.de> <20120807151512.GB13476@redhat.com>
In-Reply-To: <20120807151512.GB13476@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 05:15 PM, Oleg Nesterov wrote:
>> So I think __switch_to_extra() should set the bit before putting the
>> task on the CPU.
>
> Why?

Pardon me? __switch_to_extra() enables BTF before putting the task on
CPU. This is fine. I was trying to say that there is no need to touch
the debug register in debugger's context since __switch_to_extra() does
it.

>> If this bit is enabled on the wrong CPU then in will
>> remain set forever if single steeping has not been / will not be
>> enabled.
>
> I don't follow, could you explain in details?

The SMP case where the debugger runs on CPU0 and tracee on CPU1.
Without your "current != child" check the enable_block_step() enables
block stepping on CPU0 and switch_to_extra() on CPU1.

> Just in case, X86_EFLAGS_TF sits in task_pt_regs(next), it has no
> effect until the task returns to usermode. We only need to ensure
> DEBUGCTLMSR_BTF was set/cleared correctly when it actually returns.

Exactly. And __switch_to_extra() is perfect for the job (if we ignore
uprobes for a moment).

> Oleg.

Sebastian
