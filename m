Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab2IMDmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 23:42:50 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12011 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab2IMDms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 23:42:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 12 Sep 2012 20:42:47 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "balbi@ti.com" <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Thu, 13 Sep 2012 09:12:41 +0530
Subject: RE: [PATCH] usb: host: tegra: code clean up
Thread-Topic: [PATCH] usb: host: tegra: code clean up
Thread-Index: Ac2REf5TL9Epd4g5RJOV7vAwVCJ6/gAT13WQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDEFB8D7B@BGMAIL02.nvidia.com>
References: <1347433362-4669-1-git-send-email-vbyravarasu@nvidia.com>
 <5050D034.7030203@wwwdotorg.org>
In-Reply-To: <5050D034.7030203@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Wednesday, September 12, 2012 11:41 PM
> To: Venu Byravarasu
> Cc: balbi@ti.com; linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH] usb: host: tegra: code clean up
> 
> On 09/12/2012 01:02 AM, Venu Byravarasu wrote:
> > As part of code clean up, used devm counterparts for the APIs
> > possible.
> 
> Almost all of this patch has already been applied as:

Agree. 
Currently Balbi's tree has bit old ehci-tegra.c.
Because of this the patches prepared with linux-next need to be rebased onto this tree and prepare a new patch.
My main intention behind pushing this patch was to get all changes of ehci-tegra.c from linux-next into balbi's code base so that I can push the same patch against either balbi's tree or linux-next.

> bc2ff98 drivers/usb/host/ehci-tegra.c: use devm_ functions
> 
> (btw, that patch has a much better patch subject than this one)
> 
> The only additions in your patch are shown below, and those changes
> should indeed be a separate patch.
> 
> > diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> > index 6223d17..dba9f07 100644
> > --- a/drivers/usb/host/ehci-tegra.c
> > +++ b/drivers/usb/host/ehci-tegra.c
> > @@ -701,7 +701,7 @@ static int tegra_ehci_probe(struct platform_device
> *pdev)
> >                         break;
> >                 default:
> >                         err = -ENODEV;
> > -                       dev_err(&pdev->dev, "unknown usb instance\n");
> > +                       dev_err(&pdev->dev, "unknown usb inst:%d\n", instance);
> >                         goto fail_io;
> >                 }
> >         }
> > @@ -744,7 +744,7 @@ static int tegra_ehci_probe(struct platform_device
> *pdev)
> >
> >         err = usb_add_hcd(hcd, irq, IRQF_SHARED);
> >         if (err) {
> > -               dev_err(&pdev->dev, "Failed to add USB HCD\n");
> > +               dev_err(&pdev->dev, "usb_add_hcd failed with err 0x%x\n", err);
> >                 goto fail;
> >         }
> >
> > @@ -753,7 +753,7 @@ static int tegra_ehci_probe(struct platform_device
> *pdev)
> >
> >         /* Don't skip the pm_runtime_forbid call if wakeup isn't working */
> >         /* if (!pdata->power_down_on_bus_suspend) */
> > -               pm_runtime_forbid(&pdev->dev);
> > +       pm_runtime_forbid(&pdev->dev);
> >         pm_runtime_enable(&pdev->dev);
> >         pm_runtime_put_sync(&pdev->dev);
> >         return err;
> 
> I'm not sure that last change is worth making; hopefully, you'll fix the
> bug the causes the "if" to be commented out, and we can re-enabled it
> again. Removing the indent makes it much less obvious which lines of
> code the "if" was intended to cover.
