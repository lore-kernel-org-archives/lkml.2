Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab2DLFCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 01:02:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49970 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab2DLFCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 01:02:52 -0400
Date: Thu, 12 Apr 2012 06:02:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: hlist_for_each_entry && pos (Was: task_work_queue)
Message-ID: <20120412050245.GM6589@ZenIV.linux.org.uk>
References: <20120412024751.GA17561@redhat.com>
 <20120412024810.GA17984@redhat.com>
 <20120412040059.GA20462@redhat.com>
 <CA+55aFyGsA5YPqrymJ8wwoS86SEeJh+X-dvfBTfo3gOTm73JNA@mail.gmail.com>
 <20120412042850.GA22354@redhat.com>
 <CA+55aFzs=DuYibWYMUFiU_R1aJHAr-8hpQhWLew8R5q4nCDraQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzs=DuYibWYMUFiU_R1aJHAr-8hpQhWLew8R5q4nCDraQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 09:39:29PM -0700, Linus Torvalds wrote:

> The sad part is that if we allow that, we also get that *other* insane
> C99 variable thing - mixing variables and code.
> 
> I *like* getting warnings for confused people who start introducing
> variables in the middle of blocks of code. That's not well-contained
> like the loop variable.
> 
> That said, most of the stuff in C99 are extensions that we used long
> before C99, so I guess we might as well just add the stupid flag. And
> discourage people from mixing declarations and code other ways (sparse
> etc).

	Yes, but... -std=gnu99 will break one of your pet extensions -
(struct foo){0,1,2} will cease to be accepted in initializers of
static storage duration objects (and -std=c99 will break a *lot* more
than that).  I wouldn't mind going for that (it's not a terribly large
patch, at least it wasn't about a year ago when I've looked at that),
but IIRC you really insisted on using that one...  It mostly boiled
down to things like
-       .lock           = __SPIN_LOCK_UNLOCKED(init_fs.lock),
+       .lock           = __SPIN_LOCK_INITIALIZER(init_fs.lock),
etc.
