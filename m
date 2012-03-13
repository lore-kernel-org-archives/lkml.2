Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397Ab2CMFnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:43:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44685 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758287Ab2CMFnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:43:07 -0400
Date: Tue, 13 Mar 2012 06:42:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Josh Stone <jistone@redhat.com>
Subject: Re: [PATCH] uprobes/core: handle breakpoint and signal step
 exception.
Message-ID: <20120313054242.GA1623@elte.hu>
References: <20120223110245.12459.7391.sendpatchset@srdronam.in.ibm.com>
 <20120227091212.GA7092@elte.hu>
 <20120308131824.GC13284@linux.vnet.ibm.com>
 <20120308134809.GB28488@elte.hu>
 <20120309062853.GD13284@linux.vnet.ibm.com>
 <20120309073348.GA15570@elte.hu>
 <20120313052016.GA27824@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313052016.GA27824@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> I.e. you could drop this patch altogether:
> 
>   x86/trivial: Fix 'old_rsp' undefined build failure when including asm/compat.h
> 
> And rework the is_ia32_compat_task() patch to use another 
> header and to use the is_32bit_task() name. Also, you should 
> double check whether the x32 execution model needs special 
> consideration as well:
> 
>  #define TIF_IA32		17	/* IA32 compatibility process */
>  #define TIF_X32		30	/* 32-bit native x86-64 binary */
> 
> otherwise uprobe will not work with x32 tasks properly.

Given that x32 tasks are using native 64-bit syscalls, what you 
need is the is_ia32_task() check. We have that in -tip already, 
in compat.h. If uprobes uses that definition then uprobes will 
be able to probe x32 tasks as well.

To make it available to uprobes please move is_ia32_task() to 
processor.h and make it return 1 on i386 kernels. This should be 
a very simple patch - and that's all that is needed.

Thanks,

	Ingo
