Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab0FAPDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 11:03:17 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60683 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664Ab0FAPDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 11:03:15 -0400
Date: Tue, 1 Jun 2010 08:00:49 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Eric Paris <eparis@redhat.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
Message-ID: <20100601150049.GQ4098@outflux.net>
References: <20100531030402.GQ6056@outflux.net>
 <20100531103510.GA30021@infradead.org>
 <20100531175733.GD4098@outflux.net>
 <alpine.LRH.2.00.1006010904190.675@tundra.namei.org>
 <20100601032423.GL4098@outflux.net>
 <20100601075529.GA11397@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601075529.GA11397@infradead.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 03:55:29AM -0400, Christoph Hellwig wrote:
> On Mon, May 31, 2010 at 08:24:23PM -0700, Kees Cook wrote:
> > Well, that's what I'm trying to understand.  It sounds like there is some
> > general agreement that the issue needs to be solved, but some folks do not
> > want it in the core VFS.  As in, the objections aren't with how symlink
> > behavior is changed, just that the changes would be in the fs/ directory.
> 
> No, it's not.  It's not a change we can make for the default that
> everyone uses.  If you're keen to mess up installations you control (aka
> ubuntu valuedadd viper) push it into a special LSM or rather a
> non-standard rule for it.  It really doesn't matter if it's in fs/ or
> security/ but it's simplify not going to happen by default.

Okay, thanks; that clarifies some of my confusion.  It sounds like
there are some people that genuinely believe that the symlink-following
logic should not change.  I would pose, then, a question of "what
are legitimate and safe situations that require following cross-user
symlinks in a sticky world-writable directory?"  And if the answers to
that aren't very convincing, then I think it's reasonable to include at
least an option to change the behavior.

> > My rationale is that if it's in commoncaps, it's effective for everyone, so
> > it might as well be in core VFS.  If the VFS objections really do boil down
> > to "not in fs/" then I'm curious if doing this in commoncaps is acceptable.
> 
> If you think the objection is about having things in fs/ you're smoking
> some really bad stuff.

Right, that was my point exactly.  It didn't make sense to object to it
being in fs/.  The objection was to having it in the kernel at all.  So now
I can focus my efforts on convincing people about the value of making this
a setting in the kernel, like turning on or off TCP syn-flood protection.
Some people may demand it, some people may hate it, but the choice it
up to the end user.

-Kees

-- 
Kees Cook
Ubuntu Security Team
