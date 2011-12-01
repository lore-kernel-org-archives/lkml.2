Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab1LAIz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:55:26 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52779 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab1LAIzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:55:25 -0500
Message-ID: <1322729712.3702.8.camel@lappy>
Subject: Re: [PATCH 1/2] virtio-scsi: first version
From: Sasha Levin <levinsasha928@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi <linux-scsi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Date: Thu, 01 Dec 2011 10:55:12 +0200
In-Reply-To: <4ED73CA3.5080409@redhat.com>
References: <1322661299-28855-1-git-send-email-pbonzini@redhat.com>
	  <1322661299-28855-2-git-send-email-pbonzini@redhat.com>
	 <1322721200.3651.24.camel@lappy> <4ED73CA3.5080409@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 09:36 +0100, Paolo Bonzini wrote:
> On 12/01/2011 07:33 AM, Sasha Levin wrote:
> > On Wed, 2011-11-30 at 14:54 +0100, Paolo Bonzini wrote:
> >> The virtio-scsi HBA is the basis of an alternative storage stack
> >> for QEMU-based virtual machines (including KVM).  Compared to
> >> virtio-blk it is more scalable, because it supports many LUNs
> >> on a single PCI slot), more powerful (it more easily supports
> >> passthrough of host devices to the guest) and more easily
> >> extensible (new SCSI features implemented by QEMU should not
> >> require updating the driver in the guest).
> >>
> >> Signed-off-by: Paolo Bonzini<pbonzini@redhat.com>
> >> ---
> >>   drivers/scsi/Kconfig       |    8 +
> >>   drivers/scsi/Makefile      |    1 +
> >>   drivers/scsi/virtio_scsi.c |  478 ++++++++++++++++++++++++++++++++++++++++++++
> >>   include/linux/virtio_ids.h |    1 +
> >    include/linux/virtio_scsi.h is missing here.

I was actually hoping you could send the .h so I could do some hacking
on it :)

> > Maybe default to one if not specified (=0), like in virtio-blk.
> 
> Good idea.  Though with sg_elems=1 it is insanely slow.

It's either that or fail on sg_elems=0, since currently if it's 0 it
looks like the failure will be non-obvious.

> > Shouldn't these kmemcaches be per-device and not globally shared between
> > all devices?
> 
> In practice it will be rare (and it's part of the design) to have more 
> than one virtio-scsi device (perhaps two: one for passthrough and one 
> for other block devices).  If the kmemcaches are a bottleneck, what you 
> want is making them per-virtqueue.  Fixing it is simple if it turns out 
> to be a problem, and it is simpler if I do it together with multi-vq 
> support.

I guess we should just remember test that when multi-vq support is
added.

-- 

Sasha.

