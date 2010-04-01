Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab0DAMw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 08:52:27 -0400
Received: from 8bytes.org ([88.198.83.132]:41086 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112Ab0DAMwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 08:52:20 -0400
Date: Thu, 1 Apr 2010 14:52:18 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Tom Lyon <pugs@lyon-about.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for
	non-privileged processes
Message-ID: <20100401125218.GE24846@8bytes.org>
References: <201003311708.38961.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003311708.38961.pugs@lyon-about.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 05:08:38PM -0700, Tom Lyon wrote:
> uio_pci_generic has previously been discussed on the KVM list, but this patch 
> has nothing to do with KVM, so it is also going to LKML.

But since you send it to the KVM list it should be suitable for KVM too,
no?

> The point of this patch is to beef up the uio_pci_generic driver so that a 
> non-privileged user process can run a user level driver for most PCIe 
> devices. This can only be safe if there is an IOMMU in the system with 
> per-device domains.  Privileged users (CAP_SYS_RAWIO) are allowed if there is 
> no IOMMU.

If you rely on an IOMMU you can use the IOMMU-API instead of the DMA-API
for dma mappings. This change makes this driver suitable for KVM use
too. If the interface is designed clever enough we can even use it for
IOMMU emulation for pass-through devices.

	Joerg

