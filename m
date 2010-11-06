Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0KFKpL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 06:45:11 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:39939 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754425Ab0KFKpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 06:45:08 -0400
Date: Sat, 6 Nov 2010 11:44:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Eric Paris <eparis@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, warthog9@kernel.org, jmorris@namei.org,
        kyle@mcmartin.ca, hpa@zytor.com, akpm@linux-foundation.org,
        mingo@elte.hu, viro@zeniv.linux.org.uk,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/4] IMA: making i_readcount a first class inode citizen
Message-ID: <20101106104451.GC11831@ucw.cz>
References: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com>
 <20101028222404.GG2715@dastard>
 <AANLkTimG6o66SFHskkDOtLqYeSzwKt2c0jR3CWe+sd2w@mail.gmail.com>
 <1288305907.3017.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288305907.3017.1.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-10-28 18:45:07, Eric Paris wrote:
> On Thu, 2010-10-28 at 15:29 -0700, Linus Torvalds wrote:
> > On Thu, Oct 28, 2010 at 3:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > Why the wrapper functions and locking? Why not an atomic variable like
> > > i_writecount?
> > 
> > Indeed. With moving this more into the VFS, let's just make sure it
> > looks like i_writecount as much as possible.
> 
> My thought was that the IMA read/write checks should happen AFTER the
> i_writecount and i_readcount counters were updated.  Thus even if we
> raced with another task we can rest assured that the other task would
> catch the situation we missed....

Is not that too late? The other process may have already acted on that data...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
