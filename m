Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab1CNRfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:35:01 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43335 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab1CNRfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:35:00 -0400
Date: Mon, 14 Mar 2011 22:59:08 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 1/20]  1: mm: Move replace_page() to
 mm/memory.c
Message-ID: <20110314172908.GP24254@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
 <20110314133413.27435.67467.sendpatchset@localhost6.localdomain6>
 <1300112195.9910.92.camel@gandalf.stny.rr.com>
 <20110314170227.GN24254@linux.vnet.ibm.com>
 <1300122834.9910.126.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1300122834.9910.126.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > As discussed in IRC, moving and removing the static attribute had to
> > be one patch so that mm/ksm.c compiles correctly. The other option we
> > have is to remove the static attribute first and then moving the
> > function.
> 
> Hmm, maybe that may be a good idea. Since it is really two changes. One
> is to make it global for other usages. I'm not even sure why you moved
> it. The change log for the move can explain that.
> 

unlike mm/memory.c; mm/ksm.c is compiled only when CONFIG_KSM is set.
So if we dont move it out of ksm.c; we will have to make uprobes
dependent on CONFIG_KSM. Since replace_page is the only function we are
interested in, its better to move it out of ksm.c, rather than
making uprobes dependent on CONFIG_KSM.


> -- Steve
> 
> > 
> 
