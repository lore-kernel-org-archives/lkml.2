Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab1K3M0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 07:26:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38257 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab1K3M0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 07:26:06 -0500
Message-ID: <1322655933.2921.271.camel@twins>
Subject: Re: [PATCH v7 3.2-rc2 4/30] uprobes: Define hooks for mmap/munmap.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
Date: Wed, 30 Nov 2011 13:25:33 +0100
In-Reply-To: <20111129162237.GA18380@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111118110723.10512.66282.sendpatchset@srdronam.in.ibm.com>
	 <1322071812.14799.87.camel@twins>
	 <20111124134742.GH28065@linux.vnet.ibm.com>
	 <1322492384.2921.143.camel@twins>
	 <20111129083322.GD13445@linux.vnet.ibm.com>
	 <1322567326.2921.226.camel@twins>
	 <20111129162237.GA18380@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 21:52 +0530, Srikar Dronamraju wrote:
> The rules that I am using are: 
> 
> mmap_uprobe() increments the count if 
>         - it successfully adds a breakpoint.
>         - it not add a breakpoint, but sees that there is a underlying
>           breakpoint (via a read_opcode call).
> 
> munmap_uprobe() decrements the count if 
>         - it sees a underlying breakpoint,  (via  a read_opcode call)
>         - Subsequent unregister_uprobe wouldnt find the breakpoint
>           unless a mmap_uprobe kicks in, since the old vma would be
>           dropped just after munmap_uprobe.
> 
> register_uprobe increments the count if:
>         - it successfully adds a breakpoint.
> 
> unregister_uprobe decrements the count if:
>         - it sees a underlying breakpoint and removes successfully. 
>                         (via a read_opcode call)
>         - Subsequent munmap_uprobe wouldnt find the breakpoint
>           since there is no underlying breakpoint after the
>           breakpoint removal. 

The problem I'm having is that such stuff isn't included in the patch
set.

We've got both comments in the C language and Changelog in our patch
system, yet you consistently fail to use either to convey useful
information on non-trivial bits like this.

This leaves the reviewer wondering if you've actually considered stuff
properly, then me actually finding bugs in there does of course
undermine that even further.

What I really would like is for this patch set not to have such subtle
stuff at all, esp. at first. Once its in and its been used a bit we can
start optimizing and add subtle crap like this.


