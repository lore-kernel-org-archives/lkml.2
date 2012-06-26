Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632Ab2FZPt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 11:49:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758515Ab2FZPt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 11:49:57 -0400
Date: Tue, 26 Jun 2012 17:47:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] uprobes: __replace_page() needs
	munlock_vma_page()
Message-ID: <20120626154736.GA16141@redhat.com>
References: <20120624145936.GA23269@redhat.com> <20120624150111.GE23277@redhat.com> <20120626115514.GA16794@bandura.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120626115514.GA16794@bandura.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, Anton Arapov wrote:
>
> On Sun, Jun 24, 2012 at 05:01:11PM +0200, Oleg Nesterov wrote:
> > Like do_wp_page(), __replace_page() should do munlock_vma_page()
> > for the case when the old page still has other !VM_LOCKED mappings.
> > Unfortunately this needs mm/internal.h.
> >
> > --- a/kernel/events/uprobes.c
> > +++ b/kernel/events/uprobes.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/swap.h>		/* try_to_free_swap */
> >  #include <linux/ptrace.h>	/* user_enable_single_step */
> >  #include <linux/kdebug.h>	/* notifier mechanism */
> > +#include "../../mm/internal.h"	/* munlock_vma_page */
>
>   We have vma_adress() defined in internal.h, under #ifdef CONFIG_TRANSPARENT_HUGEPAGE .
>
>   NAK. :-)

Damn you Anton ;) You seem to dislike number 5...

OK, please ignore this patch.


Can't resist. I swear, I specially checked mm/internal.h to ensure
it doesn't export mm/rmap.c:vma_address(), can't understand how I
didn't notice this declaration.

Oleg.

