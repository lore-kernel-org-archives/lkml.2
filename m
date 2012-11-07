Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab2KGF6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 00:58:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:17040 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab2KGF6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 00:58:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,726,1344236400"; 
   d="scan'208";a="243492249"
Message-ID: <1352267925.7176.3.camel@yhuang-dev>
Subject: Re: [PATCH] pci/runtime-pm: respect devices autosuspend timeout on
 config access
From: Huang Ying <ying.huang@intel.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed, 07 Nov 2012 13:58:45 +0800
In-Reply-To: <1352266209-29796-1-git-send-email-airlied@redhat.com>
References: <1352266209-29796-1-git-send-email-airlied@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-07 at 15:30 +1000, Dave Airlie wrote:
> So I've been adding runtime pm to nouveau/radeon, and on X start it does a
> lot of pci accesses. Now because the pm on these devices is equivalent
> to D3cold, we have to resume them which involves a heavy latency due to
> POSTing the cards. The driver configures the autosuspend timeout to 5s for
> this reason, and I think the PCI layer config accesses should respect
> the autosuspend.
> 
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> ---
>  drivers/pci/pci-sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 02d107b..12d3d52 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -487,7 +487,7 @@ pci_config_pm_runtime_put(struct pci_dev *pdev)
>  	struct device *dev = &pdev->dev;
>  	struct device *parent = dev->parent;
>  
> -	pm_runtime_put(dev);
> +	pm_runtime_put_autosuspend(dev);
>  	if (parent)
>  		pm_runtime_put_sync(parent);
>  }

I think you do not need that.  You can implement timeout
in .runtime_idle callback of the driver.

Best Regards,
Huang Ying


