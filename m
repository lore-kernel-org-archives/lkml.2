Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab0FAOx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 10:53:57 -0400
Received: from smtp.outflux.net ([198.145.64.163]:38618 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab0FAOxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 10:53:55 -0400
Date: Tue, 1 Jun 2010 07:52:51 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Eric Paris <eparis@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
Message-ID: <20100601145251.GP4098@outflux.net>
References: <20100531030402.GQ6056@outflux.net>
 <20100531103510.GA30021@infradead.org>
 <20100531175733.GD4098@outflux.net>
 <alpine.LRH.2.00.1006010904190.675@tundra.namei.org>
 <20100601032423.GL4098@outflux.net>
 <20100601075529.GA11397@infradead.org>
 <1275393302.2690.13.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275393302.2690.13.camel@localhost>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 07:55:02AM -0400, Eric Paris wrote:
> On Tue, 2010-06-01 at 03:55 -0400, Christoph Hellwig wrote:
> > On Mon, May 31, 2010 at 08:24:23PM -0700, Kees Cook wrote:
> 
> > > My rationale is that if it's in commoncaps, it's effective for everyone, so
> > > it might as well be in core VFS.  If the VFS objections really do boil down
> > > to "not in fs/" then I'm curious if doing this in commoncaps is acceptable.
> > 
> > If you think the objection is about having things in fs/ you're smoking
> > some really bad stuff.
> 
> Sounds to me like we should probably follow the same path as
> mmap_min_addr.  We should add these hooks right in the VFS where they
> belong (much like mmap_min_addr hooks into the vm) and control them 2
> ways.
> 
> 1) a Kconfig so distros can choose to turn it on or off by default
> 2) a /proc interface so root can turn it off
> 
> Nothing about that precludes additional similar checks inside an LSM
> (like CONFIG_LSM_MMAP_MIN_ADDR) which can be more finely controlled.  So
> maybe we want to follow up with the core VFS check with new checks in
> SELinux (and maybe apparmour).  This allows the user to disable the
> general check and still be provided with some modicum of protection.
> You might ask why not ONLY do the check in SELinux and drop the generic
> check, but we have seen with mmap_min_addr that the SELinux unconfined
> user can do damn well anything it wants to, so having a non-LSM version
> of appropriate security checks is highly regarded.

Would a CONFIG for this be overkill?  mmap_min_addr is a little different
in that there was desire to control a bottom limit on it, etc.  Given this
is either "on" or "off", I think just a sysctl is needed?

I will send a v3 patch that fixes the sysctl name and default, so that it
is up to the distro and end user how to configure their symlink semantics.

-Kees

-- 
Kees Cook
Ubuntu Security Team
