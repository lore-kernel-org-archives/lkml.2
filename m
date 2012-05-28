Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab2E1Mx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 08:53:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab2E1Mx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 08:53:27 -0400
Date: Mon, 28 May 2012 15:53:25 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: netdev@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC] virtio-net: remove useless disable on freeze
Message-ID: <20120528125325.GA22576@redhat.com>
References: <20120404091954.GA3776@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120404091954.GA3776@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 12:19:54PM +0300, Michael S. Tsirkin wrote:
> disable_cb is just an optimization: it
> can not guarantee that there are no callbacks.
> 
> I didn't yet figure out whether a callback
> in freeze will trigger a bug, but disable_cb
> won't address it in any case. So let's remove
> the useless calls as a first step.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Looks like this isn't in the 3.5 pull request -
just lost in the shuffle?
disable_cb is advisory so can't be relied upon.

> ---
>  drivers/net/virtio_net.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 019da01..971931e5 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1182,11 +1182,6 @@ static int virtnet_freeze(struct virtio_device *vdev)
>  {
>  	struct virtnet_info *vi = vdev->priv;
>  
> -	virtqueue_disable_cb(vi->rvq);
> -	virtqueue_disable_cb(vi->svq);
> -	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ))
> -		virtqueue_disable_cb(vi->cvq);
> -
>  	netif_device_detach(vi->dev);
>  	cancel_delayed_work_sync(&vi->refill);
>  
> -- 
> 1.7.9.111.gf3fb0
