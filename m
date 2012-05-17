Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239Ab2EQHTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 03:19:54 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40176 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761142Ab2EQHTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 03:19:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120511225555.30496.80525.stgit@bling.home>
References: <20120511222148.30496.68571.stgit@bling.home>
	<20120511225555.30496.80525.stgit@bling.home>
Date: Thu, 17 May 2012 15:19:51 +0800
X-Google-Sender-Auth: x1afFdZAnynH0rfBTepEkLBjIQA
Message-ID: <CAJtEV7YMrsttPfAdL0_uht-ZRwCHhYwHTvypCc6TfEzTEGaijQ@mail.gmail.com>
Subject: Re: [PATCH 04/13] pci: New pci_dma_quirk()
From: Anonymous <anonymous@livebluemarble.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, kvm@vger.kernel.org,
        B07421@freescale.com, linux-pci@vger.kernel.org, agraf@suse.de,
        qemu-devel@nongnu.org, chrisw@sous-sol.org, B08248@freescale.com,
        iommu@lists.linux-foundation.org, avi@redhat.com,
        gregkh@linuxfoundation.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, benve@cisco.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex,

On Sat, May 12, 2012 at 6:55 AM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> Integrating IOMMU groups more closely into the driver core allows
> us to more easily work around DMA quirks.  The Ricoh multifunction
> controller is a favorite example of devices that are currently
> incompatible with IOMMU isolation as all the functions use the
> requestor ID of function 0 for DMA.  Passing this device into
> pci_dma_quirk returns the PCI device to use for DMA.  The IOMMU
> driver can then construct an IOMMU group including both devices.
>

Please give some thought to the Marvell SATA controller quirk as well.

Instead of multiple visible functions using the same requester ID of
function 0, the Marvell device only makes function 0 visible, but uses
the requestor ID of function 1 as well during DMA.

See https://bugzilla.redhat.com/show_bug.cgi?id=757166

--
A.
