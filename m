Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332Ab2EKX6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:58:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761178Ab2EKX6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:58:30 -0400
Message-ID: <1336780681.12477.198.camel@bling.home>
Subject: Re: [PATCH 01/13] driver core: Add iommu_group tracking to struct
 device
From: Alex Williamson <alex.williamson@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com
Date: Fri, 11 May 2012 17:58:01 -0600
In-Reply-To: <20120511233821.GA9335@kroah.com>
References: <20120511222148.30496.68571.stgit@bling.home>
	 <20120511225534.30496.54563.stgit@bling.home>
	 <20120511233821.GA9335@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 16:38 -0700, Greg KH wrote:
> On Fri, May 11, 2012 at 04:55:35PM -0600, Alex Williamson wrote:
> > IOMMU groups allow IOMMU drivers to represent DMA visibility
> > and isolation of devices.  Multiple devices may be grouped
> > together for the purposes of DMA.  Placing a pointer on
> > struct device enable easy access for things like streaming
> > DMA programming and drivers like VFIO.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> Can't you get this today from the iommu_ops pointer that is on the bus
> that the device is associated with?  Or can devices on a bus have
> different iommu_group pointers?

The latter, each device on a bus might be it's own group.  This is often
the case on x86 unless PCIe-to-PCI bridges obscure the device
visibility.  Thanks,

Alex

