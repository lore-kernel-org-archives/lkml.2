Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab1FPMgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:36:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37360 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab1FPMgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:36:11 -0400
Subject: Re: [PATCH v4 3.0-rc2-tip 13/22] 13: uprobes: Handing int3 and
 singlestep exception.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110616120442.GA4093@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
	 <20110607130051.28590.68088.sendpatchset@localhost6.localdomain6>
	 <1308225141.13240.25.camel@twins>
	 <20110616120442.GA4093@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Jun 2011 14:35:24 +0200
Message-ID: <1308227724.13240.58.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 17:34 +0530, Srikar Dronamraju wrote:
> > > +
> > > +cleanup_ret:
> > > +       if (u) {
> > > +               down_read(&mm->mmap_sem);
> > > +               if (!set_orig_insn(current, u, probept, true))
> > 
> > we try to undo the probe? That doesn't make any sense. I thought you
> > meant to return to userspace, let it re-take the trap and try again
> > until you do manage to allocate the user resource.
> 
> I meant removing the probe itself
> https://lkml.org/lkml/2011/4/21/279
> 
> We could try reseting and retrying the trap. Just that we might end up
> looping under memory pressure.
> 
> > 
> > This behaviour makes probes totally unreliable under memory pressure. 
> 
> Under memory pressure we could be unreliable. 

But that is total crap, there's nothing worse than unreliable debug
tools.


