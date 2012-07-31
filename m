Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab2GaTbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 15:31:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:45278 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab2GaTbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 15:31:05 -0400
Message-ID: <50183273.9070304@linutronix.de>
Date: Tue, 31 Jul 2012 21:30:59 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, ananth@in.ibm.com, a.p.zijlstra@chello.nl,
        mingo@redhat.com, srikar@linux.vnet.ibm.com, roland@hack.frob.com
Subject: Re: [PATCH 2/2] x86/uprobes: implement x86 specific arch_uprobe_*_step
References: <20120730141638.GA5306@redhat.com> <1343735548-18101-1-git-send-email-bigeasy@linutronix.de> <1343735548-18101-2-git-send-email-bigeasy@linutronix.de> <20120731175108.GC14576@redhat.com>
In-Reply-To: <20120731175108.GC14576@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 07:51 PM, Oleg Nesterov wrote:
> However, honestly I do not like it. I think we should change this
> step-by-step, that is why I suggested to use TIF_SINGLESTEP and
> user_enable_single_step() like your initial patch did. With this
> patch at least the debugger doesn't lose the control over the tracee
> if it steps over the probed insn, and this is the main (and known ;)
> problem to me.

I thought you did not like the nesting with TIF_SIGNLESTEP and the
_FORCE and suggested to handle the complete state within uprobe.

> Every change needs the discussion. For example, _enable should
> clear DEBUGCTLMSR_BTF, this is obvious. But it is not clear to
> me if _disable should restore it. What if the probed insn was
> "jmp"? We need the additional complications to handle this case
> really correctly, and for what? OK, gdb can get the extra SIGTRAP
> from the tracee, but this is fine. And uprobes can confuse gdb
> in many ways.

I don't know if it is worth to have correct behavior here or rather go
for the easy way which is either always do the wakeup or delay until
the next jump.

Sebastian
