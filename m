Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab1KCHrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 03:47:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54144 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab1KCHrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 03:47:43 -0400
Date: Thu, 3 Nov 2011 10:45:06 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
Message-ID: <20111103074506.GB3228@swordfish.minsk.epam.com>
References: <20111020190701.GB3586@swordfish.minsk.epam.com>
 <alpine.DEB.2.00.1110201412070.5552@chino.kir.corp.google.com>
 <20111020212353.GZ25124@google.com>
 <alpine.DEB.2.00.1110201425560.5552@chino.kir.corp.google.com>
 <20111020213644.GB25124@google.com>
 <20111020230040.GC3586@swordfish.minsk.epam.com>
 <alpine.DEB.2.00.1110210212130.12963@chino.kir.corp.google.com>
 <20111021094520.GA9884@zhy>
 <20111103071735.GA3228@swordfish.minsk.epam.com>
 <20111103072705.GA15871@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103072705.GA15871@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/03/11 15:27), Yong Zhang wrote:
> > > A typcal race condition will like this:
> > > 
> > > 	CPU A					CPU B
> > > lock_set_subclass(lockA);
> > >   lock_set_class(lockA);
> > >     lockdep_init_map(lockA);
> > >       /* lockA->name is cleared */
> > >       memset(lockA);
> > > 					__lock_acquire(lockA);
> > > 					  /* lockA->class_cache[] is cleared */
> > > 					  register_lock_class(lockA);
> > > 					    look_up_lock_class(lockA);
> > > 					      WARN_ON_ONCE(class->name !=
> > > 							lock->name);
> > > 
> > >       lock->name = name;
> > > 
> > > And a untested patch is below:
> > > BTW, now the patch could cure (I guess) the very issue reported
> > > in this thread.
> > > But it don't cover the case which change the key and the relevant
> > > lock_class has existed, I don't think out a way how to fix it yet :)
> > > But the fact is we have no such caller yet, the only call site of
> > > lock_set_subclass() is double_unlock_balance().
> > > 
> > 
> > Hello,
> > Any news on this patch? Do you like it or hate it? With recent kernels
> > I'm able to hit this problem more often (several time a day) so if any
> > testing is required I'm willing to help.
> 
> Did you have tried it? Though I don't find time to polish it yet but
> I think will smooth your concern.
> 

I'm compiling the kernel with you patch right now. The whole point was just for
case if someone has different approach or whatsoever.


	Sergey
