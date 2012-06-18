Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab2FRSaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 14:30:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33845 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2FRSaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 14:30:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120607170026.3174.52434.stgit@bling.home>
References: <20120607170026.3174.52434.stgit@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 18 Jun 2012 12:30:01 -0600
Message-ID: <CAErSpo4hNzsuE6BgMK1okJdvtu-ghkTh8onSy1Zn7ZXg0UPuLQ@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: Add Ralink RT2800 broken INTx masking quirk
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jan.kiszka@siemens.com,
        andihartmann@01019freenet.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 11:01 AM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> Passes pci_intx_mask_supported test but continues to send interrupts
> as discovered through VFIO-based device assignment.
>
> http://www.spinics.net/lists/kvm/msg73738.html
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Tested-by: Andreas Hartmann <andihartmann@01019freenet.de>
> ---
>
> v2: context-only respin for Jan's v2 patch
>
> Depends on Jan's patch:
> http://www.spinics.net/lists/linux-pci/msg15720.html
>
>  drivers/pci/quirks.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 87b9edd..3681678 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2940,6 +2940,8 @@ static void __devinit quirk_broken_intx_masking(struct pci_dev *dev)
>  }
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CHELSIO, 0x0030,
>                        quirk_broken_intx_masking);
> +DECLARE_PCI_FIXUP_FINAL(0x1814, 0x0601, /* Ralink RT2800 802.11n PCI */
> +                       quirk_broken_intx_masking);
>
>  static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
>                          struct pci_fixup *end)
>

Applied to my "next" branch (as HEADER quirk, not FINAL).  Thanks!

Bjorn
