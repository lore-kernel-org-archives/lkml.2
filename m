Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab2ITTYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 15:24:45 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36784 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab2ITTYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 15:24:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC 3/3] PCI/PM: Disable PME poll for PCIe devices
Date: Thu, 20 Sep 2012 21:31:13 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <1347872076-5260-1-git-send-email-ying.huang@intel.com> <1347872076-5260-4-git-send-email-ying.huang@intel.com>
In-Reply-To: <1347872076-5260-4-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201209202131.13483.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 17, 2012, Huang Ying wrote:
> PME poll is not necessary for PCIe devices, because PCIe devices use
> in-band PME message and IRQ on PCIe port to report PME.

Alas, not all of them as it turns out and even if they do, it doesn't
work for some of them. That's why we've added the PCIe devices polling
(quite recently, for that matter).

If you'd spent some time on some proper research regarding that (like browsing
the changelogs of git commits modifying the relevant part of drivers/pci/pci.c),
you'd have known that already.

And that actually is quite important, because I don't have to remember every
single PM-related change we're making in the PCI layer.  I _incidentally_ do
remember this one, but that may not happen next time.  Please do the research
_before_ proposing changes of this kind.

Thanks,
Rafael


> PME poll is useful for PCI devices.  Because for PCI devices, PME is
> reported via a side-band PME# line and some platform logic, and the
> platform logic is often missing on many systems.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  drivers/pci/pcie/pme.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/pci/pcie/pme.c
> +++ b/drivers/pci/pcie/pme.c
> @@ -313,6 +313,7 @@ static int pcie_pme_set_native(struct pc
>  
>  	device_set_run_wake(&dev->dev, true);
>  	dev->pme_interrupt = true;
> +	dev->pme_poll = false;
>  	return 0;
>  }
>  
> 
> 

