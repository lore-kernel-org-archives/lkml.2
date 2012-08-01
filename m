Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2HAPEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:04:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab2HAPEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:04:41 -0400
Date: Wed, 1 Aug 2012 17:01:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Roland McGrath <roland@hack.frob.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, ananth@in.ibm.com,
        a.p.zijlstra@chello.nl, mingo@redhat.com, srikar@linux.vnet.ibm.com
Subject: Re: Q: user_enable_single_step() && update_debugctlmsr()
Message-ID: <20120801150119.GA8845@redhat.com>
References: <50183273.9070304@linutronix.de> <20120801122616.GA32705@redhat.com> <20120801130118.GA2386@redhat.com> <50192FF5.1060208@linutronix.de> <20120801134652.GA4707@redhat.com> <50193528.3070503@linutronix.de> <20120801140121.GA5333@redhat.com> <50193B5C.90404@linutronix.de> <20120801143132.GA7550@redhat.com> <5019427B.1070002@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5019427B.1070002@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Sebastian Andrzej Siewior wrote:
>
> So a patch like
> --- a/arch/x86/kernel/step.c
> +++ b/arch/x86/kernel/step.c
> @@ -173,8 +173,8 @@ static void enable_step(struct task_struct *child,  
> bool block)
>                 unsigned long debugctl = get_debugctlmsr();
>
>                 debugctl |= DEBUGCTLMSR_BTF;
> -               update_debugctlmsr(debugctl);
>                 set_tsk_thread_flag(child, TIF_BLOCKSTEP);
> +               update_debugctlmsr(debugctl);
>         } else if (test_tsk_thread_flag(child, TIF_BLOCKSTEP)) {
>                 unsigned long debugctl = get_debugctlmsr();
>
> should fix the race

No, I don't think it can fix something ;) or make any difference.

> and _yes_ I also would follow your suggestion to
> remove this update_debugctlmsr() here since switch_to() should do this.

Agreed, but once again, uprobes needs it if child == current (but we should
move this code into the trivial helper). If we change (I hope) uprobes to
avoid user_enable_single_step() we will export the helper.

Oleg.

