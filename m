Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab1JER6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 13:58:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293Ab1JER6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 13:58:04 -0400
Date: Wed, 5 Oct 2011 19:53:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 5/26]   Uprobes: copy of the original
	instruction.
Message-ID: <20111005175353.GA5475@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20110920120057.25326.63780.sendpatchset@srdronam.in.ibm.com> <20111003162905.GA3752@redhat.com> <20111005160934.GC806@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005160934.GC806@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2011-10-03 18:29:05]:
>
> > But I am starting to think I simply do not understand this change.
> > To the point, I do not underestand why do we need copy_insn() at all.
> > We are going to replace this page, can't we save/analyze ->insn later
> > when we copy the content of the old page? Most probably I missed
> > something simple...
> >
>
> Copying the instruction at the time we replace the original instruction
> would have been ideal. However there are a few irritants to handle.
>
> ...
>    How do we distinguish if the
>    breakpoint instruction was around in the text or somebody inserted a
>    breakpoint in that address-space? Since we read from the page-cache,
>    we can easily resolve this.

Ah. I see.

> -  On archs like x86, with variable size instructions, the original
>    instruction can be across 2 pages.

Heh. Indeed ;)

Thanks Srikar.

Oleg.

