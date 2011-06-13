Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248Ab1FMJWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 05:22:25 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50009 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab1FMJWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 05:22:23 -0400
Date: Mon, 13 Jun 2011 14:44:47 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 2/22]  2: uprobes: Breakground page
 replacement.
Message-ID: <20110613091447.GE27130@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607125835.28590.25476.sendpatchset@localhost6.localdomain6>
 <1307660612.2497.1774.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1307660612.2497.1774.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-06-10 01:03:32]:

> On Tue, 2011-06-07 at 18:28 +0530, Srikar Dronamraju wrote:
> > +/**
> > + * __replace_page - replace page in vma by new page.
> > + * based on replace_page in mm/ksm.c
> > + *
> > + * @vma:      vma that holds the pte pointing to page
> > + * @page:     the cowed page we are replacing by kpage
> > + * @kpage:    the modified page we replace page by
> > + *
> > + * Returns 0 on success, -EFAULT on failure.
> > + */
> > +static int __replace_page(struct vm_area_struct *vma, struct page *page,
> > +                                       struct page *kpage)
> 
> This is a verbatim copy of mm/ksm.c:replace_page(), I think I can
> remember why you did this, but the changelog utterly fails to mention
> why we need a second copy of this logic (or anything much at all).
> 

__replace_page is not exactly a copy of replace_page. Its a slightly
modified copy of replace_page. Here are the reasons for having this
modified copy instead of using the replace_page.

replace_page was written specifically for ksm purpose by Hugh Dickins.
Also Hugh said he doesnt like replace_page to be exposed for other uses.
He has plans for further modifying replace_page for ksm specific
purposes which might not be aligned to what we are using.

Further for replace_page, its good enuf to call page_add_anon_rmap()
However for uprobes needs we need to call page_add_new_anon_rmap().
page_add_new_anon_rmap() will add the page to the right lru list.

replace_page needs a reference to orig_pte while __replace_page doesnt
need.

I can add the same to Changelog but I am not sure it makes a good
reading. Hence I had skipped it.

-- 
Thanks and Regards
Srikar
