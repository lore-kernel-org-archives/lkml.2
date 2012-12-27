Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab2L0MGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 07:06:14 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48517 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2L0MGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 07:06:10 -0500
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Dec 2012 07:06:10 EST
MIME-Version: 1.0
In-Reply-To: <50DB5B80.50801@mvista.com>
References: <1356547341-23620-1-git-send-email-tobetter@gmail.com>
	<1356547341-23620-3-git-send-email-tobetter@gmail.com>
	<50DB5B80.50801@mvista.com>
Date: Thu, 27 Dec 2012 20:58:10 +0900
Message-ID: <CADoNuNeku+CzZdiaiCw4uoS4aQEAyzNBS427asv2BvyhFmRj=Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] USB: ehci-s5p: Add to get interrupt from DT
From: Dongjin Kim <tobetter@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-samsung-soc@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

Yes, you are right.
I made this patch to read its interrupt number from dtb directly. But
now platform_get_irq() returns correct irq since "OF_DEV_AUXDATA(...)"
is added as my first patch.

This patch is useless.

Thanks and best regards,
Dongjin.

On Thu, Dec 27, 2012 at 5:18 AM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
>
> Hello.
>
> On 12/26/2012 09:42 PM, Dongjin Kim wrote:
>
> > This patch support to get interrupt resource from device tree as well as
> > platform device if ehci node is defined in device tree and it's irq is
> > described.
>
> > Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> > ---
> >  drivers/usb/host/ehci-s5p.c |    8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
>
> > diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
> > index 319dcfa..0fc5e5e 100644
> > --- a/drivers/usb/host/ehci-s5p.c
> > +++ b/drivers/usb/host/ehci-s5p.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/of.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/of_gpio.h>
> > +#include <linux/of_irq.h>
> >  #include <linux/platform_data/usb-ehci-s5p.h>
> >  #include <plat/usb-phy.h>
> >
> > @@ -156,7 +157,12 @@ static int s5p_ehci_probe(struct platform_device
> > *pdev)
> >               goto fail_io;
> >       }
> >
> > -     irq = platform_get_irq(pdev, 0);
> > +     if (pdev->dev.of_node)
> > +             irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
>
>    platform_get_irq() should still work for device tree based platform
> devices.
> I don't see the point on the patch?
>
> > +     else {
> > +             irq = platform_get_irq(pdev, 0);
> > +     }
>
>    Hm, why {} out of the blue? Both arms of *if* are single-stratement.
>
> > +
>
>    No need for empty line here.
>
> >       if (!irq) {
> >               dev_err(&pdev->dev, "Failed to get IRQ\n");
> >               err = -ENODEV;
>
> WBR, Sergei
>
