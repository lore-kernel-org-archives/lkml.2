Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2KQC3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 21:29:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab2KQC3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 21:29:08 -0500
Message-ID: <1353119341.2338.1.camel@perseus.themaw.net>
Subject: Re: [PATCH] autofs4 - use simple_empty() for empty directory check
From: Ian Kent <ikent@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Sat, 17 Nov 2012 10:29:01 +0800
In-Reply-To: <20121116173415.GA16916@ZenIV.linux.org.uk>
References: <20121116041523.18624.46918.stgit@perseus.themaw.net>
	 <CA+55aFx-9A0xknhX7z9KmLAoGMf5GXhuFgroZUixHtevGAFsOQ@mail.gmail.com>
	 <1353083773.2332.40.camel@perseus.themaw.net>
	 <CA+55aFz+JUthf-HAdYLzQH=r0niB4+X1ymn5egLpdhiptYXr7w@mail.gmail.com>
	 <20121116173415.GA16916@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 17:34 +0000, Al Viro wrote:
> On Fri, Nov 16, 2012 at 08:43:28AM -0800, Linus Torvalds wrote:
> > On Fri, Nov 16, 2012 at 8:36 AM, Ian Kent <ikent@redhat.com> wrote:
> > >
> > > Sure, are you recommending I alter the fs/libfs.c functions to add a
> > > function that doesn't have the outer lock, and have simple_empty() call
> > > that, then use it in autofs?
> > 
> > Yup. That's the standard pattern, although usually we *strive* to make
> > the unlocked versions be static to the internal code, and then use
> > them there for the various helpers. In your case that seems
> > impossible, since you do depend on holding the d_lock in the caller
> > after the tests. But at least we don't have to duplicate the code and
> > have it in two unrelated places.
> > 
> > Al? Comments?
> 
> The thing is, I'm not convinced we really need ->d_lock held downstream.
> E.g.  __autofs4_add_expiring() ought to be OK with just sbi->lookup_lock.
> Not sure about the situation in autofs4_d_automount() - the thing is messy
> as hell ;-/
> 
> Ian, do we really need that __simple_empty() variant in either caller?  What
> is getting protected by ->d_lock after it and do we really need ->d_lock
> continuously held for that?

Yeah, I've thought about that a few times now but haven't gone so far as
to change it.

I'll have another look.

Ian


