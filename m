Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab2FYGc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:32:57 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44017 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab2FYGcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:32:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120625123108.06ef7f883a323df5221edc98@canb.auug.org.au>
References: <20120625123108.06ef7f883a323df5221edc98@canb.auug.org.au>
Date: Mon, 25 Jun 2012 14:32:54 +0800
Message-ID: <CAC=cRTOPWSQmuxWtkpGDxiEeqoG=CEr985-qCLP+HAg6BPk7nA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the pci tree with Linus' tree
From: huang ying <huang.ying.caritas@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Huang Ying <ying.huang@intel.com>, Zheng Yan <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Stephen,

On Mon, Jun 25, 2012 at 10:31 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
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
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc drivers/pci/pci.c
> index 77cb54a,3f8b74f..0000000
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@@ -1744,11 -1803,10 +1803,15 @@@ int pci_prepare_to_sleep(struct pci_de
>        if (target_state == PCI_POWER_ERROR)
>                return -EIO;
>
> +       /* D3cold during system suspend/hibernate is not supported */
> +       if (target_state > PCI_D3hot)
> +               target_state = PCI_D3hot;
> +
>  +      /* Some devices mustn't be in D3 during system sleep */
>  +      if (target_state == PCI_D3hot &&
>  +                      (dev->dev_flags & PCI_DEV_FLAGS_NO_D3_DURING_SLEEP))
>  +              return 0;
>  +
>        pci_enable_wake(dev, target_state, device_may_wakeup(&dev->dev));
>
>        error = pci_set_power_state(dev, target_state);

I found this conflict during development too.  I think the fixing is
correct.  Thanks.

Best Regards,
Huang Ying
