Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab2BIJgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 04:36:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab2BIJgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 04:36:12 -0500
Date: Thu, 9 Feb 2012 11:35:59 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Danny Kukawka <dkukawka@suse.de>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 42/50] virtio_net:  use dev_hw_addr_random() instead of
 random_ether_addr()
Message-ID: <20120209093559.GA903@redhat.com>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
 <1328735457-29986-43-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328735457-29986-43-git-send-email-danny.kukawka@bisect.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 10:10:49PM +0100, Danny Kukawka wrote:
> Use dev_hw_addr_random() instead of calling random_ether_addr()
> to set addr_assign_type correctly to NET_ADDR_RANDOM.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4880aa8..69d36e1 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1061,7 +1061,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	if (virtio_config_val_len(vdev, VIRTIO_NET_F_MAC,
>  				  offsetof(struct virtio_net_config, mac),
>  				  dev->dev_addr, dev->addr_len) < 0)
> -		random_ether_addr(dev->dev_addr);
> +		dev_hw_addr_random(dev, dev->dev_addr);
>  
>  	/* Set up our device-specific information */
>  	vi = netdev_priv(dev);
> -- 
> 1.7.7.3
