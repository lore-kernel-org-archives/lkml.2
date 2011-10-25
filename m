Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab1JYOk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 10:40:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab1JYOk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 10:40:56 -0400
Date: Tue, 25 Oct 2011 16:30:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/X] uprobes: introduce UTASK_SSTEP_TRAPPED logic
Message-ID: <20111025143026.GA12750@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20111015190007.GA30243@redhat.com> <20111019215139.GA16395@redhat.com> <20111019215344.GG16395@redhat.com> <20111022072030.GB24475@in.ibm.com> <20111024144127.GA14975@redhat.com> <20111024151614.GA6034@in.ibm.com> <20111024161306.GB19659@redhat.com> <20111025060059.GA8247@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025060059.GA8247@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25, Ananth N Mavinakayanahalli wrote:
>
> No, you are right... my inference was wrong. On a core with a uprobe
> with an explicit raise(SIGABRT) does show the breakpoint.
>
> (gdb) disassemble start_thread2
> Dump of assembler code for function start_thread2:
>    0x0000000000400831 <+0>:	int3
>    0x0000000000400832 <+1>:	mov    %rsp,%rbp
>    0x0000000000400835 <+4>:	sub    $0x10,%rsp
>    0x0000000000400839 <+8>:	mov    %rdi,-0x8(%rbp)
>    0x000000000040083d <+12>:	callq  0x400650 <getpid@plt>
>
> Now, I guess we need to agree on what is the acceptable behavior in the
> uprobes case. What's your suggestion?

Well, personally I think this is acceptable.

Once again, uprobes were designed to be "system wide", and each uprobe
connects to the file. This int3 reflects this fact. In any case, I do
not see how we can hide these int3's. Perhaps we can fool ptrace/core,
but I am not sure this would be really good, this can add more confusion.
And the application itself can read its .text and see int3, what can
we do?

Oleg.

