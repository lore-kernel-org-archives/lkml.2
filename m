Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab2ISNyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:54:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609Ab2ISNyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:54:33 -0400
Message-ID: <1348062872.28860.24.camel@bling.home>
Subject: Re: [PATCH v10 2/2] kvm: Add resampling irqfds for level triggered
 interrupts
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 19 Sep 2012 07:54:32 -0600
In-Reply-To: <50598C1D.4050206@redhat.com>
References: <20120918031156.12021.27838.stgit@bling.home>
	 <20120918031626.12021.90083.stgit@bling.home> <50598975.50503@redhat.com>
	 <20120919090845.GA26517@redhat.com> <50598C1D.4050206@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-19 at 12:10 +0300, Avi Kivity wrote:
> On 09/19/2012 12:08 PM, Michael S. Tsirkin wrote:
> 
> >> Whoa.  Can't we put the resampler entry somewhere we don't need to
> >> search for it?  Like a kvm_kernel_irq_routing_entry, that's indexed by
> >> gsi already (kvm_irq_routing_table::rt_entries[gsi]).
> > 
> > I'm not sure why would we bother optimizing this,
> 
> Not optimizing, simplifying.
> 
> > but if we do, I guess we could look for the irq notifier
> > which is already indexed by gsi.
> 
> It's not, it's looked up in a list.


I'm not sure it's a simplification because to index by gsi we suddenly
need to care how many gsis there are.  I believe that currently means we
have to assume an ioapic.  Creating a dumb list is a little bit of
overhead, but we get to stay blissfully unaware of the gsi
implementation.  Practically we're looking at a list of 4 entries, maybe
a few times that when we expose more PCI root bridges to the guest.
Thanks,

Alex

