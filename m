Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab2E0Wpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 18:45:52 -0400
Received: from ozlabs.org ([203.10.76.45]:58286 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab2E0Wpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 18:45:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
In-Reply-To: <5107.1337868051@redhat.com>
References: <8762blyedn.fsf@rustcorp.com.au> <87obpfxdpr.fsf@rustcorp.com.au> <20120522230218.24007.3556.stgit@warthog.procyon.org.uk> <7474.1337782847@redhat.com> <5107.1337868051@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sun, 27 May 2012 15:11:23 +0930
Message-ID: <87r4u6w58c.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012 15:00:51 +0100, David Howells <dhowells@redhat.com> wrote:
> It doesn't really need the @ signs or the MSIZE; they can be dropped.
...
> That then adds 5 bytes to the magic string.  Is that really so bad?

Yes, because it's unnecessary.

Now you've decided to encode some data, you need to decide how.  And you
discovered that they all sucked in different ways.  Binary is a PITA for
the shell, so you chose to put ASCII (in the middle of an
otherwise-binary blob).  Then you chose a fixed length with space-based
padding as the least of all evils.

But it's still completely tasteless.

Sure, my code didn't even compile.  And yes, it takes about 70ms on an
8M file on my laptop, and yes, that drops to about 6ms if we check one
char manually.  It would drop further if we searched forwards, using
memchr then memcmp, but it's already below my care factor.

> > > Why would you want multiple signatures?  That just complicates things.
> > 
> > The code above stays pretty simple; if the signature fails, you set size
> > to i, and loop again.  As I said, if you know exactly how you're going
> > to strip the modules, you can avoid storing the stripped module and
> > simply append both signatures.
> 
> You still haven't justified it.  One of your arguments about rejecting the ELF
> parsing version was that it was too big for no useful extra value that I could
> justify.  Supporting multiple signatures adds extra size and complexity for no
> obvious value.

One loop is a lot easier to justify that the ELF-parsing mess.  And it
can be done in a backwards compatible way tomorrow: old kernels will
only check the last signature.

I had assumed you'd rather maintain a stable strip util which you can
use on kernel modules than rework your module builds.  I guess not.

Cheers,
Rusty.
