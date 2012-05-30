Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab2E3Rjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:39:54 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:51744 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab2E3Rjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:39:52 -0400
Date: Wed, 30 May 2012 23:07:17 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] uprobes: install_breakpoint() should fail if
 is_swbp_insn() == T
Message-ID: <20120530173717.GM15587@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120530165757.GA8077@redhat.com>
 <20120530165816.GA8085@redhat.com>
 <1338398931.28384.7.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1338398931.28384.7.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053017-5518-0000-0000-000004C93984
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > ---
> >  kernel/events/uprobes.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> > index 8c5e043..1593b43 100644
> > --- a/kernel/events/uprobes.c
> > +++ b/kernel/events/uprobes.c
> > @@ -704,7 +704,7 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
> >  			return ret;
> >  
> >  		if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
> > -			return -EEXIST;
> > +			return -ENOTSUPP;
> >  
> >  		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm);
> >  		if (ret)
> 
> IIRC this -EEXIST existed because the vma iteration it does is racy and
> one can encounter the same vma twice or so. See the special -EEXIST
> handling in register_for_each_vma().
> 
> Changing it like this would break stuff. 
> 

Peter, 

is_swbp_insn() is looking at the copy of the instruction thats read from
the file. This path is only taken even before any mm's are inserted with
the breakpoint instruction.

We still check and return -EEXIST if the memory while inserting the breakpoint
instruction  already has a breakpoint.

Hence this change is correct. 

-- 
thanks and regards
Srikar

