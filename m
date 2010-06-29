Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab0F2Gaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 02:30:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:37299 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab0F2Ga3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 02:30:29 -0400
Date: Tue, 29 Jun 2010 16:30:10 +1000
From: Nick Piggin <npiggin@suse.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 01/52] kernel: add bl_list
Message-ID: <20100629063010.GJ28364@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030725.718438579@suse.de>
 <20100628213739.GF2357@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100628213739.GF2357@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 02:37:39PM -0700, Paul E. McKenney wrote:
> On Thu, Jun 24, 2010 at 01:02:13PM +1000, npiggin@suse.de wrote:
> > Introduce a type of hlist that can support the use of the lowest bit in the
> > hlist_head. This will be subsequently used to implement per-bucket bit spinlock
> > for inode and dentry hashes.
> > 
> > Signed-off-by: Nick Piggin <npiggin@suse.de>
> 
> Looks good!  One question on non-RCU pointer poisoning and a typo.
> When these are addressed (perhaps by showing me the error of my ways):
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 

..

> > +static inline void hlist_bl_del(struct hlist_bl_node *n)
> > +{
> > +	__hlist_bl_del(n);
> > +	n->pprev = LIST_POISON2;
> 
> OK, I'll bite...  Why don't we poison the ->next pointer?

Ah, I took the code from list_nulls.h, but actually, except for the
hlist anchoring, the code is much more similar to the standard hlist.
This can be poisoned, and I'll go through and look for other possible
differences with hlists.

> > +/**
> > + * hlist_bl_del_init_rcu - deletes entry from hash list with re-initialization
> > + * @n: the element to delete from the hash list.
> > + *
> > + * Note: hlist_bl_unhashed() on the node return true after this. It is
>                                             returns
 
Yes, thanks!

