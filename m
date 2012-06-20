Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab2FTWmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:42:36 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53447 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553Ab2FTWmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:42:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH -v6 3/4] PCI, PM, Do not call pci_set_power_state with PCI_D3cold
Date: Thu, 21 Jun 2012 00:47:57 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, Zheng Yan <zheng.z.yan@intel.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Jesse Barnes <jesse.barnes@intel.com>
References: <1340083249-16266-1-git-send-email-ying.huang@intel.com> <1340083249-16266-4-git-send-email-ying.huang@intel.com>
In-Reply-To: <1340083249-16266-4-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201206210047.57882.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 19, 2012, Huang Ying wrote:
> PCI subsystem has not been ready for D3cold support yet.  So
> PCI_D3cold should not be used as parameter for pci_set_power_state.
> This patch is needed for upcoming PCI_D3cold support.
> 
> This patch has no functionality change, because pci_set_power_state
> will bound the parameter to PCI_D3hot too.
> 
> Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> Cc: Jesse Barnes <jesse.barnes@intel.com>
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  arch/x86/pci/mrst.c       |    2 +-
>  drivers/misc/cb710/core.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/arch/x86/pci/mrst.c
> +++ b/arch/x86/pci/mrst.c
> @@ -264,7 +264,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
>  
>  static void __devinit mrst_power_off_unused_dev(struct pci_dev *dev)
>  {
> -	pci_set_power_state(dev, PCI_D3cold);
> +	pci_set_power_state(dev, PCI_D3hot);
>  }
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0801, mrst_power_off_unused_dev);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0809, mrst_power_off_unused_dev);
> --- a/drivers/misc/cb710/core.c
> +++ b/drivers/misc/cb710/core.c
> @@ -180,7 +180,7 @@ static int cb710_suspend(struct pci_dev
>  	pci_save_state(pdev);
>  	pci_disable_device(pdev);
>  	if (state.event & PM_EVENT_SLEEP)
> -		pci_set_power_state(pdev, PCI_D3cold);
> +		pci_set_power_state(pdev, PCI_D3hot);
>  	return 0;
>  }
>  
> 
> 

