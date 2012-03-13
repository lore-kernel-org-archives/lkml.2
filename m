Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207Ab2CMJjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:39:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54893 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab2CMJjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:39:24 -0400
Date: Tue, 13 Mar 2012 10:38:48 +0100
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
Message-ID: <20120313093847.GA19473@elte.hu>
References: <20120223110245.12459.7391.sendpatchset@srdronam.in.ibm.com>
 <20120227091212.GA7092@elte.hu>
 <20120308131824.GC13284@linux.vnet.ibm.com>
 <20120308134809.GB28488@elte.hu>
 <20120309062853.GD13284@linux.vnet.ibm.com>
 <20120309073348.GA15570@elte.hu>
 <20120313052016.GA27824@elte.hu>
 <20120313054242.GA1623@elte.hu>
 <20120313054744.GA27315@elte.hu>
 <20120313092433.GA21727@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313092433.GA21727@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> * Ingo Molnar <mingo@elte.hu> [2012-03-13 06:47:44]:
> 
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > To make it available to uprobes please move is_ia32_task() to 
> > > processor.h and make it return 1 on i386 kernels. This should 
> > > be a very simple patch - and that's all that is needed.
> > 
> > Side note: in general I don't mind making compat.h a bit more 
> > generic (at all), but is_ia32_task() is really a generic x86 
> > specific check that we can move to processor.h cleanly.
> > 
> > Some other effort should make compat.h bitness agnostic - 
> > uprobes doesn't actually make use of the compat types and 
> > facilities there, and it resulted in a nonsensical change like 
> > making the alloc function generic ...
> > 
> 
> Okay, Will move is_ia32_task() to processor.h and use it.

thread_info.h might be a better place, because the TIF_ flags 
are defined there.

Thanks,

	Ingo
