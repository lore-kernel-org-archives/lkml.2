Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab2K2WJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:09:20 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:49690 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304Ab2K2WJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:09:16 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIKAM/bt1B5LN4a/2dsb2JhbABEhUK0R4V7F3OCHgEBBAEOLBwPFAULCAMYLhQlAyETiAoFvyEUjCyDYGEDlgCQRYMGgVEk
Date: Fri, 30 Nov 2012 09:09:14 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: glommer@parallels.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [RFC, PATCH 00/19] Numa aware LRU lists and shrinkers
Message-ID: <20121129220914.GE6434@dastard>
References: <1354058086-27937-1-git-send-email-david@fromorbit.com>
 <m24nk8grlr.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m24nk8grlr.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 11:02:24AM -0800, Andi Kleen wrote:
> Dave Chinner <david@fromorbit.com> writes:
> >
> > Comments, thoughts and flames all welcome.
> 
> Doing the reclaim per CPU sounds like a big change in the VM balance. 

It's per node, not per CPU. And AFAICT, it hasn't changed the
balance of page cache vs inode/dentry caches under general, global
workloads at all.

> Doesn't this invalidate some zone reclaim mode settings?

No, because zone reclaim is per-node and the shrinkers now can
reclaim just from a single node. i.e. the behaviour is now better
suited to the aims of zone reclaim which is to free memory from a
single, targetted node. Indeed, I removed a hack in the zone reclaim
code that sprayed slab reclaim across the entire machine until
sufficient objects had been freed from the target node....

> How did you validate all this?

fakenuma setups, various workloads that generate even dentry/slab
cache loadings across all nodes, adding page cache pressure on a
single node, watching slab reclaim from a single node. that sort of
thing.

I haven't really done any performance testing other than "not
obviously slower". There's no point optimising anything before
there's any sort of agreement as to whether this is the right
approach to take or not....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
