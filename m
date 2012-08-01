Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab2HANcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 09:32:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:51015 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab2HANcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 09:32:46 -0400
Message-ID: <50192FF5.1060208@linutronix.de>
Date: Wed, 01 Aug 2012 15:32:37 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Roland McGrath <roland@hack.frob.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, ananth@in.ibm.com,
        a.p.zijlstra@chello.nl, mingo@redhat.com, srikar@linux.vnet.ibm.com
Subject: Re: Q: user_enable_single_step() && update_debugctlmsr()
References: <20120730141638.GA5306@redhat.com> <1343735548-18101-1-git-send-email-bigeasy@linutronix.de> <1343735548-18101-2-git-send-email-bigeasy@linutronix.de> <20120731175108.GC14576@redhat.com> <50183273.9070304@linutronix.de> <20120801122616.GA32705@redhat.com> <20120801130118.GA2386@redhat.com>
In-Reply-To: <20120801130118.GA2386@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 03:01 PM, Oleg Nesterov wrote:
> Lets ignore uprobes which needs the changes anyway. This is
> only used by ptrace and the task is stopped. So, unless I missed
> something obvious, this update_debugctlmsr() is simply unneeded,
> __switch_to/__switch_to_xtra should notice _TIF_BLOCKSTEP and do
> update_debugctlmsr(DEBUGCTLMSR_BTF).

It looks like it unless a processes ptraces itself (which does not make
much sense anyway).

> But, worse, isn't it wrong? Suppose that debugger switches to
> another TIF_SINGLESTEP&&  !TIF_BLOCKSTEP task, in this case
> we "leak" DEBUGCTLMSR_BTF, no?

__switch_to_xtra() should notice the difference in the TIF_BLOCKSTEP
flag and disable it.

> IOW, it seems to me we could safely remove update_debugctlmsr()
> arch/x86/kernel/step.c. However, if we want to re-use this code
> in uprobes, then we probably need to add "if (child == current)".
It looks that way.

>
> Or I am totally confused. Help!
>
> Oleg.

Sebastian
