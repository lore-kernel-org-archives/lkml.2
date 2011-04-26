Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab1DZHmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 03:42:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757756Ab1DZHms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 03:42:48 -0400
Date: Tue, 26 Apr 2011 10:42:30 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Liu Yuan <namei.unix@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio, ring: Use ALIGN macros in virtio_ring.h
Message-ID: <20110426074230.GA10364@redhat.com>
References: <1303791070-15196-1-git-send-email-namei.unix@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303791070-15196-1-git-send-email-namei.unix@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 12:11:10PM +0800, Liu Yuan wrote:
> From: Liu Yuan <tailai.ly@taobao.com>
> 
> 
> Signed-off-by: Liu Yuan <tailai.ly@taobao.com>

Issue is, these functions are exported to userspace,
which does not have these macros.

> ---
>  include/linux/virtio_ring.h |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
> index e4d144b..6299050 100644
> --- a/include/linux/virtio_ring.h
> +++ b/include/linux/virtio_ring.h
> @@ -99,15 +99,13 @@ static inline void vring_init(struct vring *vr, unsigned int num, void *p,
>  	vr->num = num;
>  	vr->desc = p;
>  	vr->avail = p + num*sizeof(struct vring_desc);
> -	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + align-1)
> -			    & ~(align - 1));
> +	vr->used = (void *)PTR_ALIGN(&vr->avail->ring[num], align);
>  }
>  
>  static inline unsigned vring_size(unsigned int num, unsigned long align)
>  {
> -	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (2 + num)
> -		 + align - 1) & ~(align - 1))
> -		+ sizeof(__u16) * 2 + sizeof(struct vring_used_elem) * num;
> +	return ((sizeof(struct vring_desc) * num + ALIGN(sizeof(__u16) * (2 + num), align))
> +		+ sizeof(__u16) * 2 + sizeof(struct vring_used_elem) * num);
>  }
>  
>  #ifdef __KERNEL__
> -- 
> 1.7.1
