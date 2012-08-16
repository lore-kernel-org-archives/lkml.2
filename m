Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab2HPQp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:45:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab2HPQp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:45:57 -0400
Message-ID: <1345135555.4683.480.camel@ul30vt.home>
Subject: Re: [PATCH v8 0/6] kvm: level irqfd support
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: mst@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 10:45:55 -0600
In-Reply-To: <502D2099.7050800@redhat.com>
References: <20120810223633.809.44188.stgit@bling.home>
	 <502D2099.7050800@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 19:32 +0300, Avi Kivity wrote:
> On 08/11/2012 01:37 AM, Alex Williamson wrote:
> > v8:
> > 
> > Trying a new approach.  Nobody seems to like the internal IRQ
> > source ID object and the interactions it implies between irqfd
> > and eoifd, so let's get rid of it.  Instead, simply expose
> > IRQ source IDs to userspace.  This lets the user be in charge
> > of freeing them or hanging onto a source ID for later use.  They
> > can also detach and re-attach components at will.  It also opens
> > up the possibility that userspace might want to use each IRQ
> > source ID for more than one GSI (and avoids the kernel needing
> > to manage that).  Per suggestions, EOIFD is now IRQ_ACKFD.
> > 
> > I really wanted to add a de-assert-only option to irqfd so the
> > irq_ackfd could be fed directly into an irqfd, but I'm dependent
> > on the ordering of de-assert _then_ signal an eventfd.  Keeping
> > that ordering doesn't seem to be possible, especially since irqfd
> > uses a workqueue, if I attempt to make that connection.  Thanks,
> 
> I can't say I'm happy with exposing irq source IDs.  It's true that they
> correspond to a physical entity so they can't be said to be an
> implementation detail, but adding more ABIs has a cost and I can't say
> that I see another user for this.
> 
> Can you provide a link to the combined irqfd+ackfd implementation?  I'm
> inclined now to go for the simplest solution possible.

As soon as I write it :)  Keeping lists to handle the one-to-many
deassert-to-notify will notch up the complexity, but it'll be
interesting to see how it compares.  Thanks,

Alex

