Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966631Ab2EQPWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:22:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760778Ab2EQPW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:22:27 -0400
Message-ID: <1337268120.2880.4.camel@ul30vt>
Subject: Re: [PATCH 04/13] pci: New pci_dma_quirk()
From: Alex Williamson <alex.williamson@redhat.com>
To: Anonymous <anonymous@livebluemarble.com>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, kvm@vger.kernel.org,
        B07421@freescale.com, linux-pci@vger.kernel.org, agraf@suse.de,
        qemu-devel@nongnu.org, chrisw@sous-sol.org, B08248@freescale.com,
        iommu@lists.linux-foundation.org, avi@redhat.com,
        gregkh@linuxfoundation.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, benve@cisco.com
Date: Thu, 17 May 2012 09:22:00 -0600
In-Reply-To: <CAJtEV7YMrsttPfAdL0_uht-ZRwCHhYwHTvypCc6TfEzTEGaijQ@mail.gmail.com>
References: <20120511222148.30496.68571.stgit@bling.home>
	 <20120511225555.30496.80525.stgit@bling.home>
	 <CAJtEV7YMrsttPfAdL0_uht-ZRwCHhYwHTvypCc6TfEzTEGaijQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 15:19 +0800, Anonymous wrote:
> Alex,
> 
> On Sat, May 12, 2012 at 6:55 AM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > Integrating IOMMU groups more closely into the driver core allows
> > us to more easily work around DMA quirks.  The Ricoh multifunction
> > controller is a favorite example of devices that are currently
> > incompatible with IOMMU isolation as all the functions use the
> > requestor ID of function 0 for DMA.  Passing this device into
> > pci_dma_quirk returns the PCI device to use for DMA.  The IOMMU
> > driver can then construct an IOMMU group including both devices.
> >
> 
> Please give some thought to the Marvell SATA controller quirk as well.
> 
> Instead of multiple visible functions using the same requester ID of
> function 0, the Marvell device only makes function 0 visible, but uses
> the requestor ID of function 1 as well during DMA.
> 
> See https://bugzilla.redhat.com/show_bug.cgi?id=757166

Wow.  That one isn't quite as easy to deal with since there's no
existing device in the kernel to point to.  This comment might be on the
right track:

https://bugzilla.kernel.org/show_bug.cgi?id=42679#c11

Perhaps David Woodhouse can comment on support for phantom functions.
If we had infrastructure for that it might be easy for the quirk to
update the pci_dev struct, inserting a new phantom function.  Otherwise
we'd need to create a new device in the kernel for it.  Thanks,

Alex


