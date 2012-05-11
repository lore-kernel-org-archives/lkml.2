Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507Ab2EKXj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:39:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37470 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758980Ab2EKXjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:39:54 -0400
Date: Fri, 11 May 2012 16:39:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com
Subject: Re: [PATCH 02/13] iommu: IOMMU Groups
Message-ID: <20120511233950.GB9335@kroah.com>
References: <20120511222148.30496.68571.stgit@bling.home>
 <20120511225541.30496.34751.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120511225541.30496.34751.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 04:55:41PM -0600, Alex Williamson wrote:
> IOMMU device groups are currently a rather vague associative notion
> with assembly required by the user or user level driver provider to
> do anything useful.  This patch intends to grow the IOMMU group concept
> into something a bit more consumable.
> 
> To do this, we first create an object representing the group, struct
> iommu_group.  This structure is allocated (iommu_group_alloc) and
> filled (iommu_group_add_device) by the iommu driver.  The iommu driver
> is free to add devices to the group using it's own set of policies.
> This allows inclusion of devices based on physical hardware or topology
> limitations of the platform, as well as soft requirements, such as
> multi-function trust levels or peer-to-peer protection of the
> interconnects.  Each device may only belong to a single iommu group,
> which is linked from struct device.iommu_group.  IOMMU groups are
> maintained using kobject reference counting, allowing for automatic
> removal of empty, unreferenced groups.  It is the responsibility of
> the iommu driver to remove devices from the group
> (iommu_group_remove_device).
> 
> IOMMU groups also include a userspace representation in sysfs under
> /sys/kernel/iommu_groups.  When allocated, each group is given a
> dynamically assign ID (int).  The ID is managed by the core IOMMU group
> code to support multiple heterogeneous iommu drivers, which could
> potentially collide in group naming/numbering.  This also keeps group
> IDs to small, easily managed values.  A directory is created under
> /sys/kernel/iommu_groups for each group.  A further subdirectory named
> "devices" contains links to each device within the group.  The iommu_group
> file in the device's sysfs directory, which formerly contained a group
> number when read, is now a link to the iommu group.  Example:
> 
> $ ls -l /sys/kernel/iommu_groups/26/devices/

<snip>

As you are creating new sysfs files and directories, you need to also
add the proper Documentation/ABI/ files at the same time.

thanks,

greg k-h
