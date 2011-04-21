Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab1DURjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 13:39:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36229 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab1DURjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 13:39:07 -0400
Subject: Re: [PATCH v3 2.6.39-rc1-tip 15/26] 15: uprobes: Handing int3 and
 singlestep exception.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
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
In-Reply-To: <20110421171042.GI10698@linux.vnet.ibm.com>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
	 <20110401143527.15455.32854.sendpatchset@localhost6.localdomain6>
	 <1303218185.8345.0.camel@twins> <20110421171042.GI10698@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 19:41:38 +0200
Message-ID: <1303407698.2035.159.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 22:40 +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2011-04-19 15:03:05]:
> 
> > On Fri, 2011-04-01 at 20:05 +0530, Srikar Dronamraju wrote:
> > > +       if (unlikely(!utask)) {
> > > +               utask = add_utask();
> > > +
> > > +               /* Failed to allocate utask for the current task. */
> > > +               BUG_ON(!utask);
> > 
> > That's not really nice is it ;-) means I can make the kernel go BUG by
> > simply applying memory pressure.
> > 
> 
> The other option would be remove the probe and set the ip to
> the breakpoint address and restart the thread.

While its better than GFP_NOFAIL since its a return to userspace and
hence cannot be holding locks etc.. it's still not pretty. But heaps
better than simply bailing the kernel.



