Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab2IXTq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:46:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570Ab2IXTq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:46:56 -0400
Date: Mon, 24 Sep 2012 12:46:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <roland@purestorage.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Amir Vadai <amirv@mellanox.co.il>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        linux-rdma@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20120924124654.5012ca3e.akpm@linux-foundation.org>
In-Reply-To: <CAL1RGDUCThiu+vxy4d5QXvqfDCDUnHOBfZT97XB+Qy_bQrxCRg@mail.gmail.com>
References: <20120925000217.947b8cd8dca6979bfedee2ca@canb.auug.org.au>
	<CAL1RGDUCThiu+vxy4d5QXvqfDCDUnHOBfZT97XB+Qy_bQrxCRg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2012 12:36:43 -0700
Roland Dreier <roland@purestorage.com> wrote:

> On Mon, Sep 24, 2012 at 7:02 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > After merging the akpm tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >
> > drivers/infiniband/hw/mlx4/cm.c: In function 'id_map_alloc':
> > drivers/infiniband/hw/mlx4/cm.c:228:36: error: 'MAX_ID_MASK' undeclared (first use in this function)
> >
> > Caused by commit d7a4e9b679e9 ("IB/mlx4: Add CM paravirtualization") from
> > the infiniband tree interacting with commit "idr: rename MAX_LEVEL to
> > MAX_IDR_LEVEL" from the akpm tree.
> >
> > I have added the following merge fix patch for today:
> >
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Mon, 24 Sep 2012 23:57:53 +1000
> > Subject: [PATCH] IB/mlx4: fix for MAX_ID_MASK to MAX_IDR_MASK name change
> >
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  drivers/infiniband/hw/mlx4/cm.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
> > index e25e4da..80079e5 100644
> > --- a/drivers/infiniband/hw/mlx4/cm.c
> > +++ b/drivers/infiniband/hw/mlx4/cm.c
> > @@ -225,7 +225,7 @@ id_map_alloc(struct ib_device *ibdev, int slave_id, u32 sl_cm_id)
> >                 ret = idr_get_new_above(&sriov->pv_id_table, ent,
> >                                         next_id, &id);
> >                 if (!ret) {
> > -                       next_id = ((unsigned) id + 1) & MAX_ID_MASK;
> > +                       next_id = ((unsigned) id + 1) & MAX_IDR_MASK;
> >                         ent->pv_cm_id = (u32)id;
> >                         sl_id_map_add(ibdev, ent);
> >                 }
> 
> Andrew, any preference on how to handle this merge?

I'm fixing up that patch as things change under its feet.  I usually
merge things like this late in the merge window after everything else
has landed, to cause minimum breakage/disruption.

If there was something in linux-next which didn't get into the merge
window (bad) then I cheerily break it and the tree maintainer fixes
things up.


