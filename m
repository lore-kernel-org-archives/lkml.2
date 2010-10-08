Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab0JHJ0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:26:08 -0400
Received: from cache.dhh-3.de ([62.89.186.8]:59924 "EHLO
	mx01.instandbesetzt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab0JHJ0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:26:05 -0400
Date: Fri, 8 Oct 2010 11:26:01 +0200
From: Andreas Wiese <aw-lkml@meterriblecrew.net>
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ciaran McCreesh <ciaran.mccreesh@googlemail.com>, xfs@oss.sgi.com
Subject: Re: fallocate() on XFS clobbers S*ID-bits
Message-ID: <20101008092600.GA12718@incendiary.meterriblecrew.net>
References: <20101007183418.GC5621@incendiary.meterriblecrew.net>
 <20101007232451.GO4681@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101007232451.GO4681@dastard>
X-GPG-Key-ID: 0x08709798 (2048/4096bit RSA/RSA)
X-GPG-Fingerprint: F8F1 7E3C 2C24 5189 FC21  61E9 1F99 AEB4 0870 9798
X-Jabber-ID: aw@instandbesetzt.net (w/ GPG)
X-Home: https://www.instandbesetzt.net/
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> [ added xfs list on cc ]
> 

Thanks. ;)

> On Thu, Oct 07, 2010 at 08:34:19PM +0200, Andreas Wiese wrote:
> > Hello.
> > 
> > I (with support from Cc'ed Ciaran) just noticed some odd behaviour with
> > fallocate() on XFS.  After open()ing some file and setting it S*ID via
> > fchmod(), S*ID bits vanish after calling fallocate() — as supposed to
> > for non-root users, but it also happens for root.
> > 
> > Is this intended behaviour or did we spot a bug here?
> > 
> > At least on ext2 it works as expected, thus I guess it's the latter one.
> 
> ext2 does not support the fallocate syscall. How does ext4 behave?
> 

Oh, crap.  I first tested on tmpfs (which doesn't support fallocate,
too) and had a » && errno != ENOTSUP« to avoid bailing out but forgot to
warn. :/

But I did now and ext4 does _not_ touch the permissions any further.

> > I'm running v2.6.35.7 vanilla-kernel, but diffing fs/xfs to master
> > doesn't seem to address this issue.
> 
> XFS has always cleared SUID/SGID bits when doing preallocation (via
> XFS_IOC_RESVSP). Given that that XFS ioctl formed the model for
> fallocate, I'd argue that the XFS behaviour is the on that should be
> followed.
> 

If that's consense, we at least found a bug in ext4…

> It'd be a bit silly for two different preallocation interfaces to
> have different behaviour w.r.t. SUID bits, but it's not clear to me
> which behaviour is correct. I'm happy to defer to whoever can say
> what the behaviour is supposed to be here...
> 

I would appreciate that, too.

And while on it… just tested BTRFS, which behaves like ext4 (not
altering permissions).  CIFS and OCFS are not testable here due to lack
of according servers.

[snip…]

HAND & LG -- aw
np: Johnossi (Johnossi) — 08. Happiness a La Mode
