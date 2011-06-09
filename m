Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab1FIVHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:07:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753837Ab1FIVHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:07:43 -0400
Date: Thu, 9 Jun 2011 14:07:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        efault@gmx.de, Arne Jansen <lists@die-jansens.de>
Subject: Re: [PATCH 1/3] printk: Release console_sem after logbuf_lock
Message-Id: <20110609140714.fc9ea187.akpm@linux-foundation.org>
In-Reply-To: <1307652883.2497.1028.camel@laptop>
References: <20110609130647.937204592@chello.nl>
	<20110609131307.493181962@chello.nl>
	<20110609130617.f8aca966.akpm@linux-foundation.org>
	<20110609202707.GA28951@elte.hu>
	<1307652883.2497.1028.camel@laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Jun 2011 22:54:43 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2011-06-09 at 22:27 +0200, Ingo Molnar wrote:
> 
> > > > @@ -1271,8 +1273,8 @@ void console_unlock(void)
> > > >  	if (unlikely(exclusive_console))
> > > >  		exclusive_console = NULL;
> > > >  
> > > > -	up(&console_sem);
> > > >  	spin_unlock_irqrestore(&logbuf_lock, flags);
> > > > +	up(&console_sem);
> > > >  	if (wake_klogd)
> > > >  		wake_up_klogd();
> > > >  }
> > > 
> > > I have a horrible feeling that I put the up() inside logbuf_lock for
> > > Special And Cunning Reasons.  But I'm struggling to work out what they
> > > might have been and my archives only go back to October 2000(!).
> > > 
> > > Hate it when that happens.
> > 
> > Heh, here's what i told Peter two days ago when i saw that chunk:
> > 
> >   => Subject: printk: Release console_sem after logbuf_lock
> >   => i have some vague memories about some sort of complication in that area ...
> >   => but don't remember the specifics
> >   => only a 'there be dragons' mental marker
> 
> Right, my reply was that I couldn't convince myself unlock order could
> make a difference, but clearly I can easily have missed something
> subtle.

I wish I could find the darned patch.  I have a file here
no-console-lock-2.patch which was last diffed on October 7, 1999 but it
has no changelog :(

But this:
http://lkml.indiana.edu/hypermail/linux/kernel/0109.2/0127.html is Sep
2001 and I have an earlier (unchangelogged) no-console-lock.patch diffed
against 2.4.2 in March 2001.

It's odd that the patch (and changelog) don't appear in my lkml
archives.  Sigh, http://www.youtube.com/watch?v=oO3YmT2d-8k


