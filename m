Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab1ABMNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 07:13:21 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:38145 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab1ABMNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 07:13:20 -0500
Date: Sun, 2 Jan 2011 07:13:11 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: Anca Emanuel <anca.emanuel@gmail.com>,
        Ubuntu kernel team mailing list 
	<kernel-team@lists.ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: Re: is there a fix for ubuntu with intel GPU booting to blank
 screen?
In-Reply-To: <1293832014.27359.7.camel@maxim-laptop>
Message-ID: <alpine.DEB.2.00.1101020700220.4087@localhost6.localdomain6>
References: <alpine.DEB.2.00.1012270640240.3071@localhost6.localdomain6>  <AANLkTiktLCVQgGPCyt-fwVSkVmr8Ljr08UmvtkNG_zdp@mail.gmail.com>  <alpine.DEB.2.00.1012310836370.23681@localhost6.localdomain6>  <1293814089.6993.4.camel@maxim-laptop> 
 <alpine.DEB.2.00.1012311153190.3495@localhost6.localdomain6> <1293832014.27359.7.camel@maxim-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Dec 2010, Maxim Levitsky wrote:

> On Fri, 2010-12-31 at 12:01 -0500, Robert P. J. Day wrote:
> > On Fri, 31 Dec 2010, Maxim Levitsky wrote:
> >
> > ... snip related to i915 blank screen issues ...
> >
> > > Since you know how to compile kernel, and even have a close working
> > > version, you really should just bisect the bug.
> > >
> > > Bisection is a built-in in the git binary search that allows you to
> > > find the first commit that introduced the bug.
> > >
> > > For example, quick google gives,
> > > http://www.kernel.org/pub/software/scm/git-core/docs/v1.0.13/howto/isolate-bugs-with-bisect.txt
> >
> >   oh, i know how to do bisection but, to be frank, i just don't have
> > the time.  i'm under a brutal deadline for some billable work and,
> > even if i had the time, i suspect that when i eventually tracked down
> > the commit, i probably wouldn't really appreciate what i was looking
> > at, anyway.

> You truly underestimate this. Having commit that broke things points
> perfectly at the issue. Then, developers can even just revert the
> offending commit until it is understood why it breaks stuff.

  i suspect what i'm about to type won't come as a surprise to anyone
currently working on this problem, but there is a cheap workaround to
boot to the command line using one of the offending kernels.

  when i boot, say, 2.6.37-rc8+ (or any other kernel, for that
matter), the first two lines i always see are (paraphrasing):

/dev/pts busy ...
ureadahead info ...

and that's it, just those two lines.  it's the same no matter which
kernel i boot.  and here's where things differ.

  for a properly functioning kernel, the display then switches to
hi-res mode, the two lines are redisplayed in a smaller font and the
boot continues normally, right up to the desktop (say, with my
2.6.37-rc5+ kernel).

  for a bad kernel (say, my 2.6.37-rc8+), it's that switch to hi-res
after those original two lines of output where the display goes black
and stays that way so it looks like a KMS-related problem.

  a workaround to at least let me boot to the command line is to add

  "i915.modeset=0"

as a kernel parm, but that won't then let me start X once i'm up and
running.  there are all sorts of reports of this type of behaviour,
like this:

  https://bbs.archlinux.org/viewtopic.php?id=96759

which is where i got the idea to use that kernel parm and the
behaviour i saw matches exactly what's in that post.  in any event,
as i reported, this is still happening with -rc8.

rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
