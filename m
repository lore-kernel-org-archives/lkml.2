Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab2IDOUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:20:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757158Ab2IDOUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:20:37 -0400
Date: Tue, 4 Sep 2012 17:21:54 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, rusty@rustcorp.com.au, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Message-ID: <20120904142154.GL9805@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
 <1346154857-12487-6-git-send-email-pbonzini@redhat.com>
 <20120904124800.GE9805@redhat.com>
 <504606F6.4080603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504606F6.4080603@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 03:49:42PM +0200, Paolo Bonzini wrote:
> Il 04/09/2012 14:48, Michael S. Tsirkin ha scritto:
> >> > This patch adds queue steering to virtio-scsi.  When a target is sent
> >> > multiple requests, we always drive them to the same queue so that FIFO
> >> > processing order is kept.  However, if a target was idle, we can choose
> >> > a queue arbitrarily.  In this case the queue is chosen according to the
> >> > current VCPU, so the driver expects the number of request queues to be
> >> > equal to the number of VCPUs.  This makes it easy and fast to select
> >> > the queue, and also lets the driver optimize the IRQ affinity for the
> >> > virtqueues (each virtqueue's affinity is set to the CPU that "owns"
> >> > the queue).
> >> > 
> >> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > I guess an alternative is a per-target vq.
> > Is the reason you avoid this that you expect more targets
> > than cpus? If yes this is something you might want to
> > mention in the log.
> 
> One reason is that, even though in practice I expect roughly the same
> number of targets and VCPUs, hotplug means the number of targets is
> difficult to predict and is usually fixed to 256.
> 
> The other reason is that per-target vq didn't give any performance
> advantage.  The bonus comes from cache locality and less process
> migrations, more than from the independent virtqueues.
> 
> Paolo

Okay, and why is per-target worse for cache locality?

-- 
MST
