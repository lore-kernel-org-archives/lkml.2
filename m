Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843Ab2C3NOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:14:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758592Ab2C3NOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:14:24 -0400
Date: Fri, 30 Mar 2012 15:05:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] uprobes/core: counter to optimize probe hits.
Message-ID: <20120330130530.GA16319@redhat.com>
References: <20120321180811.22773.5801.sendpatchset@srdronam.in.ibm.com> <20120321180826.22773.57531.sendpatchset@srdronam.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321180826.22773.57531.sendpatchset@srdronam.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21, Srikar Dronamraju wrote:
>
> + * uprobe_munmap() decrements the count if
> + * 	- it sees a underlying breakpoint, (via is_swbp_at_addr)
> + * 	  (Subsequent unregister_uprobe wouldnt find the breakpoint
> + * 	  unless a uprobe_mmap kicks in, since the old vma would be
> + * 	  dropped just after uprobe_munmap.)
> + *
> + * register_uprobe increments the count if:
> + * 	- it successfully adds a breakpoint.
> + *
> + * unregister_uprobe decrements the count if:

Cosmetic nit, register_uprobe/unregister_uprobe do not exist.
uprobe_register/unregister.

Oleg.

