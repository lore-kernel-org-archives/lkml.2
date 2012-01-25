Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab2AYIW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 03:22:28 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:42358 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab2AYIW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 03:22:27 -0500
Date: Wed, 25 Jan 2012 13:42:23 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v9 3.2 2/9] uprobes: handle breakpoint and signal step
 exception.
Message-ID: <20120125081223.GC24766@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120110114821.17610.9188.sendpatchset@srdronam.in.ibm.com>
 <201201180518.31407.vapier@gentoo.org>
 <20120118104749.GG15447@linux.vnet.ibm.com>
 <201201180602.04269.vapier@gentoo.org>
 <CAMjpGUc+V-mrQcBcpyTvhCihYUtd=4Q4Wr6DTsaUwC0JJpBROA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMjpGUc+V-mrQcBcpyTvhCihYUtd=4Q4Wr6DTsaUwC0JJpBROA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012508-3270-0000-0000-0000037A39D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>
> >> One question that could be asked is why arent we using instruction_pointer
> >> instead of GET_IP since instruction_pointer is being defined in 25
> >> places and with references in 120 places.
> >
> > i think you misunderstand the point.  {G,S}ET_IP() is the glue between the
> > arch's pt_regs struct and the public facing API.  the only people who should
> > be touching those macros are the ptrace core.  instruction_pointer() and
> > instruction_pointer_set() are the API that asm/ptrace.h exports to the rest of
> > the tree.
> 
> Srikar: does that make sense ?  i'm happy to help with improving
> asm-generic/ptrace.h.
> -mike
> 

Yes, I think it makes sense. I have modified the code to use
instruction_pointer_set instead of set_instruction_pointer.

-- 
Thanks and Regards
Srikar

