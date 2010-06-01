Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab0FARcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 13:32:11 -0400
Received: from thunk.org ([69.25.196.29]:52787 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015Ab0FARcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 13:32:06 -0400
Date: Tue, 1 Jun 2010 13:31:57 -0400
From: tytso@mit.edu
To: Eric Paris <eparis@redhat.com>
Cc: Kees Cook <kees.cook@canonical.com>, Christoph Hellwig <hch@infradead.org>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
Message-ID: <20100601173157.GE4426@thunk.org>
Mail-Followup-To: tytso@mit.edu, Eric Paris <eparis@redhat.com>,
	Kees Cook <kees.cook@canonical.com>,
	Christoph Hellwig <hch@infradead.org>,
	James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	Randy Dunlap <rdunlap@xenotime.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiri Kosina <jkosina@suse.cz>,
	Dave Young <hidave.darkstar@gmail.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	"Serge E. Hallyn" <serue@us.ibm.com>
References: <20100531030402.GQ6056@outflux.net>
 <20100531103510.GA30021@infradead.org>
 <20100531175733.GD4098@outflux.net>
 <alpine.LRH.2.00.1006010904190.675@tundra.namei.org>
 <20100601032423.GL4098@outflux.net>
 <20100601075529.GA11397@infradead.org>
 <1275393302.2690.13.camel@localhost>
 <20100601145251.GP4098@outflux.net>
 <1275406477.2690.56.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275406477.2690.56.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 11:34:37AM -0400, Eric Paris wrote:
> 
> Seems like one of Alan's main arguments is that you should not turn it
> on 'by default.'  I assume most distros will want it on by default.
> Alan made the same argument against mmap_min_addr (known to break dos
> emu) but I think most major distros have it on by default these days
> even if it does break those weird obscure use cases.  I guess distros
> can do it through sysctl but Fedora, at least, likes to keep those
> default if possible, which is why I suggested the CONFIG.  In any case,
> putting this right square in the VFS where it happens makes the most
> sense to me.

If the use cases where people would really want to support following a
third-party symlink located in a world-writable sticky-bitted
directory are real (I'm not really convinced they really are real),
then it might make more sense to do it as a sysctl-controlled variable
with distro's chooinsg to enable it by default in their shipped
/etc/sysctl.conf file.  That way their users/customers will be able to
more easily disable the security feature if it really matters.

That being said, I'm not at all convinced there are any legtimiate use
cases that would be impacted by this change, and as I've pointed out
earlier, I don't think the "POSIX doesn't allow this change" argument
holds water, since POSIX originally didn't even allow for the
semantics for the sticky-bit on directories.  The real argument is
going to come from traditionalists, who will argue, "that isn't the
traditional behaviour!"

How strongly you buy this as an argument is going to be religious
argument, since it's doubtful that it people can come up with real use
cases that will actually break with that sort of change --- especially
given that the vast majority of Linux systems are single-user systems,
and the main concern will be a privilege escalation attacks.

> I'd also like to point out that I don't buy the argument that per
> user /tmp/ is a 'better' solution for the general case.  Any application
> that would be broken by this change will also be broken by per
> user /tmp.  Now, if we used filesystem namespaces regularly for years
> and users, administrators, and developers dealt with them often I agree
> that would probably be the preferred solution.  It would solve this
> issue, but in introduces a whole host of other problems that are even
> more obvious and even likely to bite people.

Per-user /tmp solves other problems as well, though --- especially for
people who care a whole lot about mandatory access control scenarios,
for example.  

I do have a slight preference against per-user /tmp mostly because it
gets confusing for administrators, and because it could be used by
rootkits to hide themselves in ways that would be hard for most system
administrators to find.

					- Ted
