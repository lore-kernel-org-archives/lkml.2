Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1DFWmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:42:07 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35791 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab1DFWmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:42:05 -0400
Date: Thu, 7 Apr 2011 04:11:48 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2.6.39-rc1-tip 26/26] 26: uprobes: filter chain
Message-ID: <20110406224148.GA5806@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
 <20110401143737.15455.30181.sendpatchset@localhost6.localdomain6>
 <4D9A6FE8.2010301@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4D9A6FE8.2010301@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static bool filter_chain(struct uprobe *uprobe, struct task_struct *t)
> > +{
> > +	struct uprobe_consumer *consumer;
> > +	bool ret = false;
> > +
> > +	down_read(&uprobe->consumer_rwsem);
> > +	for (consumer = uprobe->consumers; consumer;
> > +					consumer = consumer->next) {
> > +		if (!consumer->filter || consumer->filter(consumer, t)) {
> > +			ret = true;
> > +			break;
> > +		}
> > +	}
> > +	up_read(&uprobe->consumer_rwsem);
> > +	return ret;
> > +}
> > +
> 
> Where this function is called from ? This patch seems the last one of this series...
> 

Sorry for the delayed reply, I was travelling to LFCS.
Still I have to connect the filter from trace/perf probe. 
Thats listed as todo and thats the next thing I am planning to work on.
Once we have the connect, this filter_chain and filters that we defined
will be used. Till then these two patches, One that defines filter_chain
and one that defines filters are useless.

-- 
Thanks and Regards
Srikar
