Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab2FYOOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 10:14:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58405 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757121Ab2FYOON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 10:14:13 -0400
Date: Mon, 25 Jun 2012 10:14:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Bjorn Helgaas <bhelgaas@google.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Huang Ying <ying.huang@intel.com>, Zheng Yan <zheng.z.yan@intel.com>
Subject: Re: linux-next: manual merge of the pci tree with Linus' tree
In-Reply-To: <20120625123108.06ef7f883a323df5221edc98@canb.auug.org.au>
Message-ID: <Pine.LNX.4.44L0.1206251012470.1770-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012, Stephen Rothwell wrote:

> Hi Bjorn,
> 
> Today's linux-next merge of the pci tree got a conflict in
> drivers/pci/pci.c between commit c2fb8a3fa255 ("USB: add
> NO_D3_DURING_SLEEP flag and revert 151b61284776be2") from Linus' tree and
> commit 448bd857d48e ("PCI/PM: add PCIe runtime D3cold support") from the
> pci tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/pci/pci.c
> index 77cb54a,3f8b74f..0000000
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@@ -1744,11 -1803,10 +1803,15 @@@ int pci_prepare_to_sleep(struct pci_de
>   	if (target_state == PCI_POWER_ERROR)
>   		return -EIO;
>   
> + 	/* D3cold during system suspend/hibernate is not supported */
> + 	if (target_state > PCI_D3hot)
> + 		target_state = PCI_D3hot;
> + 
>  +	/* Some devices mustn't be in D3 during system sleep */
>  +	if (target_state == PCI_D3hot &&
>  +			(dev->dev_flags & PCI_DEV_FLAGS_NO_D3_DURING_SLEEP))
>  +		return 0;
>  +
>   	pci_enable_wake(dev, target_state, device_may_wakeup(&dev->dev));
>   
>   	error = pci_set_power_state(dev, target_state);

This looks right to me too.

Alan Stern

