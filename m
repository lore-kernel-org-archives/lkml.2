Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab2BHVnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:43:47 -0500
Received: from gate.crashing.org ([63.228.1.57]:58043 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289Ab2BHVnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:43:46 -0500
Message-ID: <1328737405.2903.39.camel@pasglop>
Subject: Re: [PATCH 1/3] Device isolation group infrastructure (v3)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: David Gibson <david@gibson.dropbear.id.au>, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, aik@ozlabs.ru, qemu-devel@nongnu.org,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 09 Feb 2012 08:43:25 +1100
In-Reply-To: <20120208152748.GD22598@amd.com>
References: <1328071614-8320-1-git-send-email-david@gibson.dropbear.id.au>
	 <1328071614-8320-2-git-send-email-david@gibson.dropbear.id.au>
	 <20120208152748.GD22598@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-08 at 16:27 +0100, Joerg Roedel wrote:
> Again, device grouping is done by the IOMMU drivers, so this all
> belongs
> into the generic iommu-code rather than the driver core.
> 
> I think it makes sense to introduce a device->iommu pointer which
> depends on CONFIG_IOMMU_API and put the group information into it.
> This also has the benefit that we can consolidate all the
> device->arch.iommu pointers into device->iommu as well.

 ... and I pressed sent too quickly before.

So not only that, but these patches are simply a mechanism to expose
those groups to userspace and allow ownership (ie synchronize with the
attachment/detachment of kernel drivers).

So this code totally belongs in the driver core.

It does -not- address the issue of deciding how the groups are formed,
for this, it expects the information to be provided by the arch iommu
layer and we'll have to work on that.

The way iommu grouping work is too dependent on a given HW setup, you
can't really do that generically.

Yes, some factors are going to be common, such as the already mentioned
ricoh chip, but I think the best we can do here is provide quirks for
the iommu code to use.

There are capacity limits on how bdfn filtering works on bridges, either
CAM size or simply how it is arranged (ie on power for example, I can
chose to identify a function, a device, or a range of bus numbers but in
the later case it has to be an aligned power of two up to 32), etc...

I wouldn't try to solve that generically just yet.

Cheers,
Ben.


