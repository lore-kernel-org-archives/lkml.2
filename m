Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab0ESWlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 18:41:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab0ESWlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 18:41:05 -0400
Date: Thu, 20 May 2010 01:37:07 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jes.Sorensen@redhat.com
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_blk.c: Add documentation for vring_enable_cb()
Message-ID: <20100519223707.GD4111@redhat.com>
References: <1274284249-29398-1-git-send-email-Jes.Sorensen@redhat.com> <1274284249-29398-2-git-send-email-Jes.Sorensen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274284249-29398-2-git-send-email-Jes.Sorensen@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 05:50:49PM +0200, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> Add documentation for vring_enable_cb() as return logic may not be
> obvious for the caller.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Yes. Confused me too.
Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/virtio/virtio_ring.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 0f90634..2cdcdca 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -333,6 +333,11 @@ static void vring_disable_cb(struct virtqueue *_vq)
>  	vq->vring.avail->flags |= VRING_AVAIL_F_NO_INTERRUPT;
>  }
>  
> +/*
> + * Enable interrupts and check whether there is anything in the queue.
> + * Note, vring_enable_cb() returns TRUE if the queue is empty,  and
> + * FALSE if the queue is not empty and there is work to do.
> + */
>  static bool vring_enable_cb(struct virtqueue *_vq)
>  {
>  	struct vring_virtqueue *vq = to_vvq(_vq);
> -- 
> 1.6.5.2
