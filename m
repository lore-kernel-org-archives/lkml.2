Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab2GZKTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:19:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab2GZKTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:19:20 -0400
Date: Thu, 26 Jul 2012 12:16:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] uprobes: __replace_page() needs munlock_vma_page()
Message-ID: <20120726101608.GA7197@redhat.com>
References: <20120712170934.GA25455@redhat.com> <20120712171025.GA25510@redhat.com> <20120726051839.GE3810@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120726051839.GE3810@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-07-12 19:10:25]:
>
> > Like do_wp_page(), __replace_page() should do munlock_vma_page()
> > for the case when the old page still has other !VM_LOCKED mappings.
> > Unfortunately this needs mm/internal.h.
> >
> > Also, move put_page() outside of ptl lock. This doesn't really
> > matter but looks a bit better.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> One thing I wanted to check is, should we mlock the new page, i.e the
> replacing page.

Yes, currently page_add_new_anon_rmap() makes it Mlocked/Unevictable.

> It may not a good idea to mlock the new page
> because then we can end up adding too many pages to the unevictable
> list.

Perhaps.

But. I think this is not really important. What is more important,
uprobe_register() should simply not add "too many pages", iow we
should re-use the same page if possible. This was another reason
for (buggy) http://marc.info/?l=linux-kernel&m=134013566617717
I sent before. I'll try to return to this later.

> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks!

Oleg.

