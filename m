Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab2B2Tb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:31:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984Ab2B2TbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:31:24 -0500
Message-ID: <1330543855.29701.180.camel@bling.home>
Subject: Re: RFC: Device isolation groups
From: Alex Williamson <alex.williamson@redhat.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org, aik@ozlabs.ru,
        benh@kernel.crashing.org, qemu-devel@nongnu.org, joerg.roedel@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 29 Feb 2012 12:30:55 -0700
In-Reply-To: <20120202012414.GE8700@truffala.fritz.box>
References: <1328071614-8320-1-git-send-email-david@gibson.dropbear.id.au>
	 <1328126919.6937.254.camel@bling.home>
	 <20120202012414.GE8700@truffala.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-02 at 12:24 +1100, David Gibson wrote:
> On Wed, Feb 01, 2012 at 01:08:39PM -0700, Alex Williamson wrote:
> > On Wed, 2012-02-01 at 15:46 +1100, David Gibson wrote:
> > > This patch series introduces a new infrastructure to the driver core
> > > for representing "device isolation groups".  That is, groups of
> > > devices which can be "isolated" in such a way that the rest of the
> > > system can be protected from them, even in the presence of userspace
> > > or a guest OS directly driving the devices.
> > > 
> > > Isolation will typically be due to an IOMMU which can safely remap DMA
> > > and interrupts coming from these devices.  We need to represent whole
> > > groups, rather than individual devices, because there are a number of
> > > cases where the group can be isolated as a whole, but devices within
> > > it cannot be safely isolated from each other - this usually occurs
> > > because the IOMMU cannot reliably distinguish which device in the
> > > group initiated a transaction.  In other words, isolation groups
> > > represent the minimum safe granularity for passthrough to guests or
> > > userspace.
> > > 
> > > This series provides the core infraustrcture for tracking isolation
> > > groups, and example implementations initializing the groups
> > > appropriately for two PCI bridges (which include IOMMUs) found on IBM
> > > POWER systems.
> > > 
> > > Actually using the group information is not included here, but David
> > > Woodhouse has expressed an interest in using a structure like this to
> > > represent operations in iommu_ops more correctly.
> > > 
> > > Some tracking of groups is a prerequisite for safe passthrough of
> > > devices to guests or userspace, such as done by VFIO.  Current VFIO
> > > patches use the iommu_ops->device_group mechanism for this.  However,
> > > that mechanism is awkward, because without an in-kernel concrete
> > > representation of groups, enumerating a group requires traversing
> > > every device on a given bus type.  It also fails to cover some very
> > > plausible IOMMU topologies, because its groups cannot span devices on
> > > multiple bus types.
> > 
> > So far so good, but there's not much meat on the bone yet.
> 
> True..

Any update to this series?  It would be great if we could map out the
functionality to the point of breaking down and distributing work... or
determining if the end result has any value add to what VFIO already
does.  Thanks,

Alex

