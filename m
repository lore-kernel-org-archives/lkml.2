Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab1LAN02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 08:26:28 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:56125 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab1LAN00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 08:26:26 -0500
Date: Thu, 1 Dec 2011 18:54:06 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>, tulasidhard@gmail.com
Subject: Re: [PATCH v7 3.2-rc2 4/30] uprobes: Define hooks for mmap/munmap.
Message-ID: <20111201132406.GI18380@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111118110723.10512.66282.sendpatchset@srdronam.in.ibm.com>
 <1322071812.14799.87.camel@twins>
 <20111124134742.GH28065@linux.vnet.ibm.com>
 <1322492384.2921.143.camel@twins>
 <20111129083322.GD13445@linux.vnet.ibm.com>
 <1322567326.2921.226.camel@twins>
 <20111129162237.GA18380@linux.vnet.ibm.com>
 <1322655933.2921.271.camel@twins>
 <20111201054018.GC18380@linux.vnet.ibm.com>
 <1322739387.4699.10.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1322739387.4699.10.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11120113-1780-0000-0000-0000015801C4
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000235; HX=3.00000178; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00092345; UDB=6.00024445; UTC=2011-12-01
 13:26:24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I was following the general convention being used within the kernel to not
> > bother about the area that we are going to unmap. For example: If a ptraced
> > area were to be unmapped or remapped, I dont see the breakpoint being
> > removed and added back. Also if a ptrace process is exitting, we dont go
> > about removing the installed breakpoints.
> > 
> > Also we would still need the check for EEXIST and read_opcode for handling
> > the fork() case. So even if we add extra line to remove the actual
> > breakpoint in munmap, It doesnt make the code any more simpler.
> 
> Not adding the counter now does though. The whole mm->mm_uprobes_count
> thing itself is basically an optimization.
> 
> Without it we'll get to uprobe_notify_resume() too often, but who cares.
> And not having to worry about it removes a lot of this complexity.
> 
> Then in the patch where you introduce this optimization you can list all
> the nitty gritty details of mremap/fork and counter balancing.
> 

Okay, I will move the optimization parts into a separate patch and keep
it at the end of the patchset.

> Another point, maybe add some comments on how the generic bits of
> uprobe_notify_resume()/uprobe_bkpt_notifier()/uprobe_post_notifier() etc
> hang together and what the arch stuff should do. 
> 
> Currently I have to flip back and forth between those to figure out what
> happens.
> 
> Having that information also helps validate that x86 does indeed do what
> is expected and helps other arch maintainers write their code without
> having to grok wtf x86 does.
> 

Okay, will work towards this.

-- 
Thanks and Regards
Srikar

