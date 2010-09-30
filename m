Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0I3SnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 14:43:05 -0400
Received: from 8bytes.org ([88.198.83.132]:42128 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab0I3SnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 14:43:04 -0400
Date: Thu, 30 Sep 2010 20:43:01 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        joerg.roedel@amd.com, jbarnes@virtuousgeek.org
Subject: Re: [PATCH] pci: Reenable the AMD IOMMU if it's mysteriously
	vanished over suspend
Message-ID: <20100930184301.GP15338@8bytes.org>
References: <1285861108-24122-1-git-send-email-mjg@redhat.com> <20100930173945.GA16596@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930173945.GA16596@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 06:39:45PM +0100, Matthew Garrett wrote:
> On Thu, Sep 30, 2010 at 11:38:28AM -0400, Matthew Garrett wrote:
> > AMD's reference BIOS code had a bug that could result in the firmware
> > failing to reenable the iommu on resume. It transpires that this causes
> > certain less than desirable behaviour when it comes to PCI accesses, to
> > whit them ending up somewhere near Bristol when the more desirable outcome
> > was Edinburgh. Sadness ensues, perhaps along with filesystem corruption.
> > Let's make sure that it gets turned back on.
> 
> Of course, this isn't actually sufficient - nothing in the iommu code 
> appears to reprogram the BAR, for instance. Joerg, how is this meant to 
> work?

Enabling the IOMMU device is only part of what the BIOS is supposed to
do to get the IOMMU ready for the OS. A handful of registers in the
config space of the device and the IOMMU MMIO region must also be
restored. Thats the simple part. The IOMMU device also spans two
indirect register spaces to configure the IOMMU caches. I have no idea
yet how this need to be configured. The plan is definitly to
work-around a missing IOMMU device in the IOMMU driver. But I am still
talking to some people to find out what exactly must be done, especially
with the indirect register spaces.


	Joerg


