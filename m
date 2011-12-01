Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab1LABEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 20:04:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab1LABEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 20:04:22 -0500
Date: Wed, 30 Nov 2011 17:04:08 -0800
From: Chris Wright <chrisw@redhat.com>
To: David Gibson <dwg@au1.ibm.com>, Chris Wright <chrisw@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        agraf@suse.de, scottwood@freescale.com, B08248@freescale.com
Subject: Re: [PATCH 1/4] iommu: Add iommu_device_group callback and
 iommu_group sysfs entry
Message-ID: <20111201010408.GH29071@x200.localdomain>
References: <20111021195412.8438.9951.stgit@s20.home>
 <20111021195605.8438.81609.stgit@s20.home>
 <20111130024205.GF5435@truffala.fritz.box>
 <1322628672.21641.39.camel@pasglop>
 <1322630751.19120.222.camel@bling.home>
 <20111201000337.GA5427@truffala.fritz.box>
 <20111201005220.GG29071@x200.localdomain>
 <20111201005725.GE5427@truffala.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201005725.GE5427@truffala.fritz.box>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Gibson (dwg@au1.ibm.com) wrote:
> On Wed, Nov 30, 2011 at 04:52:20PM -0800, Chris Wright wrote:
> > * David Gibson (dwg@au1.ibm.com) wrote:
> > > On Tue, Nov 29, 2011 at 10:25:51PM -0700, Alex Williamson wrote:
> > > > Note that iommu drivers are registered per bus_type, so the unique pair
> > > > is {bus_type, groupid}, which seems sufficient for vfio.
> > > 
> > > Hrm.  That's.. far from obvious.  And still breaks down if we have two
> > > separate iommus on the same bus type (e.g. two independent PCI host
> > > bridges with inbuilt IOMMUs).
> > 
> > Happens to still work for Intel IOMMU on x86 the way Alex wrote the
> > Intel VT-d patch in this series, as well as AMD IOMMU.  The caveat for
> > AMD IOMMU is that the groupid generation would break (as-is) once
> > there's support for multiple PCI segments.  This is not an inherent
> > shortcoming of the groupid mechanism though, just a current limitation
> > of AMD IOMMU's implementation.  Alex overloaded B:D.F for those which is
> > a convenient id since that maps to the device (or in the case of devices
> > behind a PCIe-to-PCI bridge, the requestor ID of all devices behind the
> > bridge, or "the group").
> 
> "Happens to still work" is not exactly a ringing endorsement.

Heh.  Put it another way.  Generating the group ID is left up to the
IOMMU.  This will break down when there's a system with multiple IOMMU's
on the same bus_type that don't have any awareness of one another.  This
is not the case for the existing series and x86 hw.

I'm not opposed to doing the allocation and ptr as id (taking care for
possibility that PCI hotplug/unplug/replug could reuse the same memory
for group id, however).  Just pointing out that the current system works
as is, and there's some value in it's simplicity (overloading ID ==
group structure + pretty printing ID in sysfs, for example).

thanks,
-chris
