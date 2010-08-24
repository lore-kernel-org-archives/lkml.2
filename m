Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0HXNza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:55:30 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:49868 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755241Ab0HXNz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:55:27 -0400
Date: Tue, 24 Aug 2010 23:55:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Alasdair G Kergon <agk@redhat.com>,
        Chris Mason <chris.mason@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, cluster-devel@redhat.com,
        linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Message-ID: <20100824135522.GK31488@dastard>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
 <1282656558.2605.2742.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282656558.2605.2742.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 03:29:18PM +0200, Peter Zijlstra wrote:
> On Tue, 2010-08-24 at 03:50 -0700, David Rientjes wrote:
> > These were added as helper functions for documentation and auditability.
> > No future callers should be added.
> 
> git grep GFP_NOFAIL isn't auditable enough?
> 
> might as well declare these functions depricated if you really want to
> do this.

Also, if you are going to add tight loops, you might want to put a
backoff in the loops like "congestion_wait(BLK_RW_ASYNC, HZ/50);" so
that they don't spin....

FWIW, in all this "allocations can't fail" churn, no one has noticed
that XFS has been doing these "allocations can't fail" loop in
kmem_alloc() and kmem_zone_alloc(), well, forever. I can't ever
remember seeing it report a potential deadlock, though....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
