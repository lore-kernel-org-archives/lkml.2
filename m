Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab2IDOqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:46:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757087Ab2IDOqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:46:36 -0400
Date: Tue, 4 Sep 2012 17:47:54 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, rusty@rustcorp.com.au, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Message-ID: <20120904144754.GO9805@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
 <1346154857-12487-6-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346154857-12487-6-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 01:54:17PM +0200, Paolo Bonzini wrote:
> @@ -575,15 +630,19 @@ static struct scsi_host_template virtscsi_host_template = {
>  				  &__val, sizeof(__val)); \
>  	})
>  
> +

Pls don't add empty lines.

>  static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
> -			     struct virtqueue *vq)
> +			     struct virtqueue *vq, bool affinity)
>  {
>  	spin_lock_init(&virtscsi_vq->vq_lock);
>  	virtscsi_vq->vq = vq;
> +	if (affinity)
> +		virtqueue_set_affinity(vq, virtqueue_get_queue_index(vq) -
> +				       VIRTIO_SCSI_VQ_BASE);
>  }
>  

This means in practice if you have less virtqueues than CPUs,
things are not going to work well, will they?

Any idea what to do?

-- 
MST
