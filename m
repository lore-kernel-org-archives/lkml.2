Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0FONR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:17:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab0FONRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:17:55 -0400
Date: Tue, 15 Jun 2010 15:15:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 7/14] x86 support for Uprobes
Message-ID: <20100615131512.GA8751@redhat.com>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6> <20100614082913.29068.86825.sendpatchset@localhost6.localdomain6> <20100614175423.GG23754@infradead.org> <20100615062332.GE13800@linux.vnet.ibm.com> <20100615115155.GA4831@redhat.com> <20100615121506.GM13800@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615121506.GM13800@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15, Srikar Dronamraju wrote:
>
> > I think it is OK to enable interrupts. do_notify_resume() calls do_signal()
> > which enables them anyway.
> >
> > But there is another question I already asked. Why the code uses
> > native_irq_enable()? IIRC, you explained that local_irq_enable() doesn't
> > work for unkown reason. This is strange, and imho should be explained.
>
> local_irq_enable() translates to raw_local_irq_enable().
> However raw_local_irq_enable on x86 seems to depend on CONFIG_PARAVIRT.
> On a machine, where CONFIG_PARAVIRT was defined, local_irq_enable
> translates to something other than native_irq_enable.
> It translates to PVOP_VCALLEE0(pv_irq_ops.irq_enable);

I see, and my question is why PVOP_VCALLEE0(pv_irq_ops.irq_enable) doesn't
work ? If it doesn't here, why it works for other callers of local_irq_enable?

I think we should ask paravirt developers.

> Is it okay to use local_irq_enable() and then make CONFIG_UPROBES depend
> on !CONFIG_PARAVIRT?

I dunno, and I know nothing about paravirt.

But please note that currently native_irq_enable has the only caller,
raw_local_irq_enable(). It is really strange that do_notify_resume()
has to use it, and it uses it to bypass the paravirt layer which perhaps
can introduce other problems.

Oleg.

