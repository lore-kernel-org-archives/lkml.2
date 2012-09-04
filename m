Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab2IDPCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:02:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab2IDPCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:02:06 -0400
Date: Tue, 4 Sep 2012 18:03:23 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, rusty@rustcorp.com.au, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Message-ID: <20120904150323.GA15116@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
 <1346154857-12487-6-git-send-email-pbonzini@redhat.com>
 <20120904144754.GO9805@redhat.com>
 <5046167C.3070109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5046167C.3070109@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 04:55:56PM +0200, Paolo Bonzini wrote:
> Il 04/09/2012 16:47, Michael S. Tsirkin ha scritto:
> >> >  static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
> >> > -			     struct virtqueue *vq)
> >> > +			     struct virtqueue *vq, bool affinity)
> >> >  {
> >> >  	spin_lock_init(&virtscsi_vq->vq_lock);
> >> >  	virtscsi_vq->vq = vq;
> >> > +	if (affinity)
> >> > +		virtqueue_set_affinity(vq, virtqueue_get_queue_index(vq) -
> >> > +				       VIRTIO_SCSI_VQ_BASE);
> >> >  }
> >> >  
> > This means in practice if you have less virtqueues than CPUs,
> > things are not going to work well, will they?
> 
> Not particularly.  It could be better or worse than single queue
> depending on the workload.

Well interrupts will go to CPU different from the one
that sends commands so ...

> > Any idea what to do?
> 
> Two possibilities:
> 
> 1) Add a stride argument to virtqueue_set_affinity, and make it equal to
> the number of queues.
> 
> 2) Make multiqueue the default in QEMU, and make the default number of
> queues equal to the number of VCPUs.
> 
> I was going for (2).
> 
> Paolo

3. use per target queue if less targets than cpus?

-- 
MST

