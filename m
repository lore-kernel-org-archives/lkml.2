Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab1FMJbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 05:31:17 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40028 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab1FMJbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 05:31:15 -0400
Date: Mon, 13 Jun 2011 14:53:39 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 0/22]  0: Uprobes patchset with perf
 probe support
Message-ID: <20110613092339.GF27130@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <1307644944.2497.1023.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1307644944.2497.1023.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-06-09 20:42:24]:

> On Tue, 2011-06-07 at 18:28 +0530, Srikar Dronamraju wrote:
> > - Breakpoint handling should co-exist with singlestep/blockstep from
> >   another tracer/debugger.

We can remove this now.
Previous to this patchset the post notifier would run in interrupt
context hence we couldnt call user_disable_single_step

However from this patchset, (due to changes to do away with per task
slot), we run the post notifier in task context. Hence we can now call
user_enable_single_step/user_disable_single_step which does the right
thing. 

Please correct me if I am missing.

> > - Queue and dequeue signals delivered from the singlestep till
> >   completion of postprocessing. 
> 

I am working towards this.  
> These two are important to sort before we can think of merging this
> right?
> 

-- 
Thanks and Regards
Srikar

