Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab1JTSz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 14:55:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36767 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1JTSz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 14:55:58 -0400
Date: Thu, 20 Oct 2011 21:53:29 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Borislav Petkov <bp@alien8.de>, David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Tejun Heo <htejun@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
Message-ID: <20111020185329.GA3586@swordfish.minsk.epam.com>
References: <20111015201239.GA3475@swordfish>
 <alpine.DEB.2.00.1110151436420.15894@chino.kir.corp.google.com>
 <20111015222324.GA16432@liondog.tnic>
 <alpine.DEB.2.00.1110151529570.25063@chino.kir.corp.google.com>
 <20111020183913.GA21918@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020183913.GA21918@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/20/11 20:39), Borislav Petkov wrote:
> On Sat, Oct 15, 2011 at 03:32:32PM -0700, David Rientjes wrote:
> > Could you try to revert f59de8992aa6 ("lockdep: Clear whole lockdep_map on 
> > initialization") with this patch and see if it helps?  Thanks.
> > ---
> > diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> > --- a/kernel/lockdep.c
> > +++ b/kernel/lockdep.c
> > @@ -2874,7 +2874,10 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
> >  void lockdep_init_map(struct lockdep_map *lock, const char *name,
> >  		      struct lock_class_key *key, int subclass)
> >  {
> > -	memset(lock, 0, sizeof(*lock));
> > +	int i;
> > +
> > +	for (i = 0; i < NR_LOCKDEP_CACHING_CLASSES; i++)
> > +		lock->class_cache[i] = NULL;
> >  
> >  #ifdef CONFIG_LOCK_STAT
> >  	lock->cpu = raw_smp_processor_id();
> 
> FWIW,
> 
> the box has been running here with f59de8992aa6 reverted for a couple of
> days now and no sign of the warning. I'll keep watching it but it looks
> ok so far, so David, you could've nailed it.
> 

Hello,
Well, the same with me. My laptop has been running with reverted f59de8992aa6 without any
problems so far. Yet, I'm not sure I understand how memset() and loop could
produce different results.

commit in question (f59de8992aa6dc85e81aadc26b0f69e17809721d) has been merge on
Jul 14 15:19:09 2011 +0200, so, Borislav, you probably should have seen it
not only on 3.1-rc5, 3.1-rc6,..., but even on 3.0.


	Sergey
