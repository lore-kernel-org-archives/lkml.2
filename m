Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab2HWSA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:00:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225Ab2HWSAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:00:51 -0400
Date: Thu, 23 Aug 2012 14:00:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, mpatocka@redhat.com,
        bharrosh@panasas.com
Subject: Re: [PATCH v6 00/13] Block cleanups
Message-ID: <20120823180041.GK12232@redhat.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345655050-28199-1-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 10:03:57AM -0700, Kent Overstreet wrote:

[..]
> Kent Overstreet (13):
>   block: Generalized bio pool freeing
>   dm: Use bioset's front_pad for dm_rq_clone_bio_info
>   block: Add bio_reset()
>   pktcdvd: Switch to bio_kmalloc()
>   block: Kill bi_destructor
>   block: Consolidate bio_alloc_bioset(), bio_kmalloc()

This patch series says "Block Cleanups" in the subject. I think that
it can be divided in two parts. First part seems to be cleanup where
we get rid of ->bi_destructor and merge kmalloc() and allocation 
from bio_set.

Second part seems to be more of enhancing bio splitting functionality
and not necessarily a cleanup. So may be breaking this series in two
parts makes sense. First part is cleanup and second part is enhanced
bio splitting capabilities of block layer.

Thanks
Vivek
 
>   block: Avoid deadlocks with bio allocation by stacking drivers
>   block: Add an explicit bio flag for bios that own their bvec
>   block: Rename bio_split() -> bio_pair_split()
>   block: Introduce new bio_split()
>   block: Rework bio_pair_split()
>   block: Add bio_clone_bioset(), bio_clone_kmalloc()
>   block: Only clone bio vecs that are in use
> 
>  Documentation/block/biodoc.txt      |   5 -
>  block/blk-core.c                    |  10 +-
>  drivers/block/drbd/drbd_main.c      |  13 +-
>  drivers/block/drbd/drbd_req.c       |  18 +-
>  drivers/block/osdblk.c              |   3 +-
>  drivers/block/pktcdvd.c             |  73 ++-----
>  drivers/block/rbd.c                 |   8 +-
>  drivers/md/dm-crypt.c               |   9 -
>  drivers/md/dm-io.c                  |  11 -
>  drivers/md/dm.c                     |  68 ++----
>  drivers/md/linear.c                 |   6 +-
>  drivers/md/md.c                     |  44 +---
>  drivers/md/raid0.c                  |   8 +-
>  drivers/md/raid10.c                 |  23 +-
>  drivers/target/target_core_iblock.c |   9 -
>  fs/bio-integrity.c                  |  45 ----
>  fs/bio.c                            | 419 +++++++++++++++++++++++-------------
>  fs/exofs/ore.c                      |   5 +-
>  include/linux/bio.h                 | 155 +++++++------
>  include/linux/blk_types.h           |  16 +-
>  20 files changed, 434 insertions(+), 514 deletions(-)
> 
> -- 
> 1.7.12
