Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab1DSNM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 09:12:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64886 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab1DSNM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 09:12:26 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=ivMq54vb1cIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=AvZSfK5FebFRBBOED8oA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v3 2.6.39-rc1-tip 15/26] 15: uprobes: Handing int3 and
 singlestep exception.
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1303218185.8345.0.camel@twins>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
	 <20110401143527.15455.32854.sendpatchset@localhost6.localdomain6>
	 <1303218185.8345.0.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 19 Apr 2011 09:12:21 -0400
Message-ID: <1303218742.7181.96.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 15:03 +0200, Peter Zijlstra wrote:
> On Fri, 2011-04-01 at 20:05 +0530, Srikar Dronamraju wrote:
> > +       if (unlikely(!utask)) {
> > +               utask = add_utask();
> > +
> > +               /* Failed to allocate utask for the current task. */
> > +               BUG_ON(!utask);
> 
> That's not really nice is it ;-) means I can make the kernel go BUG by
> simply applying memory pressure.

Agreed,

None of these patches should have a single BUG_ON(). They all must fail
nicely.

-- Steve

> 
> > +               utask->state = UTASK_BP_HIT;
> > +       } 


