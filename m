Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1CVT4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 15:56:22 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40622 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab1CVT4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 15:56:20 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: miklos@szeredi.hu, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de
In-reply-to: <20110322193807.GX22723@ZenIV.linux.org.uk> (message from Al Viro
	on Tue, 22 Mar 2011 19:38:07 +0000)
Subject: Re: [PATCH 0/6 v7] overlay filesystem - request for inclusion
References: <20110322152602.053930811@szeredi.hu>
 <AANLkTinxD2rZnso3zfX0=-HQ9m7=zAjEtUepFO=uMe2Q@mail.gmail.com>
 <20110322183919.GV22723@ZenIV.linux.org.uk>
 <AANLkTinU-F+fHaG9u7c4Tf0GNx5BJvHg7BGOAFGaiDn1@mail.gmail.com>
 <E1Q26mX-0001Tt-Jq@pomaz-ex.szeredi.hu> <20110322193807.GX22723@ZenIV.linux.org.uk>
Message-Id: <E1Q27gd-0001i7-Q3@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 22 Mar 2011 20:56:15 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011, Al Viro wrote:
> On Tue, Mar 22, 2011 at 07:58:17PM +0100, Miklos Szeredi wrote:
> 
> > > >  and its protection against renames is
> > > > nowhere near enough. ??I might be missing something subtle, but...
> > 
> > Protection is exactly as for userspace callers.  AFAICT.
> 
> BTW, what filesystems can act as upper layers and how are you going to
> prevent modifications of upper layer in normal way?  It is mounted,
> after all, or you would be unable to find it when mounting overlayfs.
> And it might be mounted in any number of places, not all even visible to
> you...  I realize that you have it listed as a problem, but do you have
> any ideas on how to deal with that?

Yes, I have some patches, but decided that that should be a separate
set, once the basics are ironed out.

Since the locking guarantees are separated on the upper/lower fs from
the overlayfs, allowing modification is not a huge problem.  The worst
that can happen is that an attacker who has access to both the overlay
and the upper or lower fs then can "build" an arbitrarily deep
directory tree on the overlayfs.  Not a big issue.  There won't be
deadlocks or filesystem corruption.

> If you allow NFS as upper layer, you really have a problem; with this
> approach you probably want to prevent that very forcibly.  Not that
> your open() handling would work correctly with NFS, even with no modifications
> from other clients or from server...

Upper layer doesn't work on NFS for multiple reasons.

Thanks,
Miklos
