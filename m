Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab1EXSQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:16:25 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45491 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab1EXSQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:16:23 -0400
Date: Tue, 24 May 2011 14:16:19 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Richard Yao <ryao@ic.sunysb.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: UNIX Compatibility
Message-ID: <20110524181619.GC26055@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Richard Yao <ryao@ic.sunysb.edu>, linux-kernel@vger.kernel.org
References: <BANLkTin4wu1HNDeo8Rv7iddM9KkgZdhfgA@mail.gmail.com>
 <A7E21A2F-4338-465D-933A-66B0C4D15BE1@mit.edu>
 <BANLkTi=q7tDVkahrnng7+BJhvxh=gx71ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=q7tDVkahrnng7+BJhvxh=gx71ng@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:49:26AM -0400, Richard Yao wrote:
> 
> With that out of the way, I am under the impression that the Linux
> kernel code is in some way incompatible with the Single Unix
> Specification (i.e. the thing required for an OS to be certified as
> being UNIX). So far, the only kernel code of which I am aware that
> could possibly be incompatible is code involving error codes, but
> after reading your email, I realize that I am not sure if having those
> match the UNIX System V error is a requirement for the specification.

The Single Unix Specification is a API specification, not an ABI
specification.  So no, it doesn't specify the precise numeric
assignments of EINVAL, ENOSPC, etc.

> I have always heard that Linux was almost compatible with UNIX, but
> not quite compatible; yet no one ever seems to enumerate the reasons
> for that. I know that the GNU userland that typically accompanies the
> Linux kernel in Linux distributions is not UNIX compatible (e.g.
> blocks are not 512 bytes).

No one ever bothers to deal with issues because they are tiny,
nit-pitcky things that no one other than standards mavens would care
about.  You have to be someone who is extremely anal to really care
about this kind of stuff.  It's really stupid stuff --- for example,
if you call unlink() on a directory, POSIX and the Single Unix
Specification requires that a conforming operating system return
EPERM.  Linux returns the error code EISDIR instead, and Al Viro has
explicitly stated that we're not going to change this just to keep
some paper pushers happy.

If you want to waste time out of your life that you'll never get back,
you can see more details of this kind of stuff here:

    http://www.opengroup.org/personal/ajosey/tr11-11-2005.txt

There has been some talk that the standards committee would make
changes to the standard to recognize what the dominant implementation
(i.e,. Linux) actually does (because standards committee, as full of
ivory-tower eggheads as it is, does have some folks who recognize that
there is such a thing as the Real World).  However, at this point, it
seems very unlikely this will happen, because (a) one really cares
about POSIX/SUS compatibility since no one, including governments, are
requiring POSIX compatibility in their purchasing decisions these days
--- Linux has had no problems getting acquired and used in governments
all over the world, and (b) the companies who used pay $$$$ to fund
standards folks to fly all over the world to have standards meetings,
aren't funding this sort of thing any more, because of (a).

> I would like to know if there is anything in the kernel code itself
> that would need to change for people to say that Linux is a UNIX
> kernel minus the external factors (i.e. a UNIX userland and
> certification) needed to be an official UNIX kernel. If there are any
> long standing differences, now would be a good time to discuss
> resolving them considering the proposed Linux 3.0 change.

Not going to happen.  Some of these changes are things where we
fundamentally believe that the Linux behaviour is more technically
correct.

And there's no point in trying for what you are calling "Unix
compatibility"; the Single Unix Specification leaves a lot of things
undefined, so multiple Legacy Unix systems (i.e, Solaris, AIX, HPUX)
can all be conformant to the POSIX/SUS standards, but applications
will still need to do significant porting between two UNIX systems.

So why do it?

> By the way, with regard to the error codes, Groklaw has an article
> enumerating the differences from UNIX System V:
> 
> http://www.groklaw.net/articlebasic.php?story=20040221192536920
> 
> It seems Linus Torvalds wanted to use the UNIX System V call codes
> when he was working on Linux 0.0.1, but he lacked a reference at the
> time, so he only got them partially right.

No, Linus originally wanted to be binary compatible with MINIX.  What
makes you think there was any intention to be Unix System V
compatible?  It's simply not true.  Just to give one example, Unix
System V used AT&T Streams for its networking interface, which was a
disaster, and Linux doesn't even bother to try to support Streams; we
use the BSD socket interface instead.

						- Ted
