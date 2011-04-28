Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab1D1XW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 19:22:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42079 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1D1XWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 19:22:24 -0400
Date: Thu, 28 Apr 2011 16:22:10 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Andrea Righi <andrea@betterlinux.com>
Cc: Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] drop_pagecache syscall
Message-ID: <20110428232210.GA4132@noexit.corp.google.com>
Mail-Followup-To: Andrea Righi <andrea@betterlinux.com>,
	Dave Chinner <david@fromorbit.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1303853727-21444-1-git-send-email-andrea@betterlinux.com>
 <20110427001453.GD12436@dastard>
 <20110427085910.GA1749@linux.betterlinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110427085910.GA1749@linux.betterlinux.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 11:01:28AM +0200, Andrea Righi wrote:
> On Wed, Apr 27, 2011 at 10:14:53AM +1000, Dave Chinner wrote:
> > On Tue, Apr 26, 2011 at 11:35:27PM +0200, Andrea Righi wrote:
> > > Introduce sys_drop_pagecache() system call to drop the page cache pages of
> > > a single filesystem.
<snip>
> > > This functionality can be used by all the applications that want to have a
> > > better control over the page cache management (for example to immediately drop
> > > pages that for sure will not be reused in the near future, without calling
> > > posix_fadvise() for all the files they've touched), or to provide a more fine
> > > grained debugging feature usable by the filesystem benchmarks.
> > > 
> > > The system call does not require root privileges and it can be called by any
> > > unprivileged application. For example, we can write a userspace tool to run
> > > something like this:
> > > 
> > >   $ drop-pagecache /path/file_or_dir
> > 
> > That's a potential DOS vector, I think. Drop the pagecache in a hard
> > loop on the root fs of a busy server and watch it crawl...
> 
> Yes, probably we could allow only the CAP_SYS_ADMIN tasks to execute
> this syscall.

	The majority of apps that want this do not run as root.  Do we
want them all setuid?  ;-)

Joel

-- 

"If the human brain were so simple we could understand it, we would
 be so simple that we could not."
	- W. A. Clouston

			http://www.jlbec.org/
			jlbec@evilplan.org
