Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab0F3OdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:33:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:36004 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756397Ab0F3OdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:33:09 -0400
Date: Wed, 30 Jun 2010 22:13:18 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 51/52] fs: per-zone dentry and inode LRU
Message-ID: <20100630121318.GF21358@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030733.869946613@suse.de>
 <20100630100937.GJ24712@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630100937.GJ24712@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 08:09:37PM +1000, Dave Chinner wrote:
> On Thu, Jun 24, 2010 at 01:03:03PM +1000, npiggin@suse.de wrote:
> > Per-zone LRUs and shrinkers for dentry and inode caches.
> > 
> > Signed-off-by: Nick Piggin <npiggin@suse.de>
> 
> This destroys any notion we have of global LRU-ness of inode and
> dentry caches, doesn't it?

Yes.

> Can you outline in more detail what sort
> of reclaim pattern this results in. e.g. is a workload running on
> a single node now effectively limited to a dentry/icache size within
> the local node because of local node slab allocation and per-zone
> reclaim?

No, it will just make the vfs cache reclaim work similarly to
pagecache reclaim. Reclaimers (kswapd) can work on node local
memory; memory pressure in a particular zone can be targetted
specifically instead of shrinking all zones until it is OK;
zone reclaim will work properly for vfs caches; partitioning
of workloads can be better.

Workload on a single node can certainly still use up all global
memory if that is how the policy is configured.

Global LRU ordering is lost, but it is approximated when there
is a global memory shortage by scanning a little from each zone
head. When there is a local memory shortage it should be superior
because that can be resolved without reclaiming so much memory.

Thanks,
Nick

