Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab0ERI4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 04:56:18 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45468 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755624Ab0ERI4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 04:56:15 -0400
Date: Tue, 18 May 2010 10:56:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the block tree
Message-ID: <20100518085613.GU25951@kernel.dk>
References: <20100518133710.8b1545dd.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518133710.8b1545dd.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18 2010, Stephen Rothwell wrote:
> Hi Jens,
> 
> After merging the block tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> block/blk-core.c: In function 'laptop_mode_timer_fn':
> block/blk-core.c:503: error: too few arguments to function 'bdi_start_writeback'
> 
> Caused by commit e913fc825dc685a444cb4c1d0f9d32f372f59861 ("writeback:
> fix WB_SYNC_NONE writeback from umount") from the block tree interacting
> with commit 42bd225c0ba7c95af39293d39a950c48e7e5cb23 (""laptop-mode: Make
> flushes per-device" fix") also from the block tree.  The merge
> 6205ed4658a0df8c2879519977bbed6853014016 should have changed the code in
> block/blk-core.c that moved from mm/page-writeback.c.
> 
> Mind you, I think that the change to laptop_mode_timer_fn in commit
> e913fc825dc685a444cb4c1d0f9d32f372f59861 was wrong anyway (the 0 should
> have been added at the end, surely).
> 
> I have used the block tree from next-20100517 for today.

Thanks, it looks like a merge/commit error on for-next alone, for-2.6.35
is fine. I'll make sure this gets fixed up now.

-- 
Jens Axboe

