Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab2HORYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 13:24:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653Ab2HORYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 13:24:05 -0400
Message-ID: <1345051443.4683.425.camel@ul30vt.home>
Subject: Re: [PATCH v8 6/6] kvm: Add de-assert option to KVM_IRQ_ACKFD
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 15 Aug 2012 11:24:03 -0600
In-Reply-To: <20120815141113.GE3068@redhat.com>
References: <20120810223633.809.44188.stgit@bling.home>
	 <20120810223754.809.60610.stgit@bling.home>
	 <20120815141113.GE3068@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 17:11 +0300, Michael S. Tsirkin wrote:
> On Fri, Aug 10, 2012 at 04:37:56PM -0600, Alex Williamson wrote:
> > It's likely (vfio) that one of the reasons to watch for an IRQ ACK
> > is to de-assert and re-enable an interrupt.  As the IRQ ACK notfier
> > is already watching a GSI for an IRQ source ID we can easily couple
> > these together.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> This source id is required the only way to assert
> in the 1st place is with irqfd.

ioctl(fd, KVM_IRQ_ACKFD, kvm_irq_ackfd.{flags = 0, fd = eventfd, gsi = $GSI});
ioctl(fd, KVM_IRQ_LINE, kvm_irq_level.{irq = $GSI, level = 1);
/* eventfd notification */
ioctl(fd, KVM_IRQ_LINE, kvm_irq_level.{irq = $GSI, level = 0);

> So why is this an ackfd flag and not an irqfd flag?
> I am guessing because this way you do not need
> an extra ack notifier, but isn't this an internal
> optimization leaking out to userspace?

If irqfd were to setup it's own irq ack notifier for de-assert, we can
guarantee the ordering of de-assert vs eventfd trigger.  So, whoever
does one, needs to do both.  Thanks,

Alex

