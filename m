Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2HANuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 09:50:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab2HANuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 09:50:03 -0400
Date: Wed, 1 Aug 2012 15:46:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Roland McGrath <roland@hack.frob.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, ananth@in.ibm.com,
        a.p.zijlstra@chello.nl, mingo@redhat.com, srikar@linux.vnet.ibm.com
Subject: Re: Q: user_enable_single_step() && update_debugctlmsr()
Message-ID: <20120801134652.GA4707@redhat.com>
References: <20120730141638.GA5306@redhat.com> <1343735548-18101-1-git-send-email-bigeasy@linutronix.de> <1343735548-18101-2-git-send-email-bigeasy@linutronix.de> <20120731175108.GC14576@redhat.com> <50183273.9070304@linutronix.de> <20120801122616.GA32705@redhat.com> <20120801130118.GA2386@redhat.com> <50192FF5.1060208@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50192FF5.1060208@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Sebastian Andrzej Siewior wrote:
>
> On 08/01/2012 03:01 PM, Oleg Nesterov wrote:
>> Lets ignore uprobes which needs the changes anyway. This is
>> only used by ptrace and the task is stopped. So, unless I missed
>> something obvious, this update_debugctlmsr() is simply unneeded,
>> __switch_to/__switch_to_xtra should notice _TIF_BLOCKSTEP and do
>> update_debugctlmsr(DEBUGCTLMSR_BTF).
>
> It looks like it unless a processes ptraces itself (which does not make
> much sense anyway).

and forbidden ;) See ptrace_attach()->same_thread_group().

>> But, worse, isn't it wrong? Suppose that debugger switches to
>> another TIF_SINGLESTEP&&  !TIF_BLOCKSTEP task, in this case
>> we "leak" DEBUGCTLMSR_BTF, no?
>
> __switch_to_xtra() should notice the difference in the TIF_BLOCKSTEP
> flag and disable it.

And how it can notice the difference if there is no difference?

(unless, of course debugger is TIF_BLOCKSTEP'ed).

Oleg.

