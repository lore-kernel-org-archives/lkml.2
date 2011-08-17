Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab1HQUps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:45:48 -0400
Received: from lucidpixels.com ([72.73.18.11]:46665 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab1HQUpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:45:44 -0400
Date: Wed, 17 Aug 2011 16:45:44 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Jeff Layton <jlayton@samba.org>
cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
In-Reply-To: <20110817161349.072e1452@tlielax.poochiereds.net>
Message-ID: <alpine.DEB.2.02.1108171644050.11234@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net> <20110815064734.403b630f@corrin.poochiereds.net> <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
 <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan> <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan> <alpine.DEB.2.02.1108171545190.5877@p34.internal.lan> <alpine.DEB.2.02.1108171547110.5877@p34.internal.lan>
 <20110817161349.072e1452@tlielax.poochiereds.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Aug 2011, Jeff Layton wrote:

> The crash is happening in the bowels of the slab allocator.
> Specifically, it looks like it's hitting this:
>
>                /*
>                 * The slab was either on partial or free list so
>                 * there must be at least one object available for
>                 * allocation.
>                 */
>                BUG_ON(slabp->inuse >= cachep->num);
>
> ...which looks like maybe the accounting of in-use objects is off. This
> really sounds like some sort of memory corruption. I've not been able
> to reproduce this so far, but I also had someone report panic here that
> might be related:
>
>    https://bugzilla.redhat.com/show_bug.cgi?id=731278
>
> One thing that might be helpful is turning on page poisoning and
> redoing this test, that might make it crash sooner and point out the
> source of the corruption.
>
> Even better would be a bisect to track down the cause...


Hi Jeff,

root@acerlw:/usr/src/linux# grep CONFIG_PAGE_POISONING .config
root@acerlw:/usr/src/linux# ls -l ../linux
lrwxrwxrwx 1 root root 13 Aug 17 14:41 ../linux -> linux-3.1-rc2/
root@acerlw:/usr/src/linux#

In what kernel is that feature available, or, how do I enable it?

Justin.

