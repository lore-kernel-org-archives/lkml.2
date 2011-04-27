Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074Ab1D0VrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 17:47:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49707 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab1D0VrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 17:47:01 -0400
Date: Wed, 27 Apr 2011 22:46:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
Message-ID: <20110427214657.GE9487@ZenIV.linux.org.uk>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
 <20110427164639.GD9487@ZenIV.linux.org.uk>
 <1303924079.18763.70.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303924079.18763.70.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 01:07:59PM -0400, Steven Rostedt wrote:
> On Wed, 2011-04-27 at 17:46 +0100, Al Viro wrote:
> > On Tue, Apr 26, 2011 at 03:49:49PM -0300, Thiago Farina wrote:
> > > This macro is arguably more readable than its variants:
> > > - !strcmp(a, b)
> > > - strcmp(a, b) == 0
> > 
> > Strongly NACKed.  As far as I'm concerned, it's in the same shitbucket as
> > bcopy(3), bzero(3) et.al.  Use idiomatic C; extensions of that kind are
> > *bad*, since new developers have to learn them.
> 
> What developer has to really learn streq()? I mean it is pretty obvious
> to what it does, as suppose to what bzero and bcopy do. A quick google
> on "streq" brings up lots of matches of people who already do this.

I would.  Coming from BSD background, b* bunch is normal and familiar for
me.  Your streq()...  Nope.  I can use google, but I'd have to stop and
actually do that (and if you bothered to do the same, you would've found
official POSIX manpages for bcopy(3) and friends, complete with
"
    Issue 5

     Moved from X/OPEN UNIX extension to BASE.

    Issue 6

     This function is marked LEGACY.
"
in "CHANGE HISTORY" section.  These are fairly common BSDisms, and if you
grep through drivers/staging you'll find more than one instance in there;
all are deletion fodder).

That's the whole fucking _point_; adding random extensions to the language
leads to the place where Pascal and LISP are and it's not pretty.  Each
might make sense taken separately (hell, bzero(3) would prevent real, honest
to Cthulhu bugs - it's memset(p, 0, n) and we had memset-with-swapped-arguments
bugs fairly often and yes, in our tree most of memset() callers do pass '\0'
as the second argument).  Pile enough of those together and you've got yourself
a dialect only you understand.  _Bad_ idea, since the next thing that happens
is different dialects in different parts of tree.  And the end of non-incestous
code review and fixes.  I've seen it first-hand (OK, second - I had enough
sense to stay out of that particular clusterfuck) on Algol 68 codebase.  I
*really*, *really* do not want to see anything similar ever again.  Especially
on projects I can't just piss upon and walk away from.  The fact that in C
you *can* extend the language that way doesn't make it a good idea.

While we are at it, strcmp() is, indeed, a part of the language.  See
section 7.21.4.2 in C99.
