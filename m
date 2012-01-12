Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab2ALWMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 17:12:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50525 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab2ALWL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 17:11:57 -0500
MIME-Version: 1.0
In-Reply-To: <20120112215331.GB18166@google.com>
References: <1326402935-31002-1-git-send-email-taysom@chromium.org>
	<20120112213830.GB17405@kroah.com>
	<20120112215331.GB18166@google.com>
Date: Thu, 12 Jan 2012 17:11:54 -0500
Message-ID: <CAGagf4fNhiL9RDsAOk278K5iovg72nvT6ePCN0_18bHOh4d1aA@mail.gmail.com>
Subject: Re: [PATCH] fs: Fix mod_timer crash when removing USB sticks
From: Theodore Tso <tytso@google.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Greg KH <greg@kroah.com>, Paul Taysom <taysom@chromium.org>,
        Paul Taysom <taysom@google.com>, Olof Johansson <olofj@chromium.org>,
        Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@google.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 4:53 PM, Mandeep Singh Baines <msb@chromium.org> wrote:
>
> What is the conventional way of doing this? There is a lot of good
> data in the bug report which might be useful to reviewers. We
> couldn't find a de-facto way of referencing the downstream bug database
> so we just made up a new field. Sorry. We'll use the correct
> field name next time.

There isn't a "correct field name", since it hasn't been standardized.
I can tell you as an the ext4 maintainer, I've put things like:

Addresses-Redhat-Bugzilla: <Bugzilla #>

or

Addresses-Debian-Bug: <debian-bug-number>

etc. in commit messages.  I usually put them before the signed-off-block,
i.e, like this:

--------
ext4: a simple commit

This is the longer commit description, blah, blah, blah.

Addresses-Redhat-Bugzilla: 12345

Signed-off-by: Eric Sandeen <....@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
-----------

There is some disagreement about whether it's useful to do this
for bugzilla entries which are not publically available (i.e., protected
Enterprise Linux bugzillas which have customer information and
thus are restricted access, or internal Company bug numbers).

My personal take on this matter is that if an engineer from a
particular company has taken the time and effort to contribute
a bug that fixes a bug that they had seen internally, and they
include an internal bug number, it's presumably to make it easier
to track when a particular commit fixing a bug that they really
care about has hit upstream.  It costs me very little to keep
the bug tracker reference, even if I don't have personal access
to it, and given the code contributor has helped me by submitting
a bug fix, it's nice to be able to do a little something nice in
return.  The extra line doesn't really bloat the "git log" output
by all that much.

Others, including Greg K-H, think it's a horrible thing to do,
and will reject commits on that basis.

So it all depends on which subsystem maintainer handles
your bug.....  at the end, it's up to the maintainer.  I've never
had Linus complain to me because the commits that I ask him
to pull might include "Google-Bug-Id: 12345" lines in the commit
description.

-- Ted
