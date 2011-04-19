Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab1DSG6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:58:53 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60828 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab1DSG6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:58:51 -0400
Date: Tue, 19 Apr 2011 12:15:11 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [PATCH v3 2.6.39-rc1-tip 9/26]  9: uprobes: mmap and fork
 hooks.
Message-ID: <20110419064511.GC10698@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
 <20110401143413.15455.75831.sendpatchset@localhost6.localdomain6>
 <1303144163.32491.875.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1303144163.32491.875.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-04-18 18:29:23]:

> On Fri, 2011-04-01 at 20:04 +0530, Srikar Dronamraju wrote:
> > +               if (vaddr > ULONG_MAX)
> > +                       /*
> > +                        * We cannot have a virtual address that is
> > +                        * greater than ULONG_MAX
> > +                        */
> > +                       continue; 
> 
> I'm having trouble with those checks.. while they're not wrong they're
> not correct either. Mostly the top address space is where the kernel
> lives and on 32-on-64 compat the boundary is much lower still. Ideally
> it'd be TASK_SIZE, but that doesn't work since it assumes you're testing
> for the current task.
> 

Guess I can use TASK_SIZE_OF(tsk) instead of ULONG_MAX ?
I think TASK_SIZE_OF handles 32-on-64 correctly.

-- 
Thanks and Regards
Srikar
