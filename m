Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab0JSFdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 01:33:25 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:42196 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684Ab0JSFdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 01:33:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjoEAC/KvEx5LcB2gWdsb2JhbAChZhYBARYiIsMEhUkE
Date: Tue, 19 Oct 2010 16:33:20 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 03/35] mm: implement per-zone shrinker
Message-ID: <20101019053320.GA7470@amd>
References: <20101019034216.319085068@kernel.dk>
 <20101019034655.756353382@kernel.dk>
 <20101019134345.A1E9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019134345.A1E9.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 19, 2010 at 01:49:12PM +0900, KOSAKI Motohiro wrote:
> Hi
> 
> > Index: linux-2.6/include/linux/mm.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/mm.h	2010-10-19 14:19:40.000000000 +1100
> > +++ linux-2.6/include/linux/mm.h	2010-10-19 14:36:48.000000000 +1100
> > @@ -997,6 +997,10 @@
> >  /*
> >   * A callback you can register to apply pressure to ageable caches.
> >   *
> > + * 'shrink_zone' is the new shrinker API. It is to be used in preference
> > + * to 'shrink'. One must point to a shrinker function, the other must
> > + * be NULL. See 'shrink_slab' for details about the shrink_zone API.
> 
...

> Now we decided to don't remove old (*shrink)() interface and zone unaware
> slab users continue to use it. so why do we need global argument?
> If only zone aware shrinker user (*shrink_zone)(), we can remove it.
> 
> Personally I think we should remove it because a removing makes a clear
> message that all shrinker need to implement zone awareness eventually.

I agree, I do want to remove the old API, but it's easier to merge if
I just start by adding the new API. It is split out from my previous
patch which does convert all users of the API. When this gets merged, I
will break those out and send them via respective maintainers, then
remove the old API when they're all converted upstream.

Thanks,
Nick

