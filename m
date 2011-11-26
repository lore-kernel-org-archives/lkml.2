Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1KZC0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 21:26:53 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51719 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab1KZC0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 21:26:52 -0500
Date: Sat, 26 Nov 2011 07:55:36 +0530
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
        Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH v7 3.2-rc2 9/30] uprobes: Background page replacement.
Message-ID: <20111126022536.GB3291@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
 <20111118110823.10512.74338.sendpatchset@srdronam.in.ibm.com>
 <1322232886.2535.7.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1322232886.2535.7.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112602-8974-0000-0000-0000032C7555
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-11-25 15:54:46]:

> On Fri, 2011-11-18 at 16:38 +0530, Srikar Dronamraju wrote:
> > +static int read_opcode(struct mm_struct *mm, unsigned long vaddr,
> > +                                               uprobe_opcode_t *opcode)
> > +{
> > +       struct page *page;
> > +       void *vaddr_new;
> > +       int ret;
> > +
> > +       ret = get_user_pages(NULL, mm, vaddr, 1, 0, 0, &page, NULL);
> > +       if (ret <= 0)
> > +               return ret;
> > +
> > +       lock_page(page);
> > +       vaddr_new = kmap_atomic(page);
> > +       vaddr &= ~PAGE_MASK;
> 
> BUG_ON(vaddr + uprobe_opcode_sz >= PAGE_SIZE);
> 

Okay, will add BUG_ON.

