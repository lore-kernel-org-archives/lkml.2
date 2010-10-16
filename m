Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab0JPHz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:55:29 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:60460 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174Ab0JPHzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:55:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBI9K
Date: Sat, 16 Oct 2010 18:55:21 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/17] kernel: add bl_list
Message-ID: <20101016075521.GJ19147@amd>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-2-git-send-email-david@fromorbit.com>
 <20100929215208.b0206460.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929215208.b0206460.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 09:52:08PM -0700, Andrew Morton wrote:
> On Wed, 29 Sep 2010 22:18:33 +1000 Dave Chinner <david@fromorbit.com> wrote:
> 
> > From: Nick Piggin <npiggin@suse.de>
> > 
> > Introduce a type of hlist that can support the use of the lowest bit
> > in the hlist_head. This will be subsequently used to implement
> > per-bucket bit spinlock for inode hashes.
> > 
> >
> > ...
> >
> > +static inline void INIT_HLIST_BL_NODE(struct hlist_bl_node *h)
> > +{
> > +	h->next = NULL;
> > +	h->pprev = NULL;
> > +}
> 
> No need to shout.

Just following the rest of the lists.


> > ...
> >
> > +static inline void hlist_bl_del(struct hlist_bl_node *n)
> > +{
> > +	__hlist_bl_del(n);
> > +	n->next = LIST_POISON1;
> > +	n->pprev = LIST_POISON2;
> > +}
> 
> I'd suggest creating new poison values for hlist_bl's, leave
> LIST_POISON1 and LIST_POISON2 for list_head (and any other list
> variants which went and used them :()

I guess they're used for lists, hlists, nulls lists. Would it really
help much seeing as you have so many lists anyway? I guess we could
do an incremental patch but I'll postpone it for now.


