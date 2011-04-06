Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab1DFTRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 15:17:38 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34267 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab1DFTRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 15:17:36 -0400
Date: Wed, 6 Apr 2011 14:17:25 -0500
From: Ryan Harper <ryanh@us.ibm.com>
To: Takuma Umeya <tumeya@redhat.com>
Cc: virtualization@lists.linux-foundation.org,
        john cooper <john.cooper@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio_blk: decrement index when blockdevice is removed
Message-ID: <20110406191725.GJ5445@us.ibm.com>
References: <1099995365.641718.1301903899721.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com> <1969774563.659835.1301978981017.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1969774563.659835.1301978981017.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Takuma Umeya <tumeya@redhat.com> [2011-04-05 00:00]:
> When virtio block device is removed, index does not get decremented. When 
> another virtio disk is attached it uses the next device letter to the 
> one that is suppose to be available. 
> 
> Signed-off-by: Takuma Umeya <tumeya@redhat.com>
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 6ecf89c..730e7af 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -489,6 +489,7 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
>         mempool_destroy(vblk->pool);
>         vdev->config->del_vqs(vdev);
>         kfree(vblk);
> +       index--;
>  }

What about referencing /dev/disk/by-id  and using drive serial numbers?
How much do we care about re-using minor numbers?  IIRC, virtio-blk can
go out to vdxxx; that's a lot of disks or add/removes.

> 
>  static const struct virtio_device_id id_table[] = {
> 
> -- 
> Umeya, Takuma
> Technical Account Manager
> Red Hat GSS APAC
> +81.3.5798.8584 (direct)
> tumeya@redhat.com
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/virtualization

-- 
Ryan Harper
Software Engineer; Linux Technology Center
IBM Corp., Austin, Tx
ryanh@us.ibm.com
