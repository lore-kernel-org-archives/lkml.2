Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab0IMEX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 00:23:59 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:35698 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864Ab0IMEXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 00:23:55 -0400
Message-ID: <000b01cb52fb$794d2940$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Greg KH" <gregkh@suse.de>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
        "Peter Korsgaard" <peter.korsgaard@barco.com>,
        "Nicolas Ferre" <nicolas.ferre@atmel.com>,
        "Michal Nazarewicz" <m.nazarewicz@samsung.com>,
        "Maurus Cuelenaere" <mcuelenaere@gmail.com>,
        "linux-usb" <linux-usb@vger.kernel.org>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "Fabien Chouteau" <fabien.chouteau@barco.com>,
        "david Brownell" <dbrownell@users.sourceforge.net>,
        "Christoph Egger" <siccegge@stud.informatik.uni-erlangen.de>,
        "LKML" <linux-kernel@vger.kernel.org>, "MeeGo" <meego-dev@meego.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Andrew" <andrew.chih.howe.khor@intel.com>,
        "Intel OTC" <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        "Arjan" <arjan@linux.intel.com>,
        "Toshiharu Okada" <okada533@dsn.okisemi.com>,
        "Takahiro Shimizu" <shimizu394@dsn.okisemi.com>,
        "Tomoya Morinaga" <morinaga526@dsn.okisemi.com>
References: <4C85EE6F.6000706@dsn.okisemi.com> <20100908002229.GC15785@suse.de>
Subject: Re: [PATCH] USB device driver of Topcliff PCH
Date: Mon, 13 Sep 2010 13:23:40 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg

> > +#define PCH_UDC_BIT_CLR(reg, bitMask) \
> > + iowrite32((ioread32((reg)) & (~(bitMask))), (reg))
>
>
> Why not just use the iowrite32 functions directly?  Or surely there's
> another built-in kernel macro for this somewhere, right?

[masa]
Which macro is it?
Do you know?

My reply comments are included in the following.

Thanks Ohtake
---------
Date: Tue, 7 Sep 2010 17:22:29 -0700
From: Greg KH <gregkh@suse.de>
> On Tue, Sep 07, 2010 at 04:49:03PM +0900, Masayuki Ohtake wrote:
> > This patch adds the USB device driver of Topcliff PCH.
> >
> > Topcliff PCH is the platform controller hub that is going to be used in
> > Intel's upcoming general embedded platform. All IO peripherals in
> > Topcliff PCH are actually devices sitting on AMBA bus.
> > Topcliff PCH has USB device I/F. Using this I/F, it is able to access system
> > devices connected to USB device.
> >
> > Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> > ---
> >  drivers/usb/gadget/Kconfig        |   24 +
> >  drivers/usb/gadget/Makefile       |    2 +-
> >  drivers/usb/gadget/gadget_chips.h |    7 +
> >  drivers/usb/gadget/pch_udc.c      | 3153 +++++++++++++++++++++++++++++++++++++
> >  drivers/usb/gadget/pch_udc.h      |  495 ++++++
> >  5 files changed, 3680 insertions(+), 1 deletions(-)
> >  create mode 100755 drivers/usb/gadget/pch_udc.c
> >  create mode 100755 drivers/usb/gadget/pch_udc.h
>
> Heh, really?  executable .c and .h files?  I think you need to look at
> your development system :)

[masa]
"pch_udc.h" will be removed
It includes in "pch_udc.c"

>
>
> >
> > diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> > index 591ae9f..3bc839d 100644
> > --- a/drivers/usb/gadget/Kconfig
> > +++ b/drivers/usb/gadget/Kconfig
> > @@ -220,6 +220,30 @@ config USB_OTG
> >
> >     Select this only if your OMAP board has a Mini-AB connector.
> >
> > +config USB_GADGET_PCH
> > + boolean "PCH USB Dev"
>
> Please spell this out a lot more as to what it is.

[masa]
This will be modified as
"boolean "PCH USB Device controller""


>
> > + depends on PCI
> > + select USB_GADGET_DUALSPEED
> > + help
> > +   This is a USB device driver for Topcliff PCH.
> > +   Topcliff PCH is the platform controller hub that is used in Intel's
> > +   general embedded platform.
> > +   Topcliff PCH has USB device interface.
> > +   Using this interface, it is able to access system devices connected
> > +   to USB device.
> > +   This driver enables USB device function.
> > +   USB device is a USB peripheral controller which
> > +   supports both full and high speed USB 2.0 data transfers.
> > +   This driver supports for control transfer, and bulk transfer modes.
> > +   This driver dose not support interrupt transfer, and isochronous
> > +   transfer modes.
> > +
> > +config PCH_USBDEV
> > + tristate
> > + depends on USB_GADGET_PCH
> > + default USB_GADGET
> > + select USB_GADGET_SELECTED
> > +
> >  config USB_GADGET_PXA25X
> >  boolean "PXA 25x or IXP 4xx"
> >  depends on (ARCH_PXA && PXA25x) || ARCH_IXP4XX
> > diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
> > index 9bcde11..9473430 100644
> > --- a/drivers/usb/gadget/Makefile
> > +++ b/drivers/usb/gadget/Makefile
> > @@ -63,4 +63,4 @@ obj-$(CONFIG_USB_G_HID) += g_hid.o
> >  obj-$(CONFIG_USB_G_MULTI) += g_multi.o
> >  obj-$(CONFIG_USB_G_NOKIA) += g_nokia.o
> >  obj-$(CONFIG_USB_G_WEBCAM) += g_webcam.o
> > -
> > +obj-$(CONFIG_PCH_USBDEV) += pch_udc.o
> > diff --git a/drivers/usb/gadget/gadget_chips.h b/drivers/usb/gadget/gadget_chips.h
> > index e511fec..f67dd29 100644
> > --- a/drivers/usb/gadget/gadget_chips.h
> > +++ b/drivers/usb/gadget/gadget_chips.h
> > @@ -142,6 +142,11 @@
> >  #define gadget_is_s3c_hsotg(g)    0
> >  #endif
> >
> > +#ifdef CONFIG_USB_GADGET_PCH
> > +#define gadget_is_pch(g) (!strcmp("pch_udc", (g)->name))
> > +#else
> > +#define gadget_is_pch(g) 0
> > +#endif
> >
> >  /**
> >   * usb_gadget_controller_number - support bcdDevice id convention
> > @@ -200,6 +205,8 @@ static inline int usb_gadget_controller_number(struct usb_gadget *gadget)
> >  return 0x25;
> >  else if (gadget_is_s3c_hsotg(gadget))
> >  return 0x26;
> > + else if (gadget_is_pch(gadget))
> > + return 0x27;
> >  return -ENOENT;
> >  }
> >
> > diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
> > new file mode 100755
> > index 0000000..2065c11
> > --- /dev/null
> > +++ b/drivers/usb/gadget/pch_udc.c
> > @@ -0,0 +1,3153 @@
> > +/*
> > + * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; version 2 of the License.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
> > + */
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +#include <linux/types.h>
> > +#include <linux/module.h>
> > +#include <linux/pci.h>
> > +#include <linux/kernel.h>
> > +#include <linux/delay.h>
> > +#include <linux/ioport.h>
> > +#include <linux/sched.h>
> > +#include <linux/slab.h>
> > +#include <linux/smp_lock.h>
> > +#include <linux/errno.h>
> > +#include <linux/init.h>
> > +#include <linux/timer.h>
> > +#include <linux/list.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/ioctl.h>
> > +#include <linux/fs.h>
> > +#include <linux/dmapool.h>
> > +#include <linux/moduleparam.h>
> > +#include <linux/device.h>
> > +#include <linux/io.h>
> > +#include <linux/irq.h>
> > +
> > +#include <asm/byteorder.h>
> > +#include <asm/system.h>
> > +#include <asm/unaligned.h>
> > +
> > +/* gadget stack */
> > +#include <linux/usb/ch9.h>
> > +#include <linux/usb/gadget.h>
> > +#include "pch_udc.h"
>
> Why do you need a .h file?


[masa]
"pch_udc.h" will be removed
It includes in "pch_udc.c"


>
> > +/* macro to set a specified bit(mask) at the specified address */
> > +#define PCH_UDC_BIT_SET(reg, bitmask) \
> > + iowrite32(((ioread32((reg)) | (bitmask))), (reg))
> > +/* macro to clear a specified bit(mask) at the specified address */
> > +#define PCH_UDC_BIT_CLR(reg, bitMask) \
> > + iowrite32((ioread32((reg)) & (~(bitMask))), (reg))
>
>
> Why not just use the iowrite32 functions directly?  Or surely there's
> another built-in kernel macro for this somewhere, right?

[masa]
Which macro is it?
Do you know?

>
> > +#define MAX_LOOP 200
> > +#define PCH_UDC_PCI_BAR 1
> > +#define PCI_VENDOR_ID_INTEL 0x8086
>
> No need to define this, it's in pci_ids.h already.

[masa]
OK.
This will be removed.

>
> > +#define PCI_DEVICE_ID_INTEL_PCH1_UDC 0x8808
>
> I think this is there too.

[masa]
This is not still in pci.h.

>
> > +
> > +const char ep0_string[] = "ep0in";
> > +static DEFINE_SPINLOCK(udc_stall_spinlock); /* stall spin lock */
> > +static u32 pch_udc_base;
> > +static union pch_udc_setup_data setup_data; /* received setup data */
> > +static unsigned long ep0out_buf[64];
> > +static dma_addr_t dma_addr;
> > +struct pch_udc_dev *pch_udc; /* pointer to device object */
> > +int speed_fs;
>
> Why are 2 of these not static variables?

[masa]
This will be modified.

>
> Have you run this driver through the sparse tool?  It will catch these
> errors.  Please do so.
>

[masa]
I will do.



