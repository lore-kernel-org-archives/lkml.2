Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab2LEFJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 00:09:33 -0500
Received: from mail.active-venture.com ([67.228.131.205]:50929 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab2LEFJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 00:09:31 -0500
X-Originating-IP: 108.223.40.66
Date: Tue, 4 Dec 2012 21:09:50 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
Cc: herrmann.der.user@googlemail.com, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] x86, AMD: Power driver support for AMD's
 family 16h processors
Message-ID: <20121205050900.GA7793@roeck-us.net>
References: <1354623004-8169-1-git-send-email-boris.ostrovsky@amd.com>
 <CAErSpo4p1-=71SXN3eg0KVu_S0mwjVjYUBfXSBMypJAatvnAiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4p1-=71SXN3eg0KVu_S0mwjVjYUBfXSBMypJAatvnAiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 10:26:16AM -0700, Bjorn Helgaas wrote:
> On Tue, Dec 4, 2012 at 5:10 AM, Boris Ostrovsky <boris.ostrovsky@amd.com> wrote:
> > Add family 16h PCI ID to AMD's power driver to allow it report
> > power consumption on these processors.
> >
> > Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
> > ---
> >  drivers/hwmon/fam15h_power.c |    1 +
> >  include/linux/pci_ids.h      |    1 +
> >  2 files changed, 2 insertions(+)
> >
> > diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
> > index 4f41104..dda1113 100644
> > --- a/drivers/hwmon/fam15h_power.c
> > +++ b/drivers/hwmon/fam15h_power.c
> > @@ -248,6 +248,7 @@ static void __devexit fam15h_power_remove(struct pci_dev *pdev)
> >
> >  static DEFINE_PCI_DEVICE_TABLE(fam15h_power_id_table) = {
> >         { PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
> > +       { PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
> >         {}
> >  };
> >  MODULE_DEVICE_TABLE(pci, fam15h_power_id_table);
> > diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> > index 9d36b82..9c9a464 100644
> > --- a/include/linux/pci_ids.h
> > +++ b/include/linux/pci_ids.h
> > @@ -524,6 +524,7 @@
> >  #define PCI_DEVICE_ID_AMD_15H_NB_F3    0x1603
> >  #define PCI_DEVICE_ID_AMD_15H_NB_F4    0x1604
> >  #define PCI_DEVICE_ID_AMD_15H_NB_F5    0x1605
> > +#define PCI_DEVICE_ID_AMD_16H_NB_F4    0x1534
> >  #define PCI_DEVICE_ID_AMD_CNB17H_F3    0x1703
> >  #define PCI_DEVICE_ID_AMD_LANCE                0x2000
> >  #define PCI_DEVICE_ID_AMD_LANCE_HOME   0x2001
> 
> Read the comment at the top of pci_ids.h.  Based on just this patch,
> it doesn't seem like the pci_ids.h change is warranted.
> 
Boris,

can you move the define into fam15h_power.c and resubmit the patch ?
It would simplify integration.

Thanks,
Guenter
