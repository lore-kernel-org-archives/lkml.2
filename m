Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab2FFVsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:48:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826Ab2FFVsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:48:05 -0400
Message-ID: <1339019274.23475.333.camel@bling.home>
Subject: Re: [PATCH] PCI: Add Ralink RT2800 broken INTx masking quirk
From: Alex Williamson <alex.williamson@redhat.com>
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jan.kiszka@siemens.com,
        andihartmann@01019freenet.de
Date: Wed, 06 Jun 2012 15:47:54 -0600
In-Reply-To: <20120606212241.6627.98371.stgit@bling.home>
References: <20120606212241.6627.98371.stgit@bling.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


D'oh, stale email for Bjorn.

On Wed, 2012-06-06 at 15:23 -0600, Alex Williamson wrote:
> Passes pci_intx_mask_supported but continues to send interrupts
> as discovered through VFIO-based device assignment.
> 
> http://www.spinics.net/lists/kvm/msg73738.html
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> Depends on Jan's base patch for this quirk:
> http://www.spinics.net/lists/linux-pci/msg15516.html
> 
>  drivers/pci/quirks.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index cbb4358..178f494 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2940,6 +2940,8 @@ static void __devinit quirk_broken_intx_masking(struct pci_dev *dev)
>  }
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CHELSIO, 0x0010,
>  			quirk_broken_intx_masking);
> +DECLARE_PCI_FIXUP_FINAL(0x1814, 0x0601, /* Ralink RT2800 802.11n PCI */
> +			quirk_broken_intx_masking);
>  
>  static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
>  			  struct pci_fixup *end)
> 



