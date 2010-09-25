Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab0IYCsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 22:48:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54491 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab0IYCsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 22:48:15 -0400
Date: Sat, 25 Sep 2010 03:48:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Brian Gerst <brgerst@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
        mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: what's papered over by set_fs(USER_DS) in amd64 signal delivery?
Message-ID: <20100925024804.GS19804@ZenIV.linux.org.uk>
References: <20100924155231.GQ19804@ZenIV.linux.org.uk>
 <AANLkTik+1k76vGccjwQWeEWZFng61ZoodDyWbN8wvPgE@mail.gmail.com>
 <20100924165716.GR19804@ZenIV.linux.org.uk>
 <AANLkTikV5O1QxYEHRzZzCrE=VSWj8aV6nA5Z3QOTxtL=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikV5O1QxYEHRzZzCrE=VSWj8aV6nA5Z3QOTxtL=@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 10:25:15PM -0400, Brian Gerst wrote:
> > + ?? ?? ?? ?? ?? ?? ?? __asm__("mov %w0,%%fs ; mov %w0,%%gs":"=r" (seg) :"0" (seg));
> > + ?? ?? ?? ?? ?? ?? ?? set_fs(seg);
> > + ?? ?? ?? ?? ?? ?? ?? regs->xds = seg;
> > + ?? ?? ?? ?? ?? ?? ?? regs->xes = seg;
> > + ?? ?? ?? ?? ?? ?? ?? regs->xss = seg;
> > + ?? ?? ?? ?? ?? ?? ?? regs->xcs = USER_CS;
> > in 2.1.2. ??And that's when we had
> > ?? ?? ?? ??* fs and gs evicted from pt_regs
> > ?? ?? ?? ??* fs and gs not saved restored on kernel entry/exit
> > ?? ?? ?? ??* just introduced set_fs() to start with (that went in 2.1.0)
> >
> > A bit before my time, so I'm not sure what's been going on there...
> 
> I believe it can be safely removed.  Looking through the history, the
> corresponding set_fs() calls were removed from 32-bit by commit
> b93b6ca3.  This is just an artifact from ancient i386 code where
> set_fs (which is grossly misnamed now) really did set the %fs
> register.

Not quite.  If you look at the tree where it has shown up (2.1.2), you'll see
that
	a) by that time it _wasn't_ an assignment to %fs
	b) the same patch that has introduced that call there does direct
assignment to %fs right next to that set_fs().  See that __asm__ above?

Again, I agree that it almost certainly can be dropped.  I really wonder
about the history, though.  It predates git and bk by far (late 1996).
Linus, do you have any recollection regarding that stuff?
