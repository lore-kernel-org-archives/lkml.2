Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab2KGGbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 01:31:41 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:57386 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2KGGbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 01:31:40 -0500
Date: Wed, 7 Nov 2012 01:31:36 -0500 (EST)
From: David Airlie <airlied@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Message-ID: <619892122.2288591.1352269896409.JavaMail.root@redhat.com>
In-Reply-To: <1352269585.7176.6.camel@yhuang-dev>
Subject: Re: [PATCH] pci/runtime-pm: respect devices autosuspend timeout on
 config access
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.40.183]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Huang Ying" <ying.huang@intel.com>
> To: "David Airlie" <airlied@redhat.com>
> Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, "Bjorn Helgaas" <bhelgaas@google.com>, "Rafael J.
> Wysocki" <rjw@sisk.pl>
> Sent: Wednesday, 7 November, 2012 4:26:25 PM
> Subject: Re: [PATCH] pci/runtime-pm: respect devices autosuspend timeout on config access
> 
> On Wed, 2012-11-07 at 01:15 -0500, David Airlie wrote:
> > > > 
> > > > Cc: Huang Ying <ying.huang@intel.com>
> > > > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > > > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > > > Signed-off-by: Dave Airlie <airlied@redhat.com>
> > > > ---
> > > >  drivers/pci/pci-sysfs.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> > > > index 02d107b..12d3d52 100644
> > > > --- a/drivers/pci/pci-sysfs.c
> > > > +++ b/drivers/pci/pci-sysfs.c
> > > > @@ -487,7 +487,7 @@ pci_config_pm_runtime_put(struct pci_dev
> > > > *pdev)
> > > >  	struct device *dev = &pdev->dev;
> > > >  	struct device *parent = dev->parent;
> > > >  
> > > > -	pm_runtime_put(dev);
> > > > +	pm_runtime_put_autosuspend(dev);
> > > >  	if (parent)
> > > >  		pm_runtime_put_sync(parent);
> > > >  }
> > > 
> > > I think you do not need that.  You can implement timeout
> > > in .runtime_idle callback of the driver.
> > 
> > If I understand what you are suggesting, I should setup some kinda
> > of timer callback to later call suspend, but that seems pointless
> > for me if we have the autosuspend mechanism in place.
> > 
> > Won't I end up racing my timer against other pm stuff? I'm not
> > really runtime pm expert so maybe I'm just missing something.
> 
> You can call pm_runtime_autosuspend or pm_runtime_schedule_suspend
> in .runtime_idle callback of the driver.

Ah that explains what I was probably missing, I'll go play with that for a while then!

Thanks,
Dave.
