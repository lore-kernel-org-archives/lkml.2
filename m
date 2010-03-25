Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab0CYH5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 03:57:01 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:55185 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab0CYH5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 03:57:00 -0400
Date: Thu, 25 Mar 2010 13:26:54 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ulrich Drepper <drepper@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Tom Tromey <tromey@redhat.com>
Subject: Re: [PATCH v1 7/10] Uprobes Implementation
Message-ID: <20100325075654.GA26371@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
 <20100320142617.11427.23852.sendpatchset@localhost6.localdomain6>
 <1269342115.5279.1620.camel@twins>
 <20100323122335.GB26762@linux.vnet.ibm.com>
 <1269352012.5109.22.camel@twins>
 <20100324075815.GC26762@linux.vnet.ibm.com>
 <1269435604.5109.235.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1269435604.5109.235.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > > > > One thing I would like to see is a slot per task, that has a number of
> > > > > advantages over the current patch-set in that it doesn't have one page
> > > > > limit in number of probe sites, nor do you need to insert vmas into each
> > > > > and every address space that happens to have your DSO mapped.
> > > > > 
> > > > 
> > > > where are the per task slots stored?
> > > > or Are you looking at a XOL vma area per DSO?
> > > 
> > > The per task slot (note the singular, each task needs only ever have a
> > > single slot since a task can only ever hit one trap at a time) would
> > > live in the task TLS or task stack.
> > > 
> > 
> > Do we need a buy-in from glibc folks to do this?
> > Also here is what Roland had once said about TLS.
> > 
> > "Next we come to the problem of where to store copied instructions for
> > stepping.  The idea of stealing a stack page for this is a non-starter.
> > For both security and robustness, it's never acceptable to introduce a
> > user mapping that is both writable and executable, even temporarily.  We
> > need to use an otherwise unused page in the address space, that will be
> > read/execute only for the user, we can write to it only from kernel
> > mode."
> 
> Before NX there simply was no option, anyway, I guess the writable
> requirement comes from being stack, and I'm not sure how TLS is done,
> but I guess that has similar constraints on being writable, right?
> 
> I've heard from people that some other OS does indeed have the
> trampoline in TLS.

Ulrich, 

Can you please comment if a slot in TLS can be used for storing and
executing an instruction? Are there any additional issues that we need
to take care of? Are there architectures that dont support TLS?

--
Thanks and Regards
Srikar
