Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab2ALWgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 17:36:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47063 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab2ALWgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 17:36:07 -0500
Date: Thu, 12 Jan 2012 14:35:44 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Theodore Tso <tytso@google.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, Greg KH <greg@kroah.com>,
        Paul Taysom <taysom@chromium.org>, Paul Taysom <taysom@google.com>,
        Olof Johansson <olofj@chromium.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@google.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Fix mod_timer crash when removing USB sticks
Message-ID: <20120112223544.GC18166@google.com>
References: <1326402935-31002-1-git-send-email-taysom@chromium.org>
 <20120112213830.GB17405@kroah.com>
 <20120112215331.GB18166@google.com>
 <CAGagf4dk4KsZSkaWTO9Yegi=_wRJsYBPgfyks1z=wMZJV8gX0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGagf4dk4KsZSkaWTO9Yegi=_wRJsYBPgfyks1z=wMZJV8gX0w@mail.gmail.com>
X-Operating-System: Linux/2.6.38.8-gg683 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso (tytso@google.com) wrote:
> On Thu, Jan 12, 2012 at 4:53 PM, Mandeep Singh Baines <msb@chromium.org>wrote:
> 
> >
> > Hi Greg,
> >
> > What is the conventional way of doing this? There is a lot of good
> > data in the bug report which might be useful to reviewers. We
> > couldn't find a de-facto way of referencing the downstream bug database
> > so we just made up a new field. Sorry. We'll use the correct
> > field name next time.
> >
> 
> There isn't a "correct field name", since it hasn't been standardized.  I
> can tell you as an the ext4 maintainer, I've put things like
> 
> Addresses-Redhat-Bugzilla: <Bugzilla #>
> 
> or
> 
> Addresses-Debian-Bug: <debian-bug-number>
> 

This seems like a good convention. Its also nice in that it scales to
the case where the bug is reported by multiple distros.

For future, we'll use:

Addresses-ChromiumOS-Bug: http://crosbug.com/<Bug #>

I included the URL because its small and folks might not know where
our bug database is.

Regards,
Mandeep

> etc. in commit messages.  I usually put them before the signed-off-block,
> i.e, like this:
> 
> --------
> ext4: a simple commit
> 
> This is the longer commit description, blah, blah, blah.
> 
> Addresses-Redhat-Bugzilla: 12345
> 
> Signed-off-by: Eric Sandeen <....@redhat.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> -----------
> 
> There is some disagreement about whether it's useful to do this for
> bugzilla entries which are not publically available (i.e., protected
> Enterprise Linux bugzillas which have customer information and thus are
> restricted access, or internal Company bug numbers).
> 
> My personal take on this matter is that if an engineer from a particular
> company has taken the time and effort to contribute a bug that fixes a bug
> that they had seen internally, and they include an internal bug number,
> it's presumably to make it easier to track when a particular commit fixing
> a bug that they really care about has hit upstream, and it's in my interest
> to keep the code contributions coming, and it's very little effort to
> include an internal bug tracker reference, even if I don't have personal
> access to said bug tracker;  it's a nice thing I can do that doesn't cost
> much, and may be useful to the original patch submitter.
> 
> Others, including Greg K-H, think it's a horrible thing to do, and will
> reject commits on that basis.
> 
> So it all depends on which subsystem maintainer handles your bug.....  at
> the end, it's up to the maintainer.  I've never had Linus complain to me
> because the commits that I ask him to pull might include "Google-Bug-Id:
> 12345" lines in the commit description.
> 
> -- Ted
> 
> 
> 
> 
> 
> 
> >
> > So what is the correct field name?
> >
> > Regards,
> > Mandeep
> >
> > > And shouldn't this go to the stable kernel releases as well?
> > >
> > > Third time's a charm?
> > >
> > > greg k-h
> >
