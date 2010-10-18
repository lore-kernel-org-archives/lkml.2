Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab0JROPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:15:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab0JROPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:15:34 -0400
Date: Mon, 18 Oct 2010 10:14:55 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/9] jump label: Fix module __init section race
Message-ID: <20101018141454.GB2814@redhat.com>
References: <20101015200949.134732894@goodmis.org> <20101015201036.445509790@goodmis.org> <1287194942.16971.39.camel@gandalf.stny.rr.com> <20101016062304.GA10748@elte.hu> <1287246199.16971.54.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287246199.16971.54.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 12:23:19PM -0400, Steven Rostedt wrote:
> On Sat, 2010-10-16 at 08:23 +0200, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > On Fri, 2010-10-15 at 16:09 -0400, Steven Rostedt wrote:
> > > 
> > > > --- a/kernel/jump_label.c
> > > > +++ b/kernel/jump_label.c
> > > > @@ -168,7 +168,8 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
> > > >  			count = e_module->nr_entries;
> > > >  			iter = e_module->table;
> > > >  			while (count--) {
> > > > -				if (kernel_text_address(iter->code))
> > > > +				if (iter->key &&
> > > > +						kernel_text_address(iter->code))
> > > 
> > > Peter, I know you hated this, but the alternative is either:
> > > 
> > > 				if (iter->key &&
> > > 				    kernel_text_address(iter->code))
> > > 
> > > or break 80 chars. All three seem bad (although I don't mind breaking 
> > > 80 chars for this). But I'll leave it for now.
> > 
> > No, the proper alternative is to move the body of the iteration into a 
> > jump_label_update_entry() inline function ...
> > 
> > Nobody is forcing you to start yet another iteration 4 indentations 
> > deep. We have functions for a reason.
> 
> Jason,
> 
> Could you send me another version of this patch with the second
> iteration wrapped in a function.
> 
> Thanks,
> 
> -- Steve
> 
> 

sure. I going to re-spin this whole series - there are a bunch of
changes. Hopefully, I can drop the whole register/unregister notion as
Peter suggested.

thanks,

-Jason
