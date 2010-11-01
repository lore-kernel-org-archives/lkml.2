Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0KAVV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:21:28 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:23168 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab0KAVV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:21:26 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EABvMzkyrR7Hu/2dsb2JhbACDG55HcaJ7iiyRVIEigzBzBIRXhX0
X-IronPort-AV: E=Sophos;i="4.58,276,1286150400"; 
   d="scan'208";a="279195716"
From: Tom Lyon <pugs@cisco.com>
Organization: Cisco Systems, Inc.
To: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 0/5] Fixes, non-PCI-2.3 support, EOI enhancements
Date: Mon, 1 Nov 2010 14:22:00 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.3-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, chrisw@redhat.com, mst@redhat.com
References: <20101030164626.885.89216.stgit@s20.home>
In-Reply-To: <20101030164626.885.89216.stgit@s20.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011011422.01165.pugs@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've applied all your patches. Thanks!

On Saturday, October 30, 2010 09:58:55 am Alex Williamson wrote:
> Hi Tom,
> 
> I've updated some patches I've been working on to v5 and wanted to
> see what you think.  I also found a couple minor bugs, fixed in this
> series.
> 
> The main idea is that since the VFIO interface defines that the INTx
> interrupt is disabled when it fires, we should provide an interface
> to re-enable it.  We currently have to do a read-modify-write to PCI
> config space, requring two ioctls.  I introduce an ioctl to do this
> for us.  An important aspect of this is that now we can support
> non-PCI-2.3 devices since re-enabling the interrupt is abstracted
> (with the same caveat as current KVM device assignment, that they
> must get an exclusive interrupt).  The real trick though is that we
> can then also create an irqfd-like mechanism to trigger re-enabling
> interrupts from and eventfd.  This allows qemu to do all the setup
> for connecting interrupts from VFIO into KVM and EOIs from KVM to
> VFIO, then lets userspace get completely out of the way.
> 
> Hope you like it.  Thanks,
> 
> Alex
> ---
> 
> Alex Williamson (5):
>       vfio: Add a new ioctl to support EOI via eventfd
>       vfio: Add support for non-PCI 2.3 compliant devices
>       vfio: Add ioctl to re-enable interrupts
>       vfio: Fix requested regions
>       vfio: Fix the ROM mask
> 
> 
>  drivers/vfio/vfio_intrs.c      |  254
> +++++++++++++++++++++++++++++++++++++--- drivers/vfio/vfio_main.c       | 
>  37 +++++-
>  drivers/vfio/vfio_pci_config.c |    2
>  drivers/vfio/vfio_rdwr.c       |    4 -
>  include/linux/vfio.h           |   14 ++
>  5 files changed, 279 insertions(+), 32 deletions(-)
