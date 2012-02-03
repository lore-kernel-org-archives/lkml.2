Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab2BCO6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:58:05 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:59679 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab2BCO6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:58:03 -0500
Date: Fri, 3 Feb 2012 09:57:44 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joel Becker <jlbec@evilplan.org>, David Miller <davem@davemloft.net>
Subject: Re: [RFC] killing boilerplate checks in ->link/->mkdir/->rename
Message-ID: <20120203145744.GN16796@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joel Becker <jlbec@evilplan.org>,
	David Miller <davem@davemloft.net>
References: <m14nvc82jo.fsf@fess.ebiederm.org>
 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org>
 <m1ehueyz20.fsf_-_@fess.ebiederm.org>
 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
 <20120202012258.GQ23916@ZenIV.linux.org.uk>
 <20120202212400.GR23916@ZenIV.linux.org.uk>
 <CA+55aFzHSv2eHKenVhxnSFMJMXtJCnxD2xu6QjMiMLEGLCZ2uQ@mail.gmail.com>
 <20120203011612.GS23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203011612.GS23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4F2BF5F0.0034,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 01:16:12AM +0000, Al Viro wrote:
> On Thu, Feb 02, 2012 at 03:46:06PM -0800, Linus Torvalds wrote:
> > On Thu, Feb 2, 2012 at 1:24 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > Comments? ?Boilerplate removal follows (22 files changed, 45 insertions(+),
> > > 120 deletions(-)), but it's *not* for immediate merge; it's really completely
> > > untested.
> > 
> > Looks ok to me. Historically, the more things we can check at the VFS
> > layer, the better.
> 
> 
> 	* what's up with btrfs_insert_inode_ref()?  I've tried to trace
> the codepaths around there, but...

Btrfs stores backrefs (the filename, directory inode number) from the
inode to the directory.

In the current format that's a pretty low limit on how many of these we
can store for hard links to the same file in the same directory, but
basically no limit on how many backrefs we can store to the same file
from different directories.

Mark Fasheh was working on a patch to change the backrefs to make the
links-from-the-same-dir case consistent with the
links-from-different-dir case.   With today's code, we'll go -EMLINK at
different times depending on the length of the file name and what links
you've already made.


> Incidentally, when could fixup_low_keys()
> return non-zero?  I don't see any candidates for that in there...  Chris?

A long time ago this one used to cow blocks and so it needed an error
return.  I think Jeff Mahoney has a patch queued up to make it (among
many others) void.

-chris
