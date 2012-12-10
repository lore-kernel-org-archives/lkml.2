Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab2LJCon (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 21:44:43 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:30685 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963Ab2LJCol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 21:44:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgLAD1LxVB5LLDt/2dsb2JhbABEhU6zJIV5F3OCHgEBBAE6HCMFCwgDGC4UJQMhE4gLBb8NFIwrhEMDlgWQSYMH
Date: Mon, 10 Dec 2012 13:44:38 +1100
From: Dave Chinner <david@fromorbit.com>
To: Alun <auj@ty-penguin.org.uk>
Cc: Alun <alun.linux@ty-penguin.org.uk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PATCH reduce impact of FIFREEZE on userland processes
Message-ID: <20121210024438.GP15784@dastard>
References: <20121205211707.7ca3b94b@aspire.ty-penguin.org.uk>
 <20121207004255.GC27172@dastard>
 <20121207085952.57ee1f22@pcebbj.staff.aber.ac.uk>
 <20121208012029.GR27172@dastard>
 <20121208084734.36be9360@aspire.ty-penguin.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121208084734.36be9360@aspire.ty-penguin.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2012 at 08:47:34AM +0000, Alun wrote:
> On Sat, 8 Dec 2012 12:20:29 +1100
> Dave Chinner <david@fromorbit.com> wrote:
> 
> First off, thanks for the examples. I'll answer your one question and
> then I'll shut up!
> 
> > > I'll try and chase this up by submitting patches to lvcreate and
> > > fsfreeze (in the former case, I think there's no reason not to run
> > > syncfs; in the latter perhaps it should be a command line option).
> > 
> > Is that even necesary? users can issue the sync themselves if
> > necessary....
> 
> I think it's necessary for the issue to be better documented in LVM at
> the very least. I've dabbled with LVM for nearly 10 years, and used it
> in a busy production environment for around 6. For nearly 2 years I've
> been seeing, every now and then, these odd cases where taking a snapshot
> caused irrecoverable high load on the server.

Irrecoverable in what way?

> I've never seen any
> mention anywhere of the advisability of manually running sync prior to
> taking a snapshot on a busy system, and I had to get down to looking at
> the kernel sources before I got an inkling this might be the issue. I'd
> imagine that the vast majority of end users think the same way as I
> did, viz that taking a snapshot was designed to have minimal effect on
> any other users of the filesystem.

Right - minimal effect, not "no effect".

> There's also the issue that AFAIK there's no commonly distributed
> program which will allow you to call syncfs() on a filesystem. Running
> sync is a bit of a sledgehammer approach for a busy system with
> multiple large filesystems.

I have no doubt that you could write the 20 lines of C code needed
to use syncfs.... ;)

> I've submitted a patch to util-linux, adding a --sync option to
> fsfreeze which, if specified, will syncfs the requested filesystem
> prior to any freeze operation. Hopefully they'll accept this, though
> the only comment I've received so far suggested that I should be
> submitting a kernel patch rather than band aiding it in userland!

Perhaps that tells you something - that both sides are telling you
it's a band aid for your specific issue? :/

fsfreeze is a data integrity operation and some people rely on it to
take immediate effect as it currently does. IMO, that's the bar that
the any generic freeze optimisation has to overcome.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
