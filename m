Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab0HaGz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:55:27 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:9068 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117Ab0HaGzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:55:25 -0400
Message-ID: <004501cb48d9$7c74bec0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Cc: <meego-dev@meego.com>, "LKML" <linux-kernel@vger.kernel.org>,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        <spi-devel-general@lists.sourceforge.net>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        <andrew.chih.howe.khor@intel.com>, <arjan@linux.intel.com>,
        <gregkh@suse.de>, "Morinaga" <morinaga526@dsn.okisemi.com>
References: <4C61EBAC.4000009@dsn.okisemi.com> <AANLkTikyz_RVcCeKzf9m10xXDyKZm3+Yy7y+axZN+MMx@mail.gmail.com> <001201cb45eb$fd834220$66f8800a@maildom.okisemi.com> <AANLkTikobsdDp98m7SRmtzeDQxsTzgTXib-j2SQoPpdn@mail.gmail.com>
Subject: Re: [PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
Date: Tue, 31 Aug 2010 15:55:22 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> ----- Original Message ----- 
> From: "Grant Likely" <grant.likely@secretlab.ca>
> To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
> Cc: <meego-dev@meego.com>; "LKML" <linux-kernel@vger.kernel.org>; "David Brownell" <dbrownell@users.sourceforge.net>;
<spi-devel-general@lists.sourceforge.net>; "Wang, Qi" <qi.wang@intel.com>; "Wang, Yong Y" <yong.y.wang@intel.com>;
<andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; <gregkh@suse.de>
> Sent: Saturday, August 28, 2010 2:15 AM
> Subject: Re: [PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
>
>
> Hi Ohtake-san,
>
> Thanks for the reply.  Some more comments below.
>
> On Fri, Aug 27, 2010 at 7:30 AM, Masayuki Ohtake
> <masa-korg@dsn.okisemi.com> wrote:
> > ----- Original Message -----
> > From: "Grant Likely" <grant.likely@secretlab.ca>
> > To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
> > Cc: <meego-dev@meego.com>; "LKML" <linux-kernel@vger.kernel.org>; "David Brownell"
<dbrownell@users.sourceforge.net>;
> > <spi-devel-general@lists.sourceforge.net>; <qi.wang@intel.com>; <yong.y.wang@intel.com>;
> > <andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; <gregkh@suse.de>
> > Sent: Saturday, August 14, 2010 3:49 PM
> > Subject: Re: [PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
> >
> >
> >> 2010/8/10 Masayuki Ohtak <masa-korg@dsn.okisemi.com>:
> >> > SPI driver of Topcliff PCH
> >> >
> >> > Topcliff PCH is the platform controller hub that is going to be used in
> >> > Intel's upcoming general embedded platform. All IO peripherals in
> >> > Topcliff PCH are actually devices sitting on AMBA bus.
> >> > Topcliff PCH has SPI I/F. Using this I/F, it is able to access system
> >> > devices connected to SPI.
> >> >
> >> > Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> >>
> >> Hi Masayuki. Thanks for the patch. The driver is mostly structured
> >> well and looks fairly good. However, there are quite a few stylistic
> >> issues that should be easy to clean up, and a few technical concerns.
> >> Comments below.
> >>
> >> BTW, please make sure patches get sent out as plain-text, not html formatted.
> >>
> >> > ---
> >> > drivers/spi/Kconfig | 26 +
> >> > drivers/spi/Makefile | 4 +
> >> > drivers/spi/pch_spi.h | 177 +++
> >> > drivers/spi/pch_spi_main.c | 1823
> >> > ++++++++++++++++++++++++++++++++
> >> > drivers/spi/pch_spi_platform_devices.c | 56 +
> >> > 5 files changed, 2086 insertions(+), 0 deletions(-)
> >> > create mode 100644 drivers/spi/pch_spi.h
> >> > create mode 100644 drivers/spi/pch_spi_main.c
> >> > create mode 100644 drivers/spi/pch_spi_platform_devices.c
> >> >
> >> > diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> >> > index f55eb01..b6ae72a 100644
> >> > --- a/drivers/spi/Kconfig
> >> > +++ b/drivers/spi/Kconfig
> >> > @@ -53,6 +53,32 @@ if SPI_MASTER
> >> >
> >> > comment "SPI Master Controller Drivers"
> >> >
> >> > +config PCH_SPI_PLATFORM_DEVICE
> >> > + boolean
> >> > + default y if PCH_SPI
> >> > + help
> >> > + This driver is for PCH SPI of Topcliff which is an IOH for x86
> >> > + embedded processor.
> >>
> >> What is IOH and abbreviation for?
> >>
> >> > + This registers SPI devices for a given board.
> >> > +
> >> > +config PCH_SPI_PLATFORM_DEVICE_COUNT
> >> > + int "PCH SPI Bus count"
> >> > + range 1 2
> >> > + depends on PCH_SPI_PLATFORM_DEVICE
> >> > + help
> >> > + This driver is for PCH SPI of Topcliff which is an IOH for x86
> >> > + embedded processor.
> >> > + The number of SPI buses/channels supported by the PCH SPI controller.
> >> > + PCH SPI of Topcliff supports only one channel.
> >>
> >> Being required to specific this at kernel config time isn't
> >> multiplatform friendly. Can the driver detect the number of busses at
> >> runtime.
> >
> > How can the driver detect ?
> > Could you show reference driver ?
>
> You know the hardware better than I.  Is there a configuration or
> identification register that will tell you how many spi bus instances
> there are?  Regardless, then number of instances the driver can
> support should not be hard coded into the kernel config.  If it is
> hard coded, then the driver will not support running a single kernel
> on both kinds of hardware.

Topcliff doesn't have register which shows the number of spi bus interfaces.

This multi-channel code is for other IOH device's.

Thus, I think there is not another way except for hard coding.
If you can't accept our multi-cannel code, we must delete these code.

>
> >
> >>
> >> > +
> >> > +config PCH_SPI
> >> > + tristate "PCH SPI Controller"
> >> > + depends on PCI
> >> > + help
> >> > + This driver is for PCH SPI of Topcliff which is an IOH for x86
> >> > + embedded processor.
> >> > + This driver can access PCH SPI bus device.
> >>
> >> Put config PCH_SPI above PCH_SPI_PLATFORM_DEVICE and make
> >> PCH_SPI_PLATFORM_DEVICE depend on PCH_SPI. (In fact, since
> >> PCH_SPI_PLATFORM_DEVICE is always yes when PCH_SPI is selected, then
> >> you probably don't need two configuration signals).
> >>
> >> > +
> >> > config SPI_ATMEL
> >> > tristate "Atmel SPI Controller"
> >> > depends on (ARCH_AT91 || AVR32)
> >> > diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
> >> > index f3d2810..aecc873 100644
> >> > --- a/drivers/spi/Makefile
> >> > +++ b/drivers/spi/Makefile
> >> > @@ -59,3 +59,7 @@ obj-$(CONFIG_SPI_TLE62X0) += tle62x0.o
> >> >
> >> > # SPI slave drivers (protocol for that link)
> >> > # ... add above this line ...
> >> > +obj-$(CONFIG_PCH_SPI_PLATFORM_DEVICE) += pch_spi_platform_devices.o
> >> > +obj-$(CONFIG_PCH_SPI) += pch_spi.o
> >> > +pch_spi-objs := pch_spi_main.o
> >>
> >> No need to use pch_spi-objs when there is only one .o file. Just name
> >> the .c file what you want the resulting kernel module to be named.
> >> Also, please rename the modules to "spi_pch_platform_device.o" and
> >> "spi_pch.o" (I'm enforcing all new spi drivers to start with the
> >> prefix "spi_").
> >>
> >> Finally, do pch_spi_platform_devices.o and pch_spi_main.o really need
> >> to be in separate modules?
> >
> > "spi_pch_platform_device.o" must be installed than spidev.o.
> > In case, spi_pch and spidev is integrated as module,
> > it seems spidev is installed firstly.
> > If you know the install order control, please how to control install ordering.
>
> I'm not sure what you mean.  It sounds like you're talking about the
> case where both this driver and spidev are compiled into the kernel
> (not modules).  Am I correct?
>
> What is the problem that you're seeing with the init order?  What is
> the problem when spidev gets initialized before the driver?
>
> Regardless, init order should not be an issue with merging
> pch_spi_platform_devices and pch_spi_main into a single module.

Following your comments, we will merge to a single file.

>
> >
> >>
> >> > +
> >> > diff --git a/drivers/spi/pch_spi.h b/drivers/spi/pch_spi.h
> >> > new file mode 100644
> >> > index 0000000..b40377a
> >> > --- /dev/null
> >> > +++ b/drivers/spi/pch_spi.h
> >> > @@ -0,0 +1,177 @@
> >> > +/*
> >> > + * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
> >> > + *
> >>
> >> It is helpful to have a one line description of what this file is for
> >> in at the top of the header comment block.
> >>
> >> [...]
> >> > +#define PCH_SET_BITMSK(var, bitmask) ((var) |= (bitmask))
> >> > +#define PCH_CLR_BITMSK(var, bitmask) ((var) &= (~(bitmask)))
> >>
> >> Because the macro has side-effects, I'd prefer to see static inlines
> >> used here with an all lowercase name.
> >
> > I understand your saying.
> > But this macro uses for both setting value and returned value.
> > If replacing inline function, we should make 4 functions(set/clear * void/u32)
> > Thus, I want to use these macros.
>
> which also loses any form of typechecking.  Use a static inlines
> please, even if it does mean 4 functions.  Hmmm.... Actually, given
> that this is just set/clear bit operation, I'd prefer to see the
> macros removed entirely and the |= and &=~ written directly in the
> code.

Following your comments, we will replace inline functions..

>
> >
> >>
> >> > +
> >> > +/**
> >> > + * struct pch_spi_data - Holds the SPI channel specific details
> >> > + * @io_remap_addr: The remapped PCI base address
> >> > + * @p_master: Pointer to the SPI master structure
> >> > + * @work: Reference to work queue handler
> >> > + * @p_wk_q: Workqueue for carrying out execution of the
> >> > + * requests
> >> > + * @wait: Wait queue for waking up upon receiving an
> >> > + * interrupt.
> >> > + * @b_transfer_complete: Status of SPI Transfer
> >> > + * @bcurrent_msg_processing: Status flag for message processing
> >> > + * @lock: Lock for protecting this structure
> >> > + * @queue: SPI Message queue
> >> > + * @status: Status of the SPI driver
> >> > + * @bpw_len: Length of data to be transferred in bits per
> >> > + * word
> >> > + * @b_transfer_active: Flag showing active transfer
> >> > + * @tx_index: Transmit data count; for bookkeeping during
> >> > + * transfer
> >> > + * @rx_index: Receive data count; for bookkeeping during
> >> > + * transfer
> >> > + * @tx_buff: Buffer for data to be transmitted
> >> > + * @rx_index: Buffer for Received data
> >> > + * @n_curnt_chip: The chip number that this SPI driver currently
> >> > + * operates on
> >> > + * @p_current_chip: Reference to the current chip that this SPI
> >> > + * driver currently operates on
> >> > + * @p_current_msg: The current message that this SPI driver is
> >> > + * handling
> >> > + * @p_cur_trans: The current transfer that this SPI driver is
> >> > + * handling
> >> > + * @p_board_dat: Reference to the SPI device data structure
> >> > + */
> >> > +struct pch_spi_data {
> >> > + void __iomem *io_remap_addr;
> >> > + struct spi_master *p_master;
> >> > + struct work_struct work;
> >> > + struct workqueue_struct *p_wk_q;
> >> > + wait_queue_head_t wait;
> >> > + u8 b_transfer_complete;
> >> > + u8 bcurrent_msg_processing;
> >> > + spinlock_t lock;
> >> > + struct list_head queue;
> >> > + u8 status;
> >> > + u32 bpw_len;
> >> > + s8 b_transfer_active;
> >> > + u32 tx_index;
> >> > + u32 rx_index;
> >> > + u16 *pkt_tx_buff;
> >> > + u16 *pkt_rx_buff;
> >> > + u8 n_curnt_chip;
> >> > + struct spi_device *p_current_chip;
> >> > + struct spi_message *p_current_msg;
> >> > + struct spi_transfer *p_cur_trans;
> >> > + struct pch_spi_board_data *p_board_dat;
> >> > +};
> >> > +
> >> > +/**
> >> > + * struct pch_spi_board_data - Holds the SPI device specific details
> >> > + * @pdev: Pointer to the PCI device
> >> > + * @irq_reg_sts: Status of IRQ registration
> >> > + * @pci_req_sts: Status of pci_request_regions
> >> > + * @suspend_sts: Status of suspend
> >> > + * @p_data: Pointer to SPI channel data structure
> >> > + */
> >> > +struct pch_spi_board_data {
> >> > + struct pci_dev *pdev;
> >> > + u8 irq_reg_sts;
> >> > + u8 pci_req_sts;
> >> > + u8 suspend_sts;
> >> > + struct pch_spi_data *p_data[PCH_MAX_DEV];
> >> > +};
> >> > +#endif
> >> > diff --git a/drivers/spi/pch_spi_main.c b/drivers/spi/pch_spi_main.c
> >> > new file mode 100644
> >> > index 0000000..da87d92
> >> > --- /dev/null
> >> > +++ b/drivers/spi/pch_spi_main.c
> >> > @@ -0,0 +1,1823 @@
> >> > +/*
> >> > + * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
> >> > + *
> >> > + * This program is free software; you can redistribute it and/or modify
> >> > + * it under the terms of the GNU General Public License as published by
> >> > + * the Free Software Foundation; version 2 of the License.
> >> > + *
> >> > + * This program is distributed in the hope that it will be useful,
> >> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> >> > + * GNU General Public License for more details.
> >> > + *
> >> > + * You should have received a copy of the GNU General Public License
> >> > + * along with this program; if not, write to the Free Software
> >> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307,
> >> > USA.
> >> > + */
> >> > +
> >> > +#include <linux/pci.h>
> >> > +#include <linux/wait.h>
> >> > +#include <linux/spi/spi.h>
> >> > +#include <linux/interrupt.h>
> >> > +#include <linux/sched.h>
> >> > +#include <linux/spi/spidev.h>
> >> > +#include <linux/module.h>
> >> > +#include <linux/device.h>
> >> > +#include <linux/mutex.h>
> >> > +#include "pch_spi.h"
> >> > +
> >> > +static struct pci_device_id pch_spi_pcidev_id[] = {
> >> > + {PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_GE_SPI)},
> >> > + {0,}
> >> > +};
> >> > +
> >> > +static void (*pch_spi_gcbptr) (struct pch_spi_data *);
> >> > +static DEFINE_MUTEX(pch_spi_mutex);
> >>
> >> Are these statics really necessary? I think the callback can be
> >> removed (see my comment below). The mutex should probably be a member
> >> of the pch_spi_data structure. Getting rid of the static symbols will
> >> make it easier if the driver ever needs to support multiple instances
> >> of the device.
> >
> > As to 'pch_spi_gcbptr', I agree with you.
> >
> > As to mutex, since many drivers accepted by upstream use 'static DEFINE_MUTEX',
> > I think it is right to use it.
>
> No.  Since each spi bus instance is separate without any shared data
> between them, the mutex should be per-instance.  Move it into the
> private data structure and initialize it in the probe routine with mutex_init().
>
I understand.
We will move mutex variable into private data structure.


Thanks, Ohtake(OKISEMI)



