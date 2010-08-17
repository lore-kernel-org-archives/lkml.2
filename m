Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab0HQHep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:34:45 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:11054 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991Ab0HQHeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:34:44 -0400
Message-ID: <002f01cb3dde$a7dffee0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Cc: <meego-dev@meego.com>, "LKML" <linux-kernel@vger.kernel.org>,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        <spi-devel-general@lists.sourceforge.net>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, <andrew.chih.howe.khor@intel.com>,
        <arjan@linux.intel.com>, <gregkh@suse.de>
References: <4C61EBAC.4000009@dsn.okisemi.com> <AANLkTikyz_RVcCeKzf9m10xXDyKZm3+Yy7y+axZN+MMx@mail.gmail.com>
Subject: Re: [PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
Date: Tue, 17 Aug 2010 16:34:37 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

I will modify your indications ASAP.

Thanks, Ohtake

----- Original Message ----- 
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
Cc: <meego-dev@meego.com>; "LKML" <linux-kernel@vger.kernel.org>; "David Brownell" <dbrownell@users.sourceforge.net>;
<spi-devel-general@lists.sourceforge.net>; <qi.wang@intel.com>; <yong.y.wang@intel.com>;
<andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; <gregkh@suse.de>
Sent: Saturday, August 14, 2010 3:49 PM
Subject: Re: [PATCH] Topcliff: Update PCH_SPI driver to 2.6.35


> 2010/8/10 Masayuki Ohtak <masa-korg@dsn.okisemi.com>:
> > SPI driver of Topcliff PCH
> >
> > Topcliff PCH is the platform controller hub that is going to be used in
> > Intel's upcoming general embedded platform. All IO peripherals in
> > Topcliff PCH are actually devices sitting on AMBA bus.
> > Topcliff PCH has SPI I/F. Using this I/F, it is able to access system
> > devices connected to SPI.
> >
> > Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
>
> Hi Masayuki.  Thanks for the patch.  The driver is mostly structured
> well and looks fairly good.  However, there are quite a few stylistic
> issues that should be easy to clean up, and a few technical concerns.
> Comments below.
>
> BTW, please make sure patches get sent out as plain-text, not html formatted.
I understand.

>
> > ---
> >  drivers/spi/Kconfig                    |   26 +
> >  drivers/spi/Makefile                   |    4 +
> >  drivers/spi/pch_spi.h                  |  177 +++
> >  drivers/spi/pch_spi_main.c             | 1823
> > ++++++++++++++++++++++++++++++++
> >  drivers/spi/pch_spi_platform_devices.c |   56 +
> >  5 files changed, 2086 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/spi/pch_spi.h
> >  create mode 100644 drivers/spi/pch_spi_main.c
> >  create mode 100644 drivers/spi/pch_spi_platform_devices.c
> >
> > diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> > index f55eb01..b6ae72a 100644
> > --- a/drivers/spi/Kconfig
> > +++ b/drivers/spi/Kconfig
> > @@ -53,6 +53,32 @@ if SPI_MASTER
> >
> >  comment "SPI Master Controller Drivers"
> >
> > +config PCH_SPI_PLATFORM_DEVICE
> > + boolean
> > + default y if PCH_SPI
> > + help
> > +   This driver is for PCH SPI of Topcliff which is an IOH for x86
> > +   embedded processor.
>
> What is IOH and abbreviation for?
Input/Output Hub.

>
> > +   This registers SPI devices for a given board.
> > +
> > +config PCH_SPI_PLATFORM_DEVICE_COUNT
> > + int "PCH SPI Bus count"
> > + range 1 2
> > + depends on PCH_SPI_PLATFORM_DEVICE
> > + help
> > +   This driver is for PCH SPI of Topcliff which is an IOH for x86
> > +   embedded processor.
> > +   The number of SPI buses/channels supported by the PCH SPI controller.
> > +   PCH SPI of Topcliff supports only one channel.
>
> Being required to specific this at kernel config time isn't
> multiplatform friendly.  Can the driver detect the number of busses at
> runtime.
>
> > +
> > +config PCH_SPI
> > + tristate "PCH SPI Controller"
> > + depends on PCI
> > + help
> > +   This driver is for PCH SPI of Topcliff which is an IOH for x86
> > +   embedded processor.
> > +   This driver can access PCH SPI bus device.
>
> Put config PCH_SPI above PCH_SPI_PLATFORM_DEVICE and make
> PCH_SPI_PLATFORM_DEVICE depend on PCH_SPI.  (In fact, since
> PCH_SPI_PLATFORM_DEVICE is always yes when PCH_SPI is selected, then
> you probably don't need two configuration signals).
>
> > +
> >  config SPI_ATMEL
> >  tristate "Atmel SPI Controller"
> >  depends on (ARCH_AT91 || AVR32)
> > diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
> > index f3d2810..aecc873 100644
> > --- a/drivers/spi/Makefile
> > +++ b/drivers/spi/Makefile
> > @@ -59,3 +59,7 @@ obj-$(CONFIG_SPI_TLE62X0) += tle62x0.o
> >
> >  # SPI slave drivers (protocol for that link)
> >  # ... add above this line ...
> > +obj-$(CONFIG_PCH_SPI_PLATFORM_DEVICE) += pch_spi_platform_devices.o
> > +obj-$(CONFIG_PCH_SPI) += pch_spi.o
> > +pch_spi-objs := pch_spi_main.o
>
> No need to use pch_spi-objs when there is only one .o file.  Just name
> the .c file what you want the resulting kernel module to be named.
> Also, please rename the modules to "spi_pch_platform_device.o" and
> "spi_pch.o" (I'm enforcing all new spi drivers to start with the
> prefix "spi_").
>
> Finally, do pch_spi_platform_devices.o and pch_spi_main.o really need
> to be in separate modules?
>
> > +
> > diff --git a/drivers/spi/pch_spi.h b/drivers/spi/pch_spi.h
> > new file mode 100644
> > index 0000000..b40377a
> > --- /dev/null
> > +++ b/drivers/spi/pch_spi.h
> > @@ -0,0 +1,177 @@
> > +/*
> > + * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
> > + *
>
> It is helpful to have a one line description of what this file is for
> in at the top of the header comment block.
>
> [...]
> > +#define PCH_SET_BITMSK(var, bitmask) ((var) |= (bitmask))
> > +#define PCH_CLR_BITMSK(var, bitmask) ((var) &= (~(bitmask)))
>
> Because the macro has side-effects, I'd prefer to see static inlines
> used here with an all lowercase name.
>
> > +
> > +/**
> > + * struct pch_spi_data - Holds the SPI channel specific details
> > + * @io_remap_addr: The remapped PCI base address
> > + * @p_master: Pointer to the SPI master structure
> > + * @work: Reference to work queue handler
> > + * @p_wk_q: Workqueue for carrying out execution of the
> > + * requests
> > + * @wait: Wait queue for waking up upon receiving an
> > + * interrupt.
> > + * @b_transfer_complete: Status of SPI Transfer
> > + * @bcurrent_msg_processing: Status flag for message processing
> > + * @lock: Lock for protecting this structure
> > + * @queue: SPI Message queue
> > + * @status: Status of the SPI driver
> > + * @bpw_len: Length of data to be transferred in bits per
> > + * word
> > + * @b_transfer_active: Flag showing active transfer
> > + * @tx_index: Transmit data count; for bookkeeping during
> > + * transfer
> > + * @rx_index: Receive data count; for bookkeeping during
> > + * transfer
> > + * @tx_buff: Buffer for data to be transmitted
> > + * @rx_index: Buffer for Received data
> > + * @n_curnt_chip: The chip number that this SPI driver currently
> > + * operates on
> > + * @p_current_chip: Reference to the current chip that this SPI
> > + * driver currently operates on
> > + * @p_current_msg: The current message that this SPI driver is
> > + * handling
> > + * @p_cur_trans: The current transfer that this SPI driver is
> > + * handling
> > + * @p_board_dat: Reference to the SPI device data structure
> > + */
> > +struct pch_spi_data {
> > + void __iomem *io_remap_addr;
> > + struct spi_master *p_master;
> > + struct work_struct work;
> > + struct workqueue_struct *p_wk_q;
> > + wait_queue_head_t wait;
> > + u8 b_transfer_complete;
> > + u8 bcurrent_msg_processing;
> > + spinlock_t lock;
> > + struct list_head queue;
> > + u8 status;
> > + u32 bpw_len;
> > + s8 b_transfer_active;
> > + u32 tx_index;
> > + u32 rx_index;
> > + u16 *pkt_tx_buff;
> > + u16 *pkt_rx_buff;
> > + u8 n_curnt_chip;
> > + struct spi_device *p_current_chip;
> > + struct spi_message *p_current_msg;
> > + struct spi_transfer *p_cur_trans;
> > + struct pch_spi_board_data *p_board_dat;
> > +};
> > +
> > +/**
> > + * struct pch_spi_board_data - Holds the SPI device specific details
> > + * @pdev: Pointer to the PCI device
> > + * @irq_reg_sts: Status of IRQ registration
> > + * @pci_req_sts: Status of pci_request_regions
> > + * @suspend_sts: Status of suspend
> > + * @p_data: Pointer to SPI channel data structure
> > + */
> > +struct pch_spi_board_data {
> > + struct pci_dev *pdev;
> > + u8 irq_reg_sts;
> > + u8 pci_req_sts;
> > + u8 suspend_sts;
> > + struct pch_spi_data *p_data[PCH_MAX_DEV];
> > +};
> > +#endif
> > diff --git a/drivers/spi/pch_spi_main.c b/drivers/spi/pch_spi_main.c
> > new file mode 100644
> > index 0000000..da87d92
> > --- /dev/null
> > +++ b/drivers/spi/pch_spi_main.c
> > @@ -0,0 +1,1823 @@
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
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307,
> > USA.
> > + */
> > +
> > +#include <linux/pci.h>
> > +#include <linux/wait.h>
> > +#include <linux/spi/spi.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/sched.h>
> > +#include <linux/spi/spidev.h>
> > +#include <linux/module.h>
> > +#include <linux/device.h>
> > +#include <linux/mutex.h>
> > +#include "pch_spi.h"
> > +
> > +static struct pci_device_id pch_spi_pcidev_id[] = {
> > + {PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_GE_SPI)},
> > + {0,}
> > +};
> > +
> > +static void (*pch_spi_gcbptr) (struct pch_spi_data *);
> > +static DEFINE_MUTEX(pch_spi_mutex);
>
> Are these statics really necessary?  I think the callback can be
> removed (see my comment below).  The mutex should probably be a member
> of the pch_spi_data structure.  Getting rid of the static symbols will
> make it easier if the driver ever needs to support multiple instances
> of the device.
>
> > +/**
> > + * ch_spi_disable_interrupts() - Disables specified interrupts
> > + * @master: Pointer to struct spi_master.
> > + * @interrupt: Interrups to be enabled.
> > + */
> > +static void pch_spi_disable_interrupts(struct spi_master *master, u8
> > interrupt)
> > +{
> > + u32 reg_val_spcr;
> > +
> > + reg_val_spcr = pch_spi_readreg(master, PCH_SPCR);
> > +
> > + dev_dbg(&master->dev, "%s SPCR content =%x\n",
> > +    __func__, reg_val_spcr);
> > +
> > + switch (interrupt & 0x1f) {
>
> Is it possible for more than one of these interrupt bits to be set at
> the same time?  If so, then this switch() statement won't always work.
>
> > + case PCH_RFI:
> > + /*clear RFIE bit in SPCR */
> > + dev_dbg(&master->dev,
> > +   "%s clearing RFI in pch_spi_disable_interrupts\n", __func__);
> > + PCH_CLR_BITMSK(reg_val_spcr, SPCR_RFIE_BIT);
> > + break;
> > +
> > + case PCH_TFI:
> > + /*clear TFIE bit in SPCR */
> > + dev_dbg(&master->dev,
> > +   "%s clearing TFI in pch_spi_disable_interrupts\n", __func__);
> > + PCH_CLR_BITMSK(reg_val_spcr, SPCR_TFIE_BIT);
> > + break;
> > +
> > + case PCH_FI:
> > + /*clear FIE bit in SPCR */
> > + dev_dbg(&master->dev,
> > +   "%s clearing FI in pch_spi_disable_interrupts\n", __func__);
> > + PCH_CLR_BITMSK(reg_val_spcr, SPCR_FIE_BIT);
> > + break;
> > +
> > + case PCH_ORI:
> > + /*clear ORIE bit in SPCR */
> > + dev_dbg(&master->dev,
> > +   "%s clearing ORI in pch_spi_disable_interrupts\n", __func__);
> > + PCH_CLR_BITMSK(reg_val_spcr, SPCR_ORIE_BIT);
> > + break;
> > +
> > + case PCH_MDFI:
> > + /*clear MODFIE bit in SPCR */
> > + dev_dbg(&master->dev,
> > +   "%s clearing MDFI in pch_spi_disable_interrupts\n", __func__);
> > + PCH_CLR_BITMSK(reg_val_spcr, SPCR_MDFIE_BIT);
> > + break;
> > +
> > + default:
> > + dev_info(&master->dev,
> > + "%s Unknown interrupt(=0x%02x)\n", __func__, interrupt & 0x1f);
> > + }
> > +
> > + pch_spi_writereg(master, PCH_SPCR, reg_val_spcr);
> > +
> > + dev_dbg(&master->dev, "%s SPCR after disabling interrupts =%x\n",
> > + __func__, reg_val_spcr);
> > +}
> > +
> > +/**
> > + * pch_spi_handler() - Interrupt handler
> > + * @irq: The interrupt number.
> > + * @dev_id: Pointer to struct pch_spi_board_data.
> > + */
> > +static irqreturn_t pch_spi_handler(int irq, void *dev_id)
> > +{
> > + /*channel & read/write indices */
> > + int dev, read_cnt;
> > +
> > + /*SPSR content */
> > + u32 reg_spsr_val, reg_spcr_val;
> > +
> > + /*book keeping variables */
> > + u32 n_read, tx_index, rx_index, bpw_len;
> > +
> > + /*to hold channel data */
> > + struct pch_spi_data *p_data;
> > +
> > + /*buffer to store rx/tx data */
> > + u16 *pkt_rx_buffer, *pkt_tx_buff;
> > +
> > + /*register addresses */
> > + void __iomem *spsr;
> > + void __iomem *spdrr;
> > + void __iomem *spdwr;
> > +
> > + /*remapped pci base address */
> > + void __iomem *io_remap_addr;
> > +
> > + irqreturn_t tRetVal = IRQ_NONE;
>
> nit: use lowercase for variable names.
>
> > +
> > + struct pch_spi_board_data *p_board_dat =
> > + (struct pch_spi_board_data *)dev_id;
> > +
> > + if (p_board_dat->suspend_sts == true) {
> > + dev_dbg(&p_board_dat->pdev->dev,
> > + "%s returning due to suspend\n", __func__);
> > + } else {
> > + for (dev = 0; dev < PCH_MAX_DEV; dev++) {
> > + p_data = p_board_dat->p_data[dev];
> > + io_remap_addr = p_data->io_remap_addr;
> > + spsr = io_remap_addr + PCH_SPSR;
> > +
> > + reg_spsr_val = ioread32(spsr);
> > +
> > + /*Check if the interrupt is for SPI device */
> > +
> > + if (reg_spsr_val & (SPSR_FI_BIT | SPSR_RFI_BIT)) {
> > + dev_dbg(&p_board_dat->pdev->dev,
> > +   "SPSR in %s=%x\n", __func__, reg_spsr_val);
> > + /*clear interrupt */
> > + iowrite32(reg_spsr_val, spsr);
> > +
> > + if (p_data->b_transfer_active == true) {
> > + rx_index = p_data->rx_index;
> > + tx_index = p_data->tx_index;
> > + bpw_len = p_data->bpw_len;
> > + pkt_rx_buffer = p_data->pkt_rx_buff;
> > + pkt_tx_buff = p_data->pkt_tx_buff;
> > +
> > + spdrr = io_remap_addr + PCH_SPDRR;
> > + spdwr = io_remap_addr + PCH_SPDWR;
> > +
> > + n_read = PCH_READABLE(reg_spsr_val);
> > +
> > + for (read_cnt = 0; (read_cnt < n_read);
> > +      read_cnt++) {
> > + /*read data */
> > + pkt_rx_buffer[rx_index++] =
> > + ioread32(spdrr);
> > + /*write data */
> > +
> > + if (tx_index < bpw_len) {
> > + iowrite32
> > +     (pkt_tx_buff
> > +      [tx_index++],
> > +      spdwr);
> > + }
> > + }
> > +
> > + /*disable RFI if not needed */
> > + if ((bpw_len - rx_index) <=
> > +     PCH_MAX_FIFO_DEPTH) {
> > + dev_dbg(&p_board_dat->pdev->dev,
> > +   "%s disabling RFI as data "
> > +   "remaining=%d\n", __func__,
> > +   (bpw_len - rx_index));
> > +
> > + reg_spcr_val =
> > +   ioread32(io_remap_addr +
> > + PCH_SPCR);
> > +
> > + /*disable RFI */
> > + PCH_CLR_BITMSK(reg_spcr_val,
> > + SPCR_RFIE_BIT);
> > +
> > + /*reset rx threshold */
> > + reg_spcr_val &=
> > + MASK_RFIC_SPCR_BITS;
> > + reg_spcr_val |=
> > + (PCH_RX_THOLD_MAX <<
> > + SPCR_RFIC_FIELD);
> > +
> > + iowrite32(PCH_CLR_BITMSK
> > + (reg_spcr_val,
> > + SPCR_RFIE_BIT),
> > + (io_remap_addr +
> > + PCH_SPCR));
> > + }
> > +
> > + /*update counts */
> > + p_data->tx_index = tx_index;
> > +
> > + p_data->rx_index = rx_index;
> > +
> > + dev_dbg(&p_board_dat->pdev->dev,
> > + "%s rx_index=%d tx_index=%d "
> > + "nWritable=%d n_read=%d\n",
> > + __func__, rx_index, tx_index,
> > + (16 -
> > + (PCH_WRITABLE(reg_spsr_val))),
> > + n_read);
> > +
> > + }
> > +
> > + /*if transfer complete interrupt */
> > + if (reg_spsr_val & SPSR_FI_BIT) {
> > + dev_dbg(&p_board_dat->pdev->dev,
> > + "%s FI bit in SPSR"
> > + " set\n", __func__);
> > +
> > + /*disable FI & RFI interrupts */
> > + pch_spi_disable_interrupts(p_data->
> > + p_master, PCH_FI | PCH_RFI);
> > +
> > + /*transfer is completed;inform
> > + pch_spi_process_messages */
> > +
> > + if (pch_spi_gcbptr != NULL) {
> > + dev_dbg(&p_board_dat->pdev->dev,
> > +   "%s invoking callback\n",
> > +   __func__);
> > + (*pch_spi_gcbptr) (p_data);
> > + }
> > + }
> > +
> > + tRetVal = IRQ_HANDLED;
> > + }
> > + }
> > + }
>
> Wow, the nesting on this function is very deep, and hard to follow.
> Candidate for refactoring?
>
> > +
> > + dev_dbg(&p_board_dat->pdev->dev, "%s EXIT return value=%d\n",
> > + __func__, tRetVal);
> > +
> > + return tRetVal;
> > +}
> > +
> > +/**
> > + * pch_spi_entcb() - Registers the callback function
> > + * @pch_spi_cb: Callback function pointer.
> > + */
> > +static void pch_spi_entcb(void (*pch_spi_cb) (struct pch_spi_data *))
> > +{
> > + if (pch_spi_cb != NULL)
> > + pch_spi_gcbptr = pch_spi_cb;
> > +}
>
> This trivial function is used exactly once in the probe routine.  Just
> set the variable in-place.  In fact, this doesn't need to be a
> callback at all because it is *always* set to pch_spi_callback.
> Removing it will make the driver simpler.
>
> > +/**
> > + * pch_spi_setup_transfe() - Configures the PCH SPI hardware for transfer
> > + * @spi: Pointer to struct spi_device.
> > + */
> > +static void pch_spi_setup_transfer(struct spi_device *spi)
> > +{
> > + u32 reg_spcr_val;
> > +
> > + dev_dbg(&spi->dev, "%s SPBRR content =%x setting baud rate=%d\n",
> > +   __func__, pch_spi_readreg(spi->master, PCH_SPBRR), spi->max_speed_hz);
> > +
> > + pch_spi_set_baud_rate(spi->master, spi->max_speed_hz);
> > +
> > + /*set bits per word */
> > + dev_dbg(&spi->dev, "%s :setting bits_per_word=%d\n",
> > + __func__, spi->bits_per_word);
> > + pch_spi_set_bits_per_word(spi->master, spi->bits_per_word);
> > +
> > + dev_dbg(&spi->dev,
> > + "%s SPBRR content after setting baud rate & bits per word=%x\n",
> > + __func__, pch_spi_readreg(spi->master, PCH_SPBRR));
> > +
> > + reg_spcr_val = pch_spi_readreg(spi->master, PCH_SPCR);
> > + dev_dbg(&spi->dev, "%s SPCR content = %x\n", __func__, reg_spcr_val);
> > +
> > + /*set bit justification */
> > +
> > + if ((spi->mode & SPI_LSB_FIRST) != 0) {
> > + /*LSB first */
> > + PCH_CLR_BITMSK(reg_spcr_val, SPCR_LSBF_BIT);
> > + dev_dbg(&spi->dev, "%s :setting LSBF bit to 0\n", __func__);
> > + } else {
> > + /*MSB first */
> > + PCH_SET_BITMSK(reg_spcr_val, SPCR_LSBF_BIT);
> > + dev_dbg(&spi->dev, "%s :setting LSBF bit to 1\n", __func__);
> > + }
>
> There are a lot of these if/else blocks which call
> PCH_{SET,CLR}_BITMSK().  The code could be simplified with a helper
> function that implements the two paths.  Something like
> pch_spi_clrsetbits() perhaps.
>
>
> > +static int pch_spi_transfer(struct spi_device *pspi, struct spi_message
> > *pmsg)
> > +{
> > +
> > + struct spi_transfer *p_transfer;
> > + struct pch_spi_data *p_data = spi_master_get_devdata(pspi->master);
> > + int retval;
> > + int ret;
> > +
> > + ret = mutex_lock_interruptible(&pch_spi_mutex);
> > + if (ret) {
> > + retval = -ERESTARTSYS;
> > + goto err_return;
> > + }
> > +
> > + /*validate spi message and baud rate */
> > + if (unlikely((list_empty(&pmsg->transfers) == 1) ||
> > +      ((pspi->max_speed_hz) == 0))) {
> > + if (list_empty(&pmsg->transfers) == 1)
> > + dev_err(&pspi->dev, "%s list empty\n", __func__);
> > +
> > + if ((pspi->max_speed_hz) == 0) {
> > + dev_err(&pspi->dev, "%s pch_spi_tranfer maxspeed=%d\n",
> > + __func__, (pspi->max_speed_hz));
> > + }
> > + dev_err(&pspi->dev, "%s returning EINVAL\n", __func__);
> > +
> > + retval = -EINVAL;
> > + goto err_return_mutex;
> > + }
> > +
> > + dev_dbg(&pspi->dev,
> > +     "%s Transfer List not empty. Transfer Speed is set.\n", __func__);
> > +
> > + /*validate Tx/Rx buffers and Transfer length */
> > + list_for_each_entry(p_transfer, &pmsg->transfers,
> > + transfer_list) {
> > + if ((((p_transfer->tx_buf) == NULL)
> > +      && ((p_transfer->rx_buf) == NULL))
> > +     || (p_transfer->len == 0)) {
> > + if (((p_transfer->tx_buf) == NULL)
> > +     && ((p_transfer->rx_buf) == NULL)) {
> > + dev_err(&pspi->dev,
> > + "%s Tx and Rx buffer NULL\n", __func__);
> > + }
> > +
> > + if (p_transfer->len == 0) {
> > + dev_err(&pspi->dev, "%s Transfer"
> > + " length invalid\n", __func__);
> > + }
> > +
> > + dev_err(&pspi->dev, "%s returning EINVAL\n", __func__);
> > +
> > + retval = -EINVAL;
> > + goto err_return_mutex;
> > + }
> > +
> > + dev_dbg(&pspi->dev,
> > +     "%s Tx/Rx buffer valid. Transfer length valid\n", __func__);
> > +
> > + /*if baud rate hs been specified validate the same */
> > + if (p_transfer->speed_hz) {
> > + if ((p_transfer->speed_hz) >
> > +     PCH_MAX_BAUDRATE) {
> > + retval = -EINVAL;
> > + dev_err(&pspi->dev,
> > +   "%s Invalid Baud rate\n", __func__);
> > + goto err_return_mutex;
> > + }
>
> If the requested speed is too fast, then the maximum bus speed should
> be used instead.
>
> > + /*copy Tx Data */
> > + if ((p_data->p_cur_trans->tx_buf) != NULL) {
> > + for (j = 0; j < (p_data->bpw_len); j++) {
> > + if (PCH_8_BPW == *bpw) {
> > + p_data->pkt_tx_buff[j] =
> > +     (((u8 *) (p_data->p_cur_trans->
> > +       tx_buf))[j]);
> > + dev_dbg(&p_data->p_master->dev, "%s=%x\n",
> > + __func__, (p_data->pkt_tx_buff[j]));
> > + } else {
> > + p_data->pkt_tx_buff[j] =
> > +     ((u16 *) (p_data->p_cur_trans->
> > +       tx_buf))[j];
> > + dev_dbg(&p_data->p_master->dev,
> > + "%s xmt data = %x\n", __func__,
> > + (p_data->pkt_tx_buff[j]));
> > + }
> > + }
>
> Optimization note; by coding it this way, the (PCH_8_BPW == *bpw) test
> is being performed on every iteration through the loop.  If you had
> separate iterators for 8 and 16 bit transfer, the code will be faster.
>
> > + }
> > +
> > + /*if len greater than PCH_MAX_FIFO_DEPTH,
> > + write 16,else len bytes */
>
> Nit: It would be easier to read if the comment blocks were tidied up.
> There should be a space between /* and the first word, and some
> comments, like this one, will fit on a single line.
>
> > + if ((p_data->bpw_len) > PCH_MAX_FIFO_DEPTH)
> > + n_writes = PCH_MAX_FIFO_DEPTH;
> > + else
> > + n_writes = (p_data->bpw_len);
> > +
> > + dev_dbg(&p_data->p_master->dev,
> > +   "\n%s:Pulling down SSN low - writing 0x2 to SSNXCR\n", __func__);
>
> When splitting lines in the middle of an argument list, please indent
> up to the same level as the first argument.
>
> > +static void pch_spi_copy_rx_data(struct pch_spi_data *p_data, int bpw)
> > +{
> > + int j;
> > + /*copy Rx Data */
> > + if ((p_data->p_cur_trans->rx_buf) != NULL) {
>
> if (p_data->pcur_trans->rx_buf)
> return;
>
> That reduces the indentation on the rest of the function by one level
> and makes it easier to read and understand.
>
> > + for (j = 0; j < (p_data->bpw_len); j++) {
> > + if (PCH_8_BPW == bpw) {
> > + ((u8 *) (p_data->p_cur_trans->rx_buf))[j] =
> > +     (u8) ((p_data->pkt_rx_buff[j]) & 0xFF);
> > +
> > + dev_dbg(&p_data->p_master->dev,
> > + "rcv data in %s =%x\n", __func__,
> > + (p_data->pkt_rx_buff[j]));
> > +
> > + } else {
> > + ((u16 *) (p_data->p_cur_trans->rx_buf))[j] =
> > +     (u16) (p_data->pkt_rx_buff[j]);
> > + dev_dbg(&p_data->p_master->dev,
> > + "rcv data in %s = %x\n", __func__,
> > + (p_data->pkt_rx_buff[j]));
> > + }
> > + }
>
> Same comment on optimization.
>
> > + }
> > +}
> > +
> > +
> > +static void pch_spi_process_messages(struct work_struct *pwork)
> > +{
> > + struct spi_message *pmsg;
> > + int bpw;
> > +
> > + struct pch_spi_data *p_data =
> > + container_of(pwork, struct pch_spi_data, work);
> > + dev_dbg(&p_data->p_master->dev,
> > + "%s p_data initialized\n", __func__);
> > +
> > + spin_lock(&p_data->lock);
> > +
> > + /*check if suspend has been initiated;if yes flush queue */
> > + if ((p_data->p_board_dat->suspend_sts)
> > +     || (p_data->status == STATUS_EXITING)) {
> > + dev_dbg(&p_data->p_master->dev,
> > +     "%s suspend/remove initiated,flushing queue\n", __func__);
> > + list_for_each_entry(pmsg, p_data->queue.next, queue) {
> > + pmsg->status = -EIO;
> > +
> > + if (pmsg->complete != 0)
> > + pmsg->complete(pmsg->context);
>
> The complete callback cannot be called while still holding the spinlock.
>
> > +
> > + /*delete from queue */
> > + list_del_init(&pmsg->queue);
> > + }
> > +
> > + spin_unlock(&p_data->lock);
>
> Put a return statement here.  It will eliminate the else { }
> indentation below; again improving readability.
>
> > + } else {
> > + p_data->bcurrent_msg_processing = true;
> > + dev_dbg(&p_data->p_master->dev,
> > +     "%s Set p_data->bcurrent_msg_processing= true\n",
> > +     __func__);
> > +
> > + /*Get the message from the queue and delete it from there. */
> > + p_data->p_current_msg =
> > +     list_entry(p_data->queue.next, struct spi_message,
> > +        queue);
> > + dev_dbg(&p_data->p_master->dev,
> > + "%s :Got new message from queue\n", __func__);
> > + list_del_init(&p_data->p_current_msg->queue);
> > +
> > + p_data->p_current_msg->status = 0;
> > +
> > + dev_dbg(&p_data->p_master->dev,
> > + "%s :Invoking pch_spi_select_chip\n", __func__);
> > + pch_spi_select_chip(p_data, p_data->p_current_msg->spi);
> > +
> > + spin_unlock(&p_data->lock);
> > +
> > + do {
> > + /*If we are already processing a message get the next
> > + transfer structure from the message otherwise retrieve
> > + the 1st transfer request from the message. */
> > + spin_lock(&p_data->lock);
> > +
> > + if (p_data->p_cur_trans == NULL) {
> > + p_data->p_cur_trans =
> > +     list_entry(p_data->p_current_msg->transfers.
> > +        next, struct spi_transfer,
> > +        transfer_list);
> > + dev_dbg(&p_data->p_master->dev,
> > + "%s :Getting 1st transfer message\n",
> > + __func__);
> > + } else {
> > + p_data->p_cur_trans =
> > +     list_entry(p_data->p_cur_trans->
> > +        transfer_list.next,
> > +        struct spi_transfer,
> > +        transfer_list);
> > + dev_dbg(&p_data->p_master->dev,
> > + "%s :Getting next transfer message\n",
> > + __func__);
> > + }
> > +
> > + spin_unlock(&p_data->lock);
> > +
> > + pch_spi_set_tx(p_data, &bpw, &pmsg);
> > +
> > + /*Control interrupt*/
> > + pch_spi_set_ir(p_data);
> > +
> > + /*Disable SPI transfer */
> > + dev_dbg(&p_data->p_master->dev,
> > + "%s:invoking pch_spi_set_enable to "
> > + "disable spi transfer\n", __func__);
> > + pch_spi_set_enable((p_data->p_current_chip), false);
> > +
> > + /*clear FIFO */
> > + dev_dbg(&p_data->p_master->dev,
> > +     "%s:invoking pch_spi_clear_fifo to clear fifo\n",
> > +     __func__);
> > + pch_spi_clear_fifo(p_data->p_master);
> > +
> > + /*copy Rx Data */
> > + pch_spi_copy_rx_data(p_data, bpw);
> > +
> > + /*free memory */
> > + kfree(p_data->pkt_rx_buff);
> > + if (p_data->pkt_rx_buff)
> > + p_data->pkt_rx_buff = NULL;
> > +
> > + kfree(p_data->pkt_tx_buff);
> > + if (p_data->pkt_tx_buff)
> > + p_data->pkt_tx_buff = NULL;
> > +
> > + /*increment message count */
> > + p_data->p_current_msg->actual_length +=
> > +     p_data->p_cur_trans->len;
> > +
> > + dev_dbg(&p_data->p_master->dev,
> > + "%s:p_data->p_current_msg->actual_length=%d\n",
> > + __func__, p_data->p_current_msg->actual_length);
> > +
> > + /*check for delay */
> > + if (p_data->p_cur_trans->delay_usecs) {
> > + dev_dbg
> > +     (&p_data->p_master->dev, "%s:"
> > + "delay in usec=%d\n", __func__,
> > +      p_data->p_cur_trans->delay_usecs);
> > + udelay(p_data->p_cur_trans->delay_usecs);
> > + }
> > +
> > + spin_lock(&p_data->lock);
> > +
> > + /*No more transfer in this message. */
> > + if ((p_data->p_cur_trans->transfer_list.next) ==
> > +     &(p_data->p_current_msg->transfers)) {
> > + pch_spi_nomore_transfer(p_data, pmsg);
> > + }
> > +
> > + spin_unlock(&p_data->lock);
> > +
> > + } while ((p_data->p_cur_trans) != NULL);
> > + }
> > +}
> > +
> > +static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id
> > *id)
> > +{
> > +
> > + struct spi_master *p_master[PCH_MAX_DEV];
> > +
> > + struct pch_spi_board_data *p_board_dat;
> > + int retval, i, j, k, l, m;
>
> nit: for loop index variables should be reused.  Don't use a new index
> for every single for() loop.
>
> > + int spi_alloc_num, spi_master_num;
> > +
> > + dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
> > + /* initialize the call back function */
> > + pch_spi_entcb(pch_spi_callback);
> > + dev_dbg(&pdev->dev, "%s invoked pch_spi_entcb\n", __func__);
> > +
> > + /* allocate memory for private data */
> > + p_board_dat = kmalloc(sizeof(struct pch_spi_board_data), GFP_KERNEL);
>
> kzalloc()
>
> > +
> > + if (p_board_dat == NULL) {
> > + dev_err(&pdev->dev,
> > +     " %s memory allocation for private data failed\n",
> > +     __func__);
> > + retval = -ENOMEM;
> > + goto err_kmalloc;
> > + }
> > +
> > + dev_dbg(&pdev->dev,
> > + "%s memory allocation for private data success\n", __func__);
> > +
> > + /* enable PCI device */
> > + retval = pci_enable_device(pdev);
> > + if (retval != 0) {
> > + dev_err(&pdev->dev, "%s pci_enable_device FAILED\n", __func__);
> > +
> > + goto err_pci_en_device;
> > + }
> > +
> > + dev_dbg(&pdev->dev, "%s pci_enable_device returned=%d\n",
> > + __func__, retval);
> > +
> > + p_board_dat->pdev = pdev;
> > +
> > + /* alllocate memory for SPI master */
> > + for (i = 0, spi_alloc_num = 0; i < PCH_MAX_DEV; i++, spi_alloc_num++) {
> > + p_master[i] = spi_alloc_master(&pdev->dev,
> > +      sizeof(struct pch_spi_data));
> > +
> > + if (p_master[i] == NULL) {
> > + retval = -ENOMEM;
> > + dev_err(&pdev->dev, "%s [ch=%d]Fail.\n", __func__, i);
> > + goto err_spi_alloc_master;
> > + }
> > + }
> > +
> > + dev_dbg(&pdev->dev,
> > + "%s spi_alloc_master returned non NULL\n", __func__);
> > +
> > + /* initialize members of SPI master */
> > + for (j = 0, spi_master_num = 0; j < PCH_MAX_DEV;
> > + j++, spi_master_num++) {
>
> spi_master_num isn't used except for the error path, and it always has
> the same value as 'j'.  Get it out of the loop initializer!  :-)  It
> can be set in the error path.
>
> > + p_master[j]->bus_num = 0;
>
> You probably want -1 here so that the spi layer dynamically assigns an
> spi bus number.
>
> > + p_master[j]->num_chipselect = PCH_MAX_CS;
> > + p_master[j]->setup = pch_spi_setup;
> > + dev_dbg(&pdev->dev,
> > + "%s setup member of SPI master initialized\n",
> > + __func__);
> > + p_master[j]->transfer = pch_spi_transfer;
> > + dev_dbg(&pdev->dev,
> > +     "%s transfer member of SPI master initialized\n", __func__);
> > + p_master[j]->cleanup = pch_spi_cleanup;
> > + dev_dbg(&pdev->dev,
> > +     "%s cleanup member of SPI master initialized\n", __func__);
> > +
> > + p_board_dat->p_data[j] =
> > + spi_master_get_devdata(p_master[j]);
>
> Unnecessary line break.  There are a lot of these in this driver.
>
> > +
> > + p_board_dat->p_data[j]->p_master = p_master[j];
> > + p_board_dat->p_data[j]->n_curnt_chip = 255;
> > + p_board_dat->p_data[j]->p_current_chip = NULL;
> > + p_board_dat->p_data[j]->b_transfer_complete = false;
> > + p_board_dat->p_data[j]->pkt_tx_buff = NULL;
> > + p_board_dat->p_data[j]->pkt_rx_buff = NULL;
> > + p_board_dat->p_data[j]->tx_index = 0;
> > + p_board_dat->p_data[j]->rx_index = 0;
> > + p_board_dat->p_data[j]->b_transfer_active = false;
>
> The above 7 lines can be dropped when the code is changed to use
> kzalloc().  kzalloc() clears the allocated memory.
>
> > + p_board_dat->p_data[j]->p_board_dat = p_board_dat;
> > + p_board_dat->suspend_sts = false;
> > +
> > + /* Register the controller with the SPI core. */
> > + retval = spi_register_master(p_master[j]);
> > + if (retval != 0) {
> > + dev_err(&pdev->dev,
> > +    "%s spi_register_master FAILED\n", __func__);
> > + goto err_spi_reg_master;
> > + }
> > +
> > + dev_dbg(&pdev->dev, "%s spi_register_master returned=%d\n",
> > + __func__, retval);
> > + }
> > +
> > + /* allocate resources for PCH SPI */
> > + retval = pch_spi_get_resources(p_board_dat);
> > + if (retval != 0) {
> > + dev_err(&pdev->dev, "%s fail(retval=%d)\n",
> > + __func__, retval);
> > + goto err_spi_get_resources;
> > + }
> > +
> > + dev_dbg(&pdev->dev, "%s pch_spi_get_resources returned=%d\n",
> > + __func__, retval);
> > +
> > + /* save private data in dev */
> > + pci_set_drvdata(pdev, (void *)p_board_dat);
>
> Remove the (void *) cast.  It should not be necessary.
>
> > + dev_dbg(&pdev->dev, "%s invoked pci_set_drvdata\n", __func__);
> > +
> > + /* set master mode */
> > + for (k = 0; k < PCH_MAX_DEV; k++) {
> > + pch_spi_set_master_mode(p_master[k]);
> > + dev_dbg(&pdev->dev,
> > + "%s invoked pch_spi_set_master_mode\n", __func__);
> > + }
> > +
> > + return 0;
> > +
> > +err_spi_get_resources:
> > + for (l = 0; l <= spi_master_num; l++)
> > + spi_unregister_master(p_master[l]);
> > +err_spi_reg_master:
> > +err_spi_alloc_master:
> > + for (m = 0; m <= spi_alloc_num; m++)
> > + spi_master_put(p_master[m]);
> > + pci_disable_device(pdev);
> > +err_pci_en_device:
> > + kfree(p_board_dat);
> > +err_kmalloc:
> > + return retval;
> > +}
> > +
> > +static void pch_spi_remove(struct pci_dev *pdev)
> > +{
> > + int i;
> > +
> > + struct pch_spi_board_data *p_board_dat = pci_get_drvdata(pdev);
> > +
> > + dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
> > +
> > + if (p_board_dat != NULL) {
>
> if (!p_board_dat) {
> dev_err(...);
> return;
> }
>
> > + dev_dbg(&pdev->dev, "%s invoked pci_get_drvdata\n", __func__);
> > +
> > + /* check for any pending messages */
> > + if ((-EBUSY) == pch_spi_check_request_pending(p_board_dat)) {
> > + dev_dbg(&pdev->dev,
> > +     "%s pch_spi_check_request_pending returned EBUSY\n",
> > +     __func__);
> > + /* no need to take any particular action;
> > + proceed with remove even
> > +    though queue is not empty */
> > + }
> > +
> > + dev_dbg(&pdev->dev,
> > + "%s pch_spi_check_request_pending invoked\n", __func__);
> > +
> > + /* Free resources allocated for PCH SPI */
> > + pch_spi_free_resources(p_board_dat);
> > + dev_dbg(&pdev->dev,
> > + "%s invoked pch_spi_free_resources\n", __func__);
> > +
> > + /* Unregister SPI master */
> > + for (i = 0; i < PCH_MAX_DEV; i++) {
> > + spi_unregister_master(p_board_dat->p_data[i]->
> > +       p_master);
> > + dev_dbg(&pdev->dev,
> > + "%s invoked spi_unregister_master\n", __func__);
> > + }
> > +
> > + /* free memory for private data */
> > + kfree(p_board_dat);
> > +
> > + pci_set_drvdata(pdev, NULL);
> > +
> > + dev_dbg(&pdev->dev,
> > + "%s memory for private data freed\n", __func__);
> > +
> > + /* disable PCI device */
> > + pci_disable_device(pdev);
> > +
> > + dev_dbg(&pdev->dev,
> > + "%s invoked pci_disable_device\n", __func__);
> > +
> > + } else {
> > + dev_err(&pdev->dev,
> > + "%s pci_get_drvdata returned NULL\n", __func__);
> > + }
> > +}
> > +
> > +#ifdef CONFIG_PM
> > +static int pch_spi_suspend(struct pci_dev *pdev, pm_message_t state)
> > +{
> > + int i;
> > + u8 count;
> > + s32 retval;
> > +
> > + struct pch_spi_board_data *p_board_dat = pci_get_drvdata(pdev);
> > +
> > + dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
> > +
> > + if (p_board_dat == NULL) {
> > + dev_err(&pdev->dev,
> > + "%s pci_get_drvdata returned NULL\n", __func__);
> > + retval = -EFAULT;
>
> Ditto here; return -EFAULT;
>
> > + } else {
> > + retval = 0;
> > + dev_dbg(&pdev->dev,
> > + "%s pci_get_drvdata invoked successfully\n", __func__);
> > + p_board_dat->suspend_sts = true;
> > + dev_dbg(&pdev->dev,
> > + "%s p_board_dat->bSuspending set to true\n", __func__);
> > +
> > + /* check if the current message is processed:
> > +    Only after thats done the transfer will be suspended */
> > + for (i = 0; i < PCH_MAX_DEV; i++) {
> > + count = 255;
> > +
> > + while ((--count) > 0) {
> > + if (p_board_dat->p_data[i]->
> > +     bcurrent_msg_processing == false) {
> > + dev_dbg(&pdev->dev, "%s p_board_dat->"
> > + "p_data->bCurrent_"
> > + "msg_processing = false\n",
> > + __func__);
> > + break;
> > + } else {
> > + dev_dbg(&pdev->dev, "%s p_board_dat->"
> > + "p_data->bCurrent_msg_"
> > + "processing = true\n",
> > + __func__);
> > + }
> > + msleep(PCH_SLEEP_TIME);
> > + }
> > + }
> > +
> > + /* Free IRQ */
> > + if (p_board_dat->irq_reg_sts == true) {
> > + /* disable all interrupts */
> > + for (i = 0; i < PCH_MAX_DEV; i++) {
> > + pch_spi_disable_interrupts(p_board_dat->
> > +    p_data[i]->
> > +    p_master,
> > +    PCH_ALL);
> > + pch_spi_reset(p_board_dat->p_data[i]->
> > +       p_master);
> > + dev_dbg(&pdev->dev,
> > + "%s pch_spi_disable_interrupts invoked"
> > + "successfully\n", __func__);
> > + }
> > +
> > + free_irq(p_board_dat->pdev->irq, (void *)p_board_dat);
> > +
> > + p_board_dat->irq_reg_sts = false;
> > + dev_dbg(&pdev->dev,
> > + "%s free_irq invoked successfully."
> > + "p_data->irq_reg_sts = false\n",
> > + __func__);
> > + }
> > +
> > + /* save config space */
> > + retval = pci_save_state(pdev);
> > +
> > + if (retval == 0) {
> > + dev_dbg(&pdev->dev, "%s pci_save_state returned=%d\n",
> > + __func__, retval);
> > + /* disable PM notifications */
> > + pci_enable_wake(pdev, PCI_D3hot, 0);
> > + dev_dbg(&pdev->dev,
> > + "%s pci_enable_wake invoked successfully\n",
> > + __func__);
> > + /* disable PCI device */
> > + pci_disable_device(pdev);
> > + dev_dbg(&pdev->dev,
> > + "%s pci_disable_device invoked successfully\n",
> > + __func__);
> > + /* move device to D3hot  state */
> > + pci_set_power_state(pdev, PCI_D3hot);
> > + dev_dbg(&pdev->dev,
> > + "%s pci_set_power_state invoked successfully\n",
> > + __func__);
> > + } else {
> > + dev_err(&pdev->dev,
> > + "%s pci_save_state failed\n", __func__);
> > + }
> > + }
> > +
> > + dev_dbg(&pdev->dev, "%s return=%d\n", __func__, retval);
> > +
> > + return retval;
> > +}
> > +
> > +static int pch_spi_resume(struct pci_dev *pdev)
> > +{
> > + int i;
> > + s32 retval;
> > +
> > + struct pch_spi_board_data *p_board_dat = pci_get_drvdata(pdev);
> > + dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
> > +
> > + if (p_board_dat == NULL) {
> > + dev_err(&pdev->dev,
> > + "%s pci_get_drvdata returned NULL\n", __func__);
> > + retval = -EFAULT;
> > + } else {
> > + retval = 0;
> > + /* move device to DO power state */
> > + pci_set_power_state(pdev, PCI_D0);
> > + dev_dbg(&pdev->dev,
> > +     "%s pci_set_power_state invoked successfully\n", __func__);
> > +
> > + /* restore state */
> > + pci_restore_state(pdev);
> > + dev_dbg(&pdev->dev,
> > +     "%s pci_restore_state invoked successfully\n", __func__);
> > +
> > + retval = pci_enable_device(pdev);
> > + if (retval < 0) {
> > + dev_err(&pdev->dev,
> > + "%s pci_enable_device failed\n", __func__);
> > + } else {
> > + dev_dbg(&pdev->dev,
> > + "%s pci_enable_device returned=%d\n",
> > + __func__, retval);
> > +
> > + /* disable PM notifications */
> > + pci_enable_wake(pdev, PCI_D3hot, 0);
> > + dev_dbg(&pdev->dev,
> > + "%s pci_enable_wake invoked successfully\n", __func__);
> > +
> > + /* register IRQ handler */
> > + if ((p_board_dat->irq_reg_sts) != true) {
> > + /* register IRQ */
> > + retval = request_irq(p_board_dat->pdev->irq,
> > + pch_spi_handler, IRQF_SHARED,
> > + DRIVER_NAME,
> > + p_board_dat);
> > + if (retval < 0) {
> > + dev_err(&pdev->dev,
> > +    "%s request_irq failed\n", __func__);
> > + } else {
> > + dev_dbg(&pdev->dev, "%s request_irq"
> > +    " returned=%d\n", __func__, retval);
> > + p_board_dat->irq_reg_sts = true;
> > +
> > + /* reset PCH SPI h/w */
> > + for (i = 0; i < PCH_MAX_DEV; i++) {
> > + pch_spi_reset(p_board_dat->
> > +       p_data[i]->
> > +       p_master);
> > + dev_dbg(&pdev->dev,
> > +   "pdev->dev, %s pch_spi_reset "
> > +   "invoked successfully\n",
> > +   __func__);
> > + pch_spi_set_master_mode
> > +     (p_board_dat->p_data[i]->
> > +      p_master);
> > + dev_dbg(&pdev->dev,
> > +   "%s pch_spi_set_master_mode "
> > +   "invoked successfully\n",
> > +   __func__);
> > + }
> > +
> > + /* set suspend status to false */
> > + p_board_dat->suspend_sts = false;
> > +
> > + dev_dbg(&pdev->dev, "%s set p_board_dat"
> > +    "->bSuspending = false\n", __func__);
> > + }
> > + }
> > + }
> > + }
>
> Another very deeply indented function.
>
> > +
> > + dev_dbg(&pdev->dev, "%s returning=%d\n", __func__, retval);
> > +
> > + return retval;
> > +}
> > +#else
> > +#define pch_spi_suspend NULL
> > +#define pch_spi_resume NULL
> > +
> > +#endif
> > +
> > +static struct pci_driver pch_spi_pcidev = {
> > + .name = "pch_spi",
> > + .id_table = pch_spi_pcidev_id,
> > + .probe = pch_spi_probe,
> > + .remove = pch_spi_remove,
> > + .suspend = pch_spi_suspend,
> > + .resume = pch_spi_resume,
> > +};
> > +
> > +static int __init pch_spi_init(void)
> > +{
> > + return pci_register_driver(&pch_spi_pcidev);
> > +}
> > +
> > +
> > +static void __exit pch_spi_exit(void)
> > +{
> > + pci_unregister_driver(&pch_spi_pcidev);
> > +}
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_DESCRIPTION("PCH SPI PCI Driver");
> > +module_init(pch_spi_init);
> > +module_exit(pch_spi_exit);
> > +
> > diff --git a/drivers/spi/pch_spi_platform_devices.c
> > b/drivers/spi/pch_spi_platform_devices.c
> > new file mode 100644
> > index 0000000..a0d6488
> > --- /dev/null
> > +++ b/drivers/spi/pch_spi_platform_devices.c
> > @@ -0,0 +1,56 @@
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
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307,
> > USA.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/spi/spidev.h>
> > +#include <linux/device.h>
> > +#include <linux/spi/spi.h>
> > +
> > +static struct spi_board_info pch_spi_slaves[] = {
> > + {
> > + .modalias = "spidev",
> > + .max_speed_hz = 1000000,
> > + .bus_num = 0,
> > + .chip_select = 0,
> > + .platform_data = NULL,
> > + .mode = SPI_MODE_0,
> > + },
> > +#if (CONFIG_PCH_SPI_PLATFORM_DEVICE_COUNT - 1)
> > + {
> > + .modalias = "spidev",
> > + .max_speed_hz = 1000000,
> > + .bus_num = 1,
> > + .chip_select = 1,
> > + .platform_data = NULL,
> > + .mode = SPI_MODE_0,
> > + },
> > +#endif
> > +};
>
> This file is misnamed; these aren't platform_devices, they are spi_devices.
>
> > +
> > +static __init int Load(void)
> > +{
> > + int iRetVal = -1;
>
> int rc = -1;
>
> > +
> > + if (!spi_register_board_info
> > +     (pch_spi_slaves, ARRAY_SIZE(pch_spi_slaves)))
> > + iRetVal = 0;
> > +
> > + return iRetVal;
> > +}
> > +
> > +module_init(Load);
>
> How about when the module is removed?
>
> This particular module (not the rest of the driver though) is really
> rather a hack.  It seems like you need a method for creating spidev
> devices from userspace at runtime, or having a method for specifying
> spi device from the kernel command line.  Using a flattened device
> tree fragment would work as well.
>
> g.
>
>
> -- 
> Grant Likely, B.Sc., P.Eng.
> Secret Lab Technologies Ltd.
>


