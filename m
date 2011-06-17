Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508Ab1FQXYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 19:24:20 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:41637 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478Ab1FQXYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 19:24:17 -0400
Date: Fri, 17 Jun 2011 19:24:13 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Hugh Dickins <hughd@google.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: should CONFIG_TMPFS_POSIX_ACL be so easily deselectable?
In-Reply-To: <alpine.LSU.2.00.1106171534530.20805@sister.anvils>
Message-ID: <alpine.DEB.2.02.1106171909260.8043@localhost6.localdomain6>
References: <alpine.DEB.2.02.1106171756470.4381@localhost6.localdomain6> <alpine.LSU.2.00.1106171534530.20805@sister.anvils>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011, Hugh Dickins wrote:

> On Fri, 17 Jun 2011, Robert P. J. Day wrote:
> >
> >   long story short:  in updating to a slightly newer hand-rolled
> > kernel (2.6.39-rc7 -> 3.0.0-rc3) on my ubuntu system, i somehow (no
> > idea how) managed to deselect CONFIG_TMPFS_POSIX_ACL without realizing
> > it.  the consequences of this were that sound suddenly disappeared
> > under the new kernel, for a fairly obvious reason -- ALSA needs ACLs
> > under /dev to give R/W access to the user to the device files under
> > /dev/snd/.
> >
> >   as i said, i have no idea how i managed to do this but i eventually
> > tracked it down, re-selected that option, rebuilt and i have sound
> > again.  but i noticed that in fs/Kconfig, that option is independently
> > selectable from TMPFS, so it's (as i learned) deviously easy to
> > deselect, with annoying consequences.
> >
> >   more to the point, given the apparent necessity of ACLs under /dev
> > for proper sound operation, the help info for that option seems a bit
> > misleading:
> >
> > config TMPFS_POSIX_ACL
> >         bool "Tmpfs POSIX Access Control Lists"
> >         depends on TMPFS
> >         select TMPFS_XATTR
> >         select GENERIC_ACL
> >         help
> >           ... snip ...
> >           If you don't know what Access Control Lists are, say N.
> >
> >   yeah, i think that help line might not want to dismiss tmpfs ACLs
> > quite so quickly.  thoughts?
> >
> > rday
> >
> > p.s.  i do notice a fairly recent change to that config file related
> > to this:
>
> Yes, we were originally losing the oldconfig value of
> TMPFS_POSIX_ACL.
>
> It would be easy to ack a patch from you which changes that wording
> "If you don't know what Access Control Lists are, say N" to
> something more informative about what the sound userspace wants.

  agreed -- something as simple as "if you don't know, say Y"?  :-)
or would it be better to actually take a line or two to explain the
consequences of that option?  (by the way, this option affects more
than just sound.)

> It would be harder to justify having SOUND select TMPFS, or changing
> the TMPFS_POSIX_ACL default to Y.  It's been N forever, and that is
> how we prefer to add features.

  normally, i'd agree with you, except for the observation that, by
far, the default config files across all architectures select that
option.  there are 48 config files that select it, and only 3 that
don't.  sometimes, that's a compelling argument that maybe it *should*
be default yes.  but for now, i'll just whip up a more informative
help sentence or two.

rday

p.s.  as i mentioned, that option would appear to affect more than
just sound.  as in:

$ getfacl /dev/kvm
getfacl: Removing leading '/' from absolute path names
# file: dev/kvm
# owner: root
# group: kvm
user::rw-
user:rpjday:rw-
group::rw-
mask::rw-
other::---

so wouldn't KVM suddenly start behaving badly as well?

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
