Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab1JCJRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:17:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab1JCJQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:16:56 -0400
Date: Mon, 3 Oct 2011 14:46:46 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] virtio: blk: Add freeze, restore handlers to
 support S4
Message-ID: <20111003091646.GA5192@amit-x200.redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
 <5160f2cf536e7c506a5e90b4cb95e0f2e41c53d9.1317309123.git.amit.shah@redhat.com>
 <20111002093733.GE29706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111002093733.GE29706@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Sun) 02 Oct 2011 [11:37:33], Michael S. Tsirkin wrote:
> On Thu, Sep 29, 2011 at 08:56:02PM +0530, Amit Shah wrote:
> > Delete the vq on the freeze callback to prepare for hibernation.
> > Re-create the vq in the restore callback to resume normal function.
> > 
> > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > ---
> >  drivers/block/virtio_blk.c |   17 +++++++++++++++++
> >  1 files changed, 17 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > index 509760b..9844d2c 100644
> > --- a/drivers/block/virtio_blk.c
> > +++ b/drivers/block/virtio_blk.c
> > @@ -549,6 +549,19 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
> >  	kfree(vblk);
> >  }
> >  
> > +#ifdef CONFIG_PM
> > +static int virtblk_freeze(struct virtio_device *vdev)
> > +{
> > +	vdev->config->del_vqs(vdev);
> 
> What prevents the guest from trying to use the VQ while
> this is in progress? IF it does, what prevents a crash?

An oversight: Sasha pointed this out, too, and I've now fixed this by
adding a call to vdev->config->reset() before deleting vqs.

		Amit
