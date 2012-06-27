Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab2F0J6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:58:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538Ab2F0J6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:58:12 -0400
Date: Wed, 27 Jun 2012 12:58:14 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 0/6] kvm: level triggered irqfd support
Message-ID: <20120627095814.GJ17507@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627044758.23698.249.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 11:08:52PM -0600, Alex Williamson wrote:
> Ok, let's see how this flies.  I actually quite like this, so be
> gentle tearing it apart ;)
> 
> I just couldn't bring myself to contort KVM_IRQFD into something
> that either sets up an irqfd or specifies a nearly unrelated EOI
> eventfd.  The solution I've come up with, that also avoids exposing
> irq_source_ids to userspace, is to work through the irqfd.  If we
> setup a level irqfd, we can optionally associate an eoifd with
> the same irq_source_id, by passing the irqfd.  To do this, we just
> need to create a new reference counted object for the source ID
> so we don't run into problems ordering release.  This means we
> end up with a KVM_EOIFD ioctl that has both general usefulness and
> can still tie into an irqfd.

I like this API.

> In patch 6/6 I also include an alternate de-assert mechanism via an
> irqfd with the opposite polarity.  I don't currently use this, but
> it's pretty trivial and at least available in archives now.

The nasty bit about that is that if you assert twice then
deassert once it's not clear what should happen.
But yea, it does not hurt to put them in the archives.

> 
> I don't address whether injecting an edge irqfd really needs an assert
> followed by de-assert (I don't know).  This new interface really
> unties itself from caring.  We might be able to consolidate inject
> functions at some future point, but it doesn't change how we'd name
> flags as it did in the previous version.  Thanks,
> 
> Alex

