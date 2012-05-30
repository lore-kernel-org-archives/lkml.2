Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2E3U4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:56:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34406 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab2E3U4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:56:17 -0400
Date: Wed, 30 May 2012 21:56:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
Message-ID: <20120530205612.GY11775@ZenIV.linux.org.uk>
References: <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
 <20120516004251.GO22082@ZenIV.linux.org.uk>
 <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
 <20120516021828.GP22082@ZenIV.linux.org.uk>
 <1337807899.15138.31.camel@falcor>
 <20120530043443.GA3200@ZenIV.linux.org.uk>
 <20120530163605.GV11775@ZenIV.linux.org.uk>
 <1338406967.2257.24.camel@localhost>
 <20120530202427.GW11775@ZenIV.linux.org.uk>
 <CA+55aFxiCksfNdRrm+O-eJSY=qTUQEsZtFbi8wj2_kj1XeNHnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxiCksfNdRrm+O-eJSY=qTUQEsZtFbi8wj2_kj1XeNHnQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 01:28:09PM -0700, Linus Torvalds wrote:
> On Wed, May 30, 2012 at 1:24 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Wed, May 30, 2012 at 03:42:47PM -0400, Eric Paris wrote:
> >> security_file_mmap() would pretty much only be used in do_mmap_pgoff()
> >> (or validate_mmap_request)
> >
> > Callers, actually - the whole point is to lift it out of under ->mmap_sem.
> > The tricky part is reqprot vs. prot mess.
> 
> See how I solved reqprot vs prot in my suggested original patch. You
> have it somewhere in your inbox, I know, because you called me out on
> the fact that my original email forgot to attach it ;)
> 
> It actually cleaned things up, and made the calling conventions
> simpler. Just always pass in "reqprot", and have the security layer do
> the trivial "calculate final prot".

If only it would be trivial ;-/  Take a look at !MMU case (or at the
description in the posting upthread if you want to avoid seeing your
breakfast one more time - the code in validate_mmap_request() is
really ugly).
