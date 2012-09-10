Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab2IJRZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:25:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab2IJRZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:25:52 -0400
Date: Mon, 10 Sep 2012 19:27:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] ptrace: Partly fix
	set_task_blockstep()->update_debugctlmsr() logic
Message-ID: <20120910172736.GA14168@redhat.com>
References: <20120903152525.GA9028@redhat.com> <20120903152609.GA9071@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120903152609.GA9071@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian, I am replying to my message because I removed your email
by mistake. Fortunately I can see it on marc.info...

> ptrace and uprobe are calling this function from process context. As
> long as you have here get_cpu() instead of local_irq_disable() you should
> be safe here.

local_irq_disable() looks more safe. We can have new users playing
with MSR_IA32_DEBUGCTLMSR from irq.

> perf
> uses raw_local_irqsave() (raw_* most likely due to -RT).

This is completely irrelevant, we alrady discussed this.

> I have no idea
> what you can against NMI unless not touching the register in NMI
> context.

Neither me, and this is documented in the changelog:

	And afaics there is yet another problem: perf can play with
	MSR_IA32_DEBUGCTLMSR from nmi, this obviously means that even
	__switch_to_xtra() has problems.

and please note __switch_to_xtra() above, it has the same problem
by the same reason.

Oleg.

