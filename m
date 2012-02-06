Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab2BFWtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:49:46 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:17713 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754709Ab2BFWtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:49:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQEAOxWME95LD+bgWdsb2JhbABDr0QjAQEWJiWBcgEBBAEnExwjBQsIAxguFCUDIROHfLh8E4shAgIJBQwHBgELAQgFAwMJBgQPAwOEHgEDAQSCdGMElSeScA
Date: Tue, 7 Feb 2012 09:49:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joel Becker <jlbec@evilplan.org>, Chris Mason <chris.mason@oracle.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [RFC] killing boilerplate checks in ->link/->mkdir/->rename
Message-ID: <20120206224941.GA20305@dastard>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 01:16:12AM +0000, Al Viro wrote:
> On Thu, Feb 02, 2012 at 03:46:06PM -0800, Linus Torvalds wrote:
> > On Thu, Feb 2, 2012 at 1:24 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> 	* WTF is XFS doing with these checks?

It is validating nlink against the maximum supported by the XFS
on-disk format. It was originally limited by what could be reported
to pathconf() on Irix - a signed int.  We have that same problem on
Linux, too, because on 32 bit systems the maximum number of links
that can be reported via pathconf is 2^31....

> 	Note that we have them
> done _twice_ on all paths - explictly from xfs_create(), xfs_link(),
> xfs_rename() and then from xfs_bumplink() called by exactly the same
> set of functions.

Well, that's a bit stupid, isn't it? Trivial to fix, though...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
