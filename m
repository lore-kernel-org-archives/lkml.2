Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2DSFk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 01:40:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab2DSFkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 01:40:25 -0400
Date: Thu, 19 Apr 2012 08:40:29 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the vhost tree with the net-next tree
Message-ID: <20120419054028.GB22408@redhat.com>
References: <20120419153547.c9e4cf4865b28c61668a2be1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419153547.c9e4cf4865b28c61668a2be1@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 03:35:47PM +1000, Stephen Rothwell wrote:
> Hi Michael,
> 
> Today's linux-next merge of the vhost tree got a conflict in
> drivers/net/virtio_net.c between commit 586d17c5a01b ("virtio-net: send
> gratuitous packets when needed") from the net-next tree and commit
> 66fdfb7bc203 ("virtio-net: remove useless disable on freeze") from the
> vhost tree.
> 
> Just context changes.  I fixed it up (I think - see below) and can carry
> the fix as necessary.

The fix looks right, thanks a lot.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/net/virtio_net.c
> index fa58c78,3e4767f..0000000
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@@ -1224,16 -1183,6 +1224,11 @@@ static int virtnet_freeze(struct virtio
>   {
>   	struct virtnet_info *vi = vdev->priv;
>   
>  +	/* Prevent config work handler from accessing the device */
>  +	mutex_lock(&vi->config_lock);
>  +	vi->config_enable = false;
>  +	mutex_unlock(&vi->config_lock);
>  +
> - 	virtqueue_disable_cb(vi->rvq);
> - 	virtqueue_disable_cb(vi->svq);
> - 	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ))
> - 		virtqueue_disable_cb(vi->cvq);
> - 
>   	netif_device_detach(vi->dev);
>   	cancel_delayed_work_sync(&vi->refill);
>   


