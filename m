Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967095Ab2ERTl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 15:41:58 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:47626 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965529Ab2ERTl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 15:41:57 -0400
Date: Fri, 18 May 2012 19:44:17 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [PATCH] vfs: Add setns support for the mount namespace
Message-ID: <20120518194417.GA14195@mail.hallyn.com>
References: <4FAD0524.3000307@parallels.com>
 <4FAD0555.4090906@parallels.com>
 <87mx5e5tho.fsf_-_@xmission.com>
 <4FAE4C70.5000804@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAE4C70.5000804@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@parallels.com):
> On 05/12/2012 12:54 AM, Eric W. Biederman wrote:
> > 
> > setns support for the mount namespace is a little tricky as an arbitrary
> > decision must be made about what to set fs->root and fs->pwd to, as
> > there is no expectation of a relationship between the two mount
> > namespaces.  Therefore I arbitrarily find the root mount point, and
> > follow every mount on top of it to find the top of the mount stack.
> > Then I set fs->root and fs->pwd to that location.  The topmost root of
> > the mount stack seems like a reasonable place to be.
> > 
> > Bind mount support for the mount namespace inodes has the possibility of
> > creating circular dependencies between mount namespaces.  Circular
> > dependencies can result in loops that prevent mount namespaces from
> > every being freed.  I avoid creating those circular dependencies by
> > adding a sequence number to the mount namespace and require all bind
> > mounts be of a younger mount namespace into an older mount namespace.
> > 
> > Add a helper function proc_ns_inode so it is possible to detect when we
> > are attempting to bind mound a namespace inode.
> > 
> > Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> 
> Acked-by: Pavel Emelyanov <xemul@parallels.com>

These patches haven't made it into linux-next or Linus' tree.  (More
worrisome, is that the several online linux-kernel mail archives I've
checked seem to have most of this thread, but not Eric's original
patch.)  What path were they expected to go in by?

thanks,
-serge
