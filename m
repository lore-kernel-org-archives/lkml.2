Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab2FXPCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 11:02:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab2FXPCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 11:02:41 -0400
Message-ID: <1340550156.14120.53.camel@bling.home>
Subject: Re: [PATCH 4/4][RFC] kvm: eoi_eventfd
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com,
        mst@redhat.com
Date: Sun, 24 Jun 2012 09:02:36 -0600
In-Reply-To: <4FE70E99.90609@redhat.com>
References: <20120622220040.9858.43665.stgit@bling.home>
	 <20120622221626.9858.33817.stgit@bling.home> <4FE70E99.90609@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-06-24 at 15:56 +0300, Avi Kivity wrote:
> On 06/23/2012 01:16 AM, Alex Williamson wrote:
> > I think we're probably also going to need something like this.
> > When running in non-accelerated qemu, we're going to have to
> > create some kind of EOI notifier for drivers.  VFIO can make
> > additional improvements when running on KVM so it will probably
> > make use of the KVM_IRQFD_LEVEL_EOI interface, but we don't
> > want to have a generic EOI notifier in qemu that just stops
> > working when kvm-ioapic is enabled.
> 
> Why?

Hmm, I must be missing something or not describing it correctly, because
it seems obvious.  If we create a dependency in qemu of needing to know
when an eoi occurs and notifier a driver and have no way to fulfill that
dependency when running on kvm... that'd be bad, right?  I don't want to
assume that every consumer of such an interface would prefer to make use
of an irqfd.  Not sure if that answers your question though.  Thanks,

Alex

