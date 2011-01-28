Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282Ab1A1FEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 00:04:10 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51334 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab1A1FEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 00:04:08 -0500
Date: Fri, 28 Jan 2011 10:27:21 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Roland McGrath <roland@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 13/20] 13: x86: x86 specific probe
 handling
Message-ID: <20110128045721.GV19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216095947.23751.75003.sendpatchset@localhost6.localdomain6>
 <1295963783.28776.1061.camel@laptop>
 <20110127094041.GR19725@linux.vnet.ibm.com>
 <1296123733.15234.53.camel@laptop>
 <20110127191146.DB22F180999@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110127191146.DB22F180999@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

> > But I'll leave this to the x86 people who actually know the intricacies
> > of the single step cruft, I was just wondering why you weren't using (or
> > extending) the existing code.
> 
> The hairy aspects of the step.c code are hairy (and not usable at interrupt
> level) because they do some instruction analysis.  Since uprobes already
> does its own instruction analysis, reusing step.c's separate hacks makes
> less sense to me than integrating knowledge of the single-step vs
> pushf/popf issues into the uprobes instruction analysis.
> 
> That said, there is further nontriviality just to do with the block-step
> support and with not clobbering user-visible usage of TF in eflags, which
> uprobes needs to handle as well.  It makes sense to share that code rather
> than repeating it, even if that entails changes to the step.c code.
> 

Uprobes doesn't request/handle block-step for now. So can we postpone
your suggested changes till uprobes needs to handle block-step?

-- 
Thanks and Regards
Srikar

