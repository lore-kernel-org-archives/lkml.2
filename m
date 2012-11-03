Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab2KCFHJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 01:07:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:30648 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab2KCFHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 01:07:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,704,1344236400"; 
   d="scan'208";a="212969050"
Message-ID: <1351919112.13106.1.camel@yhuang-mobile.sh.intel.com>
Subject: Re: [BUGFIX 2/2] PCI/PM: Resume device before shutdown
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sat, 03 Nov 2012 13:05:12 +0800
In-Reply-To: <CAErSpo5bKDrfOC86Cxv+0yFiyj1bMgWF=6XuY+DWFjaMBTQC0A@mail.gmail.com>
References: <1351061654-8339-1-git-send-email-ying.huang@intel.com>
	 <1351061654-8339-2-git-send-email-ying.huang@intel.com>
	 <CAErSpo5bKDrfOC86Cxv+0yFiyj1bMgWF=6XuY+DWFjaMBTQC0A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 10:52 -0600, Bjorn Helgaas wrote:
> On Wed, Oct 24, 2012 at 12:54 AM, Huang Ying <ying.huang@intel.com> wrote:
> > Some actions during shutdown need device to be in D0 state, such as
> > MSI shutdown etc, so resume device before shutdown.
> 
> Is there a problem report or bugzilla for this issue?  What are the
> symptoms by which a user could figure out that he needs this fix?

No bugzilla for this issue.  This issue will cause the corresponding
device lost in kexeced kernel.

Best Regards,
Huang Ying

> Should this be put in the stable tree as well?  If so, for v3.6 only?
> 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > ---
> >  drivers/pci/pci-driver.c |   12 ++----------
> >  1 file changed, 2 insertions(+), 10 deletions(-)
> >
> > --- a/drivers/pci/pci-driver.c
> > +++ b/drivers/pci/pci-driver.c
> > @@ -398,6 +398,8 @@ static void pci_device_shutdown(struct d
> >         struct pci_dev *pci_dev = to_pci_dev(dev);
> >         struct pci_driver *drv = pci_dev->driver;
> >
> > +       pm_runtime_resume(dev);
> > +
> >         if (drv && drv->shutdown)
> >                 drv->shutdown(pci_dev);
> >         pci_msi_shutdown(pci_dev);
> > @@ -408,16 +410,6 @@ static void pci_device_shutdown(struct d
> >          * continue to do DMA
> >          */
> >         pci_disable_device(pci_dev);
> > -
> > -       /*
> > -        * Devices may be enabled to wake up by runtime PM, but they need not
> > -        * be supposed to wake up the system from its "power off" state (e.g.
> > -        * ACPI S5).  Therefore disable wakeup for all devices that aren't
> > -        * supposed to wake up the system at this point.  The state argument
> > -        * will be ignored by pci_enable_wake().
> > -        */
> > -       if (!device_may_wakeup(dev))
> > -               pci_enable_wake(pci_dev, PCI_UNKNOWN, false);
> >  }
> >
> >  #ifdef CONFIG_PM


