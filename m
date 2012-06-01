Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab2FAJIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:08:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45377 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2FAJIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:08:36 -0400
Date: Fri, 1 Jun 2012 02:08:07 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: WARNING: at mm/page-writeback.c:1990
 __set_page_dirty_nobuffers+0x13a/0x170()
In-Reply-To: <4FC88299.1040707@gmail.com>
Message-ID: <alpine.LSU.2.00.1206010204150.8697@eggly.anvils>
References: <20120530163317.GA13189@redhat.com> <20120531005739.GA4532@redhat.com> <20120601023107.GA19445@redhat.com> <alpine.LSU.2.00.1206010030050.8462@eggly.anvils> <4FC88299.1040707@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2012, KOSAKI Motohiro wrote:
> >   	mlock_migrate_page(newpage, page);
> > --- 3.4.0+/mm/page-writeback.c	2012-05-29 08:09:58.304806782 -0700
> > +++ linux/mm/page-writeback.c	2012-06-01 00:23:43.984116973 -0700
> > @@ -1987,7 +1987,10 @@ int __set_page_dirty_nobuffers(struct pa
> >   		mapping2 = page_mapping(page);
> >   		if (mapping2) { /* Race with truncate? */
> >   			BUG_ON(mapping2 != mapping);
> > -			WARN_ON_ONCE(!PagePrivate(page)&&
> > !PageUptodate(page));
> > +			if (WARN_ON(!PagePrivate(page)&&
> > !PageUptodate(page)))
> > +				print_symbol(KERN_WARNING
> > +				    "mapping->a_ops->writepage: %s\n",
> > +				    (unsigned
> > long)mapping->a_ops->writepage);
> 
> type mismatch?

I don't think so: I just copied from print_bad_pte().
Probably you're reading "printk" where it's "print_symbol"?

> I guess you want %pf or %pF.

I expect there is new-fangled %pMagic that can do it too, yes.

Hugh
