Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab2AVLpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 06:45:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab2AVLpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 06:45:39 -0500
Date: Sun, 22 Jan 2012 13:47:46 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] virtio: fix typos of memory barriers
Message-ID: <20120122114746.GC27222@redhat.com>
References: <20120120081658.50747.10625.stgit@amd-6168-8-1.englab.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120081658.50747.10625.stgit@amd-6168-8-1.englab.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 04:16:59PM +0800, Jason Wang wrote:
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Good catch.
Note: this fixes a bug introduced by
7b21e34fd1c272e3a8c3846168f2f6287a4cd72b.
It's probably a good idea to mention
this is the commit log.

Acked-by: Michael S. Tsirkin <mst@redhat.com>



> ---
>  drivers/virtio/virtio_ring.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 79e1b29..78428a8 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -35,7 +35,7 @@
>  #define virtio_rmb(vq) \
>  	do { if ((vq)->weak_barriers) smp_rmb(); else rmb(); } while(0)
>  #define virtio_wmb(vq) \
> -	do { if ((vq)->weak_barriers) smp_rmb(); else rmb(); } while(0)
> +	do { if ((vq)->weak_barriers) smp_wmb(); else wmb(); } while(0)
>  #else
>  /* We must force memory ordering even if guest is UP since host could be
>   * running on another CPU, but SMP barriers are defined to barrier() in that
