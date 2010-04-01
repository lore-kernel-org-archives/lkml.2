Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab0DAPnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:43:22 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:35541 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab0DAPnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:43:15 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAB9ctEurRN+K/2dsb2JhbACbPnGcaZkZhQEEgyM
X-IronPort-AV: E=Sophos;i="4.51,349,1267401600"; 
   d="scan'208";a="175977927"
From: Tom Lyon <pugs@lyon-about.com>
To: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for non-privileged processes
Date: Thu, 1 Apr 2010 08:40:34 -0700
User-Agent: KMail/1.9.9
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201003311708.38961.pugs@lyon-about.com> <20100401125218.GE24846@8bytes.org>
In-Reply-To: <20100401125218.GE24846@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004010840.34574.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010 05:52:18 am Joerg Roedel wrote:
> On Wed, Mar 31, 2010 at 05:08:38PM -0700, Tom Lyon wrote:
> > uio_pci_generic has previously been discussed on the KVM list, but this
> > patch has nothing to do with KVM, so it is also going to LKML.
>
> But since you send it to the KVM list it should be suitable for KVM too,
> no?
I know not.

>
> > The point of this patch is to beef up the uio_pci_generic driver so that
> > a non-privileged user process can run a user level driver for most PCIe
> > devices. This can only be safe if there is an IOMMU in the system with
> > per-device domains.  Privileged users (CAP_SYS_RAWIO) are allowed if
> > there is no IOMMU.
>
> If you rely on an IOMMU you can use the IOMMU-API instead of the DMA-API
> for dma mappings. This change makes this driver suitable for KVM use
> too. If the interface is designed clever enough we can even use it for
> IOMMU emulation for pass-through devices.
The use with privileged processes and no IOMMUs is still quite useful, so I'd 
rather stick with the DMA interface.

