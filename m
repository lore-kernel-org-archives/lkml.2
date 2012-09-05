Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab2IEOuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:50:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab2IEOua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:50:30 -0400
Date: Wed, 5 Sep 2012 17:51:53 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 1/2] kvm: Use a reserved IRQ source ID for irqfd
Message-ID: <20120905145153.GA11048@redhat.com>
References: <20120821190800.24958.74812.stgit@bling.home>
 <20120821192903.24958.90138.stgit@bling.home>
 <20120821195813.GD9027@redhat.com>
 <1345579579.29292.67.camel@ul30vt.home>
 <20120821204125.GF9027@redhat.com>
 <1345583694.29292.91.camel@ul30vt.home>
 <20120822004138.GM9027@redhat.com>
 <5047633F.9020405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5047633F.9020405@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 05:35:43PM +0300, Avi Kivity wrote:
> On 08/22/2012 03:41 AM, Michael S. Tsirkin wrote:
> >> 
> >> I assumed you were pointing out the level vs edge interaction.  If we
> >> call that a userspace bug, I can just drop this.  Thanks,
> >> 
> >> Alex
> > 
> > level is userspace bug I think :)
> 
> I don't see how it's a bug.  Suppose we have a vfio device that shares a
> gsi with an emulated device.  The emulated device naturally uses
> KVM_IRQ_LINE (it has no need to re-sample on ADN), while vfio naturally
> has to use irqfd.

Absolutely. But vfio needs to use irqfd with the new flag.
Using existing irqfd for level is a bug.

> Note one would expect that each irqfd gets its own irq source id, since
> they are all independent level sources.  The reason they don't is that
> we shut them down anyway and let the sources re-trigger (it is more
> accurate to say that they have no irq source id, but that would just
> muddle the implementation).
> 
> Alex, if the conclusion is that we do need this patch, then please add a
> comment explaining why we can share the source id among all irqfd users.
> 
> -- 
> error compiling committee.c: too many arguments to function
