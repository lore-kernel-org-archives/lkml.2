Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab2BXFc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 00:32:27 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38977 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab2BXFc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 00:32:26 -0500
Date: Fri, 24 Feb 2012 11:01:49 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Anton Arapov <anton@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Josh Stone <jistone@redhat.com>
Subject: Re: [PATCH] uprobes/core: handle breakpoint and signal step
 exception.
Message-ID: <20120224053149.GA25846@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120223110245.12459.7391.sendpatchset@srdronam.in.ibm.com>
 <20120223121805.GB2196@bandura.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120223121805.GB2196@bandura.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022405-6078-0000-0000-000008603B79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > +static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
> > +{
> > +	struct uprobe_consumer *consumer;
> > +
> > +	if (!(uprobe->flags & UPROBES_RUN_HANDLER))
> > +		return;
> > +
> > +	down_read(&uprobe->consumer_rwsem);
> > +	consumer = uprobe->consumers;
> The line above is not needed, looks like a leftover. Perhaps Ingo can
> cut it before commit.

Right Anton.

Ingo, 

Please let me know if you want me to send an updated patch with line removed.



> 
> > +	for (consumer = uprobe->consumers; consumer; consumer = consumer->next) {
> > +		if (!consumer->filter || consumer->filter(consumer, current))
> > +			consumer->handler(consumer, regs);
> > +	}
> > +	up_read(&uprobe->consumer_rwsem);
> > +}
> > +
> >  /* Returns the previous consumer */

-- 
Thanks and Regards
Srikar

