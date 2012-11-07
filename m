Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab2KGG0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 01:26:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:1175 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab2KGG02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 01:26:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,726,1344236400"; 
   d="scan'208";a="214438587"
Message-ID: <1352269585.7176.6.camel@yhuang-dev>
Subject: Re: [PATCH] pci/runtime-pm: respect devices autosuspend timeout on
 config access
From: Huang Ying <ying.huang@intel.com>
To: David Airlie <airlied@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed, 07 Nov 2012 14:26:25 +0800
In-Reply-To: <890104457.2285480.1352268931077.JavaMail.root@redhat.com>
References: <890104457.2285480.1352268931077.JavaMail.root@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-07 at 01:15 -0500, David Airlie wrote:
> > > 
> > > Cc: Huang Ying <ying.huang@intel.com>
> > > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > > Signed-off-by: Dave Airlie <airlied@redhat.com>
> > > ---
> > >  drivers/pci/pci-sysfs.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> > > index 02d107b..12d3d52 100644
> > > --- a/drivers/pci/pci-sysfs.c
> > > +++ b/drivers/pci/pci-sysfs.c
> > > @@ -487,7 +487,7 @@ pci_config_pm_runtime_put(struct pci_dev *pdev)
> > >  	struct device *dev = &pdev->dev;
> > >  	struct device *parent = dev->parent;
> > >  
> > > -	pm_runtime_put(dev);
> > > +	pm_runtime_put_autosuspend(dev);
> > >  	if (parent)
> > >  		pm_runtime_put_sync(parent);
> > >  }
> > 
> > I think you do not need that.  You can implement timeout
> > in .runtime_idle callback of the driver.
> 
> If I understand what you are suggesting, I should setup some kinda of timer callback to later call suspend, but that seems pointless for me if we have the autosuspend mechanism in place.
> 
> Won't I end up racing my timer against other pm stuff? I'm not really runtime pm expert so maybe I'm just missing something.

You can call pm_runtime_autosuspend or pm_runtime_schedule_suspend
in .runtime_idle callback of the driver.

Best Regards,
Huang Ying


