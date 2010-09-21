Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab0IURAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:00:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56392 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861Ab0IURAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:00:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sMpECBg+LGn4AHb+N1xIbRVmsIJFUuq3ewvZanN+5FdCcDlB293NXrlAt3d/eqwdKo
         TE3CGENklS53b7Dw91L3NnZJ3MPfjqxQqnzZv+zxhL2cKtUwf+b/p11f1O/gX9DWgcOQ
         q8KFyRUvo6yTAnyKQy8+T44600DQHS/tKAnG0=
Subject: Re: [PATCH] mm: do not print backtraces on GFP_ATOMIC failures
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        netdev@vger.kernel.org
In-Reply-To: <20100921094638.9910add0.akpm@linux-foundation.org>
References: <20100921121818.4745f038@annuminas.surriel.com>
	 <20100921094638.9910add0.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 19:00:27 +0200
Message-ID: <1285088427.2617.723.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 21 septembre 2010 à 09:46 -0700, Andrew Morton a écrit :
> On Tue, 21 Sep 2010 12:18:18 -0400 Rik van Riel <riel@redhat.com> wrote:
> 
> > Atomic allocations cannot fall back to the page eviction code
> > and are expected to fail.  In fact, in some network intensive
> > workloads, it is common to experience hundreds of GFP_ATOMIC
> > allocation failures.
> > 
> > Printing out a backtrace for every one of those expected
> > allocation failures accomplishes nothing good. At multi-gigabit
> > network speeds with jumbo frames, a burst of allocation failure
> > backtraces could even slow down the system.
> > 
> > We're better off not printing out backtraces on GFP_ATOMIC
> > allocation failures.
> > 
> > Signed-off-by: Rik van Riel <riel@redhat.com>
> > 
> > diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> > index 975609c..5a0bddb 100644
> > --- a/include/linux/gfp.h
> > +++ b/include/linux/gfp.h
> > @@ -72,7 +72,7 @@ struct vm_area_struct;
> >  /* This equals 0, but use constants in case they ever change */
> >  #define GFP_NOWAIT	(GFP_ATOMIC & ~__GFP_HIGH)
> >  /* GFP_ATOMIC means both !wait (__GFP_WAIT not set) and use emergency pool */
> > -#define GFP_ATOMIC	(__GFP_HIGH)
> > +#define GFP_ATOMIC	(__GFP_HIGH | __GFP_NOWARN)
> >  #define GFP_NOIO	(__GFP_WAIT)
> >  #define GFP_NOFS	(__GFP_WAIT | __GFP_IO)
> >  #define GFP_KERNEL	(__GFP_WAIT | __GFP_IO | __GFP_FS)
> 
> A much finer-tuned implementation would be to add __GFP_NOWARN just to
> the networking call sites.  I asked about this in June and it got
> nixed:
> 
> http://www.spinics.net/lists/netdev/msg131965.html
> --

Yes, I remember this particular report was useful to find and correct a
bug.

I dont know what to say.

Being silent or verbose, it really depends on the context ?



