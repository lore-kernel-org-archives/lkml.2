Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1FRA2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 20:28:23 -0400
Received: from smtp-out.google.com ([74.125.121.67]:14715 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab1FRA2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 20:28:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=CydOji7yfSfthqXhzPKF0RuY3x8GuLYCV8n/RAiqTdQ6xtg7qfzX/oEifRfcjnT5xb
         6Y3m1hHrh9NBoh0xwdsg==
Date: Fri, 17 Jun 2011 17:28:15 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: should CONFIG_TMPFS_POSIX_ACL be so easily deselectable?
In-Reply-To: <alpine.DEB.2.02.1106171909260.8043@localhost6.localdomain6>
Message-ID: <alpine.LSU.2.00.1106171713570.1345@sister.anvils>
References: <alpine.DEB.2.02.1106171756470.4381@localhost6.localdomain6> <alpine.LSU.2.00.1106171534530.20805@sister.anvils> <alpine.DEB.2.02.1106171909260.8043@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011, Robert P. J. Day wrote:
> On Fri, 17 Jun 2011, Hugh Dickins wrote:
> > On Fri, 17 Jun 2011, Robert P. J. Day wrote:
> > >
> > > p.s.  i do notice a fairly recent change to that config file related
> > > to this:
> >
> > Yes, we were originally losing the oldconfig value of
> > TMPFS_POSIX_ACL.
> >
> > It would be easy to ack a patch from you which changes that wording
> > "If you don't know what Access Control Lists are, say N" to
> > something more informative about what the sound userspace wants.
> 
>   agreed -- something as simple as "if you don't know, say Y"?  :-)
> or would it be better to actually take a line or two to explain the
> consequences of that option?

I think both.  I've often thought "default N", "if unsure say Y"
Kconfig options contradictory, but I can see the point in this case.
Example or examples of the pain of saying N can be helpful.

> (by the way, this option affects more than just sound.)

Of course.

> 
> > It would be harder to justify having SOUND select TMPFS, or changing
> > the TMPFS_POSIX_ACL default to Y.  It's been N forever, and that is
> > how we prefer to add features.
> 
>   normally, i'd agree with you, except for the observation that, by
> far, the default config files across all architectures select that
> option.  there are 48 config files that select it, and only 3 that
> don't.  sometimes, that's a compelling argument that maybe it *should*
> be default yes.  but for now, i'll just whip up a more informative
> help sentence or two.

I don't think architecture defconfig files necessarily correlate with
Kconfig defaults.  You could argue that they should do so (so far as
arch-independent options are concerned), but I think the reality is
that arch defconfigs are produced separately, at the whim of various
people with different agendas.  I may be wrong (if unsure, say Y!).

> 
> rday
> 
> p.s.  as i mentioned, that option would appear to affect more than
> just sound.  as in:
> 
> $ getfacl /dev/kvm
> getfacl: Removing leading '/' from absolute path names
> # file: dev/kvm
> # owner: root
> # group: kvm
> user::rw-
> user:rpjday:rw-
> group::rw-
> mask::rw-
> other::---
> 
> so wouldn't KVM suddenly start behaving badly as well?

Dunno.  But certainly TMPFS_POSIX_ACLs are for whatever uses
tmpfs POSIX ACLs are being put to, not specific to sound - but
sound happens to be the case that wasted your time and Linus's.

Hugh
