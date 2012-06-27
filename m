Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab2F0Odn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:33:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976Ab2F0Odm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:33:42 -0400
Message-ID: <1340807620.1207.210.camel@bling.home>
Subject: Re: [PATCH v2 0/6] kvm: level triggered irqfd support
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Date: Wed, 27 Jun 2012 08:33:40 -0600
In-Reply-To: <20120627095814.GJ17507@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
	 <20120627095814.GJ17507@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 12:58 +0300, Michael S. Tsirkin wrote:
> On Tue, Jun 26, 2012 at 11:08:52PM -0600, Alex Williamson wrote:
> > Ok, let's see how this flies.  I actually quite like this, so be
> > gentle tearing it apart ;)
> > 
> > I just couldn't bring myself to contort KVM_IRQFD into something
> > that either sets up an irqfd or specifies a nearly unrelated EOI
> > eventfd.  The solution I've come up with, that also avoids exposing
> > irq_source_ids to userspace, is to work through the irqfd.  If we
> > setup a level irqfd, we can optionally associate an eoifd with
> > the same irq_source_id, by passing the irqfd.  To do this, we just
> > need to create a new reference counted object for the source ID
> > so we don't run into problems ordering release.  This means we
> > end up with a KVM_EOIFD ioctl that has both general usefulness and
> > can still tie into an irqfd.
> 
> I like this API.

Yay!  I'll work on the bugs you've spotted.

> > In patch 6/6 I also include an alternate de-assert mechanism via an
> > irqfd with the opposite polarity.  I don't currently use this, but
> > it's pretty trivial and at least available in archives now.
> 
> The nasty bit about that is that if you assert twice then
> deassert once it's not clear what should happen.
> But yea, it does not hurt to put them in the archives.

It's no different that KVM_IRQ_LINE in that sense.  It's not an
accumulator, it's a set state.  Thanks,

Alex

