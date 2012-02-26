Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab2BZUbF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 15:31:05 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:38874 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab2BZUbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 15:31:03 -0500
Date: Sun, 26 Feb 2012 15:30:50 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Richard Yao <ryao@cs.stonybrook.edu>
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        Henrik Rydberg <rydberg@euromail.se>,
        Bobby Powers <bobbypowers@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120226203050.GA5854@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Richard Yao <ryao@cs.stonybrook.edu>,
	Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
	Henrik Rydberg <rydberg@euromail.se>,
	Bobby Powers <bobbypowers@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Guenter Roeck <guenter.roeck@ericsson.com>,
	Jidong Xiao <jidong.xiao@gmail.com>,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <20120224203715.GA4995@polaris.bitmath.org>
 <20120224205651.GA13333@kroah.com>
 <20120224212238.GA5178@polaris.bitmath.org>
 <20120224213027.GB15735@thunk.org>
 <20120224221459.GA5254@polaris.bitmath.org>
 <CAArOQ2WCXDf2ymxihFdjKhBFMVhtoupVRB97_LsEky4HAGq0hA@mail.gmail.com>
 <20120226104701.GA18152@polaris.bitmath.org>
 <CABDyM6R72WW6YnpNs+EQktaXN_Z_7cxPmABv7ojoLGbmS=+23w@mail.gmail.com>
 <365b85cee33d4f1aadc31336663de21c@HUBCAS2.cs.stonybrook.edu>
 <CABDyM6Q309HeTv3PMc6QaJqGg0MWGV3y2KdeBEKENbD-cCV0Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABDyM6Q309HeTv3PMc6QaJqGg0MWGV3y2KdeBEKENbD-cCV0Sg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 10:05:59AM -0500, Richard Yao wrote:
> >> I do not see what prevents an in-kernel context switch into a ring 3
> >> context with a different process address space. Is it necessary to
> >> remove the code from the kernel tree before someone can do this?
> >
> > No, and that's the real problem here: Everybody who might think it's a
> > good idea may please implement - and thus propose - something concrete,
> > try it out and comeback with experience and performance numbers - and
> > not just try to come up with some theory and other misleading points
> > (what political aspect?!) and ideas what others should do and why it
> > might be better.
> 
> It seems counterproductive to tell people to produce results without
> doing the brainstorming that such results require.

It's also counterproductive to tell kernel programmers how they should
do what they are being paid how to do.  If you just want to brainstorm
possibilities where **you** will do all of the work, as opposed to
asking the kernel development community to work on your pet theories,
it's helpful if you more carefully label your poposals as such.

> If such discussion is not welcome here, then the FreeBSD project has a
> similar kernel design. Perhaps it would be more productive for those
> interested in this to brainstorm on their mailing list. If anything
> materializes, it could be for their kernel instead. Nothing is forcing
> anyone to do things with Linux.

My experience is that most researchers produce code which is not of
production quality.  It's very easy to produce a proof of concept that
works well enough to publish a paper.  Making something which is
actually performant, is **hard**.  The problem is that you don't get
Ph.D.'s for counting cache line misses --- or for getting your
implementation to the point where cache line misses matter in the
first place.  So the threat that Linux will miss out on some great
breakthrough is something that is very hard for me to take seriously,
speaking quite frankly.

Usenix has awarded best paper awards to work that was done on obsolete
kernels, where if the goal of that work was to produce production
kernel code, was in fact horrible work.  But if the goal of that work
is to produce Ph.D. graduates, or to help the professor get tenure,
was perhaps more successful.

That being said, maybe you'd be happier engaging with the Minix 3
community.  They are folks who think (unproven, theoretical) safety is
more important than performance.  And they've created a kernel which
is a 140 times slower at process creation, ten times greater syscall
overhead, and file copies that were two to ten times slower.[1]

[1] http://lwn.net/Articles/220255/

And Prof. Tannenbaum is an academic, so his goals may be more closely
aligned to yours.

Best regards,

	      	   	       	    	   - Ted
