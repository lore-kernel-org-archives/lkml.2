Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab1DEFIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 01:08:39 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36627 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab1DEFIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 01:08:36 -0400
Message-ID: <4D9AA3BC.6030907@fusionio.com>
Date: Tue, 05 Apr 2011 07:08:12 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Takuma Umeya <tumeya@redhat.com>
CC: "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Christoph Hellwig <hch@lst.de>,
        john cooper <john.cooper@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] virtio_blk: decrement index when blockdevice is removed
References: <1969774563.659835.1301978981017.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1969774563.659835.1301978981017.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-05 06:49, Takuma Umeya wrote:
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
>  
>  static const struct virtio_device_id id_table[] = {

What happens when you delete a device that isn't the last one?

-- 
Jens Axboe

