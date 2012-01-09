Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab2AILcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 06:32:35 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:53384 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab2AILce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 06:32:34 -0500
Date: Mon, 9 Jan 2012 16:54:27 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH v8 3.2.0-rc5 9/9] perf: perf interface for uprobes
Message-ID: <20120109112427.GB10189@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111216122756.2085.95791.sendpatchset@srdronam.in.ibm.com>
 <20111216122951.2085.95511.sendpatchset@srdronam.in.ibm.com>
 <4F06D22D.9060906@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4F06D22D.9060906@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12010911-5518-0000-0000-0000016C3372
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > +
> > +static int convert_to_perf_probe_point(struct probe_trace_point *tp,
> > +					struct perf_probe_point *pp)
> > +{
> > +	pp->function = strdup(tp->symbol);
> > +	if (pp->function == NULL)
> > +		return -ENOMEM;
> > +	pp->offset = tp->offset;
> > +	pp->retprobe = tp->retprobe;
> > +
> > +	return 0;
> > +}
> 
> This function could be used in kprobe_convert_to_perf_probe() too.
> In that case, it will be separated as a cleanup from this.

Do you really want this in a separate patch, since it doesnt make too
much sense without the uprobes code.

-- 
Thanks and Regards
Srikar

