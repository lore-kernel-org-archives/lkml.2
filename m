Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab2F1Imf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 04:42:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab2F1Imd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 04:42:33 -0400
Date: Thu, 28 Jun 2012 11:42:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 0/6] kvm: level triggered irqfd support
Message-ID: <20120628084236.GF12447@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
 <20120627095814.GJ17507@redhat.com>
 <1340807620.1207.210.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340807620.1207.210.camel@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 08:33:40AM -0600, Alex Williamson wrote:
> On Wed, 2012-06-27 at 12:58 +0300, Michael S. Tsirkin wrote:
> > On Tue, Jun 26, 2012 at 11:08:52PM -0600, Alex Williamson wrote:
> > > Ok, let's see how this flies.  I actually quite like this, so be
> > > gentle tearing it apart ;)
> > > 
> > > I just couldn't bring myself to contort KVM_IRQFD into something
> > > that either sets up an irqfd or specifies a nearly unrelated EOI
> > > eventfd.  The solution I've come up with, that also avoids exposing
> > > irq_source_ids to userspace, is to work through the irqfd.  If we
> > > setup a level irqfd, we can optionally associate an eoifd with
> > > the same irq_source_id, by passing the irqfd.  To do this, we just
> > > need to create a new reference counted object for the source ID
> > > so we don't run into problems ordering release.  This means we
> > > end up with a KVM_EOIFD ioctl that has both general usefulness and
> > > can still tie into an irqfd.
> > 
> > I like this API.
> 
> Yay!  I'll work on the bugs you've spotted.
> 
> > > In patch 6/6 I also include an alternate de-assert mechanism via an
> > > irqfd with the opposite polarity.  I don't currently use this, but
> > > it's pretty trivial and at least available in archives now.
> > 
> > The nasty bit about that is that if you assert twice then
> > deassert once it's not clear what should happen.
> > But yea, it does not hurt to put them in the archives.
> 
> It's no different that KVM_IRQ_LINE in that sense.  It's not an
> accumulator, it's a set state.  Thanks,
> 
> Alex

Yes but eventfd semantics are that of an accumulator so this
does not match what a normal eventfd does very well.
Anyway, as it's not required now we can argue about it
when we get to it.

-- 
MST
