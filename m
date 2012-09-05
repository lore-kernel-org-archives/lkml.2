Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab2IEPM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:12:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab2IEPM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:12:27 -0400
Date: Wed, 5 Sep 2012 18:13:48 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 1/2] kvm: Use a reserved IRQ source ID for irqfd
Message-ID: <20120905151348.GC11058@redhat.com>
References: <20120821190800.24958.74812.stgit@bling.home>
 <20120821192903.24958.90138.stgit@bling.home>
 <20120821195813.GD9027@redhat.com>
 <1345579579.29292.67.camel@ul30vt.home>
 <20120821204125.GF9027@redhat.com>
 <1345583694.29292.91.camel@ul30vt.home>
 <20120822004138.GM9027@redhat.com>
 <5047633F.9020405@redhat.com>
 <20120905145153.GA11048@redhat.com>
 <504768E2.3020706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504768E2.3020706@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 05:59:46PM +0300, Avi Kivity wrote:
> On 09/05/2012 05:51 PM, Michael S. Tsirkin wrote:
> > On Wed, Sep 05, 2012 at 05:35:43PM +0300, Avi Kivity wrote:
> >> On 08/22/2012 03:41 AM, Michael S. Tsirkin wrote:
> >> >> 
> >> >> I assumed you were pointing out the level vs edge interaction.  If we
> >> >> call that a userspace bug, I can just drop this.  Thanks,
> >> >> 
> >> >> Alex
> >> > 
> >> > level is userspace bug I think :)
> >> 
> >> I don't see how it's a bug.  Suppose we have a vfio device that shares a
> >> gsi with an emulated device.  The emulated device naturally uses
> >> KVM_IRQ_LINE (it has no need to re-sample on ADN), while vfio naturally
> >> has to use irqfd.
> > 
> > Absolutely. But vfio needs to use irqfd with the new flag.
> > Using existing irqfd for level is a bug.
> 
> I see we're not reusing this irq source id for level irqfd.  But I think
> we should, there's no need for per-gsi irq source id.

I agree. All resample irqfds are deasserted at the same time,
tracking them separately gets us nothing.

> Plus I'd like to
> fix the theoretical bug even if it doesn't bite in practice.
> 

I'm not sure what the bug is, for edge, and how a separate ID fixes it.
Could you clarify?

> 
> -- 
> error compiling committee.c: too many arguments to function
