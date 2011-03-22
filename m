Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab1CVUkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:40:11 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51722 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab1CVUkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:40:08 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
CC: viro@ZenIV.linux.org.uk, miklos@szeredi.hu, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de
In-reply-to: <E1Q28EK-0001rI-9v@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Tue, 22 Mar 2011 21:31:04 +0100)
Subject: Re: [PATCH 0/6 v7] overlay filesystem - request for inclusion
References: <20110322152602.053930811@szeredi.hu>
 <AANLkTinxD2rZnso3zfX0=-HQ9m7=zAjEtUepFO=uMe2Q@mail.gmail.com>
 <20110322183919.GV22723@ZenIV.linux.org.uk>
 <AANLkTinU-F+fHaG9u7c4Tf0GNx5BJvHg7BGOAFGaiDn1@mail.gmail.com>
 <E1Q26mX-0001Tt-Jq@pomaz-ex.szeredi.hu>
 <20110322190002.GW22723@ZenIV.linux.org.uk>
 <E1Q27U5-0001eO-AL@pomaz-ex.szeredi.hu>
 <20110322195331.GY22723@ZenIV.linux.org.uk>
 <E1Q27qg-0001kq-IO@pomaz-ex.szeredi.hu> <20110322201101.GZ22723@ZenIV.linux.org.uk> <E1Q28EK-0001rI-9v@pomaz-ex.szeredi.hu>
Message-Id: <E1Q28N4-0001tv-O6@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 22 Mar 2011 21:40:06 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011, Miklos Szeredi wrote:
> On Tue, 22 Mar 2011, Al Viro wrote:
> > On Tue, Mar 22, 2011 at 09:06:38PM +0100, Miklos Szeredi wrote:
> > > On Tue, 22 Mar 2011, Al Viro wrote:
> > > > Proceeding with rename is not interesting; proceeding with copyup is.
> > > > 
> > > > Who said that by the time we get to copy_up_locked you will still have
> > > > dentry (and upper) match lowerpath?  Or that ->d_parent on overlay and
> > > > on upper will change in sync, for that matter - there are two d_move()
> > > > calls involved...
> > > 
> > > If rename is involved, than rename itself already did the copy up.
> > > And that's checked before proceeding with the actual copy up.  If
> > > there was no rename, then that guarantees that things are in sync, at
> > > least for the duration of the copy up.
> > 
> > What do you mean, before?  It's not atomic...  What happens if e.g.
> > you get
> > 
> > A: decided to do copy_up_locked
> >    blocked on i_mutex
> > 
> > B: did copy_up
> >    did rename(), complete with d_move()
> >    did unlink() in new place
> > 
> > A: got CPU back, got i_mutex
> 
> Here it can check if the file was copied up or not.  OK, I see the
> code doesn't quite get that right.
> 
> Patch below would fix it, I think.

Scratch that, d_move() on overlayfs would also have to be under
i_mutex of upper.  But that should be doable as well.  I'll fix that
tomorrow when my brain is a little fresher.

Thanks,
Miklos
