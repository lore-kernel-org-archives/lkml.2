Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0KDIho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 04:37:44 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:19058 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564Ab0KDIhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 04:37:40 -0400
Message-ID: <002f01cb7bfb$89dde6e0$66f8800a@maildom.okisemi.com>
From: "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>
To: "Andy Isaacson" <adi@hexapodia.org>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Michal Nazarewicz" <m.nazarewicz@samsung.com>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "linux-usb" <linux-usb@vger.kernel.org>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Andrew" <andrew.chih.howe.khor@intel.com>,
        "Intel OTC" <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>
References: <4CC55AD9.6020800@dsn.okisemi.com> <20101103183750.GA23043@hexapodia.org>
Subject: Re: [PATCH v7] USB device driver of Topcliff PCH
Date: Thu, 4 Nov 2010 17:35:36 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy.

Thank you for your comment.
We will modify like your comment and resubmit it

I have a question.

>> +config USB_PCH
>> + tristate
>
>Does this option need a description string?

What meaning?
Could you tell me details?

--------------
config USB_PCH
 tristate
 depends on USB_GADGET_PCH
 default USB_GADGET
 select USB_GADGET_SELECTED
--------------

We wrote this block like description of other drivers.

Best regards
Toshiharu Okada (OKI SEMICONDUCTOR)

----- Original Message ----- 
Date: Wed, 3 Nov 2010 11:37:50 -0700
From: Andy Isaacson <adi@hexapodia.org>
Subject: Re: [PATCH v7] USB device driver of Topcliff PCH


> On Mon, Oct 25, 2010 at 07:24:25PM +0900, Toshiharu Okada wrote:
> > This patch adds the USB device driver of EG20T PCH.
> >
> > EG20T PCH is the platform controller hub that is going to be used in
> > Intel's upcoming general embedded platform. All IO peripherals in
> > EG20T PCH are actually devices sitting on AMBA bus.
> > EG20T PCH has USB device I/F. Using this I/F, it is able to access
system
> > devices connected to USB device.
> >
> > +config USB_GADGET_PCH
> > + boolean "PCH USB Device controller"
>
> This description is way too generic.  "Intel EG20T (Topcliff) USB Device
> controller" would be better.  The config option should probably be
> USB_GADGET_EG20T as well.
>
> > +   EG20T PCH is the platform controller hub that is used in Intel's
> > +   general embedded platform. EG20T PCH has USB device interface.
> > +   Using this interface, it is able to access system devices connected
> > +   to USB device.
> > +   This driver enables USB device function.
> > +   USB device is a USB peripheral controller which
> > +   supports both full and high speed USB 2.0 data transfers.
> > +   This driver supports for control transfer, and bulk transfer modes.
>
> "This driver supports both control transfer and bulk transfer modes."
>
> > +   This driver dose not support interrupt transfer, and isochronous
> > +   transfer modes.
>
> "This driver does not support interrupt transfer or isochronous transfer
> modes."
>
> > +config USB_PCH
> > + tristate
>
> Does this option need a description string?
>
> > +++ b/drivers/usb/gadget/pch_udc.c
> [snip]
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
>
> Do you really need all of these includes?
>
> > +#define UDC_DEVSTS_TS_OFS 18
> > +#define UDC_DEVSTS_ENUM_SPEED_OFS 13
> > +#define UDC_DEVSTS_ALT_OFS 8
> > +#define UDC_DEVSTS_INTF_OFS 4
> > +#define UDC_DEVSTS_CFG_OFS 0
>
> Please rename all _OFS constants to _SHIFT for clarity.  (However, if
> the rename will cause many lines to exceed 80 characters, then please
> choose another name.)
>
> > +static void pch_udc_write_csr(struct pch_udc_dev *dev, unsigned long
val,
> > +        unsigned int ep)
> > +{
> > + unsigned long reg = PCH_UDC_CSR(ep);
>
> Add a blank line between variables and code.
>
> > + pch_udc_csr_busy(dev); /* Wait till idle */
> > + pch_udc_writel(dev, val, reg);
>
>
> > +/**
> > + * pch_udc_read_csr() - Read the command and status registers.
> > + * @dev: Reference to pch_udc_dev structure
> > + * @addr: address of CSR register
> > + * Returns
> > + * content of CSR register
> > + */
>
> Please read Documentation/kernel-doc-nano-HOWTO.txt and verify this is
> correct.  I am not sure, but I think you need a blank line after the
> last @variable, and should say "Return value:".
>
> > +static u32 pch_udc_read_csr(struct pch_udc_dev *dev, unsigned int ep)
> > +{
> > + unsigned long reg = PCH_UDC_CSR(ep);
>
> Please check all your functions and ensure there is a proper blank line
> here.
>
> > + pch_udc_csr_busy(dev); /* Wait till idle */
> > + pch_udc_readl(dev, reg); /* Dummy read */
> > + pch_udc_csr_busy(dev); /* Wait till idle */
>
>
> > +/**
> > + * pch_udc_clear_dma() - Clear the 'TDE' or RDE bit of device control
> > + * register depending on the direction specified
> > + * @dev: Reference to structure of type pch_udc_regs
> > + * @dir: Whether Tx or Rx
> > + * - dir = DMA_DIR_RX Receive
> > + * - dir = DMA_DIR_TX Transmit
> > + */
>
> This will not format correctly, please read nano-howto.txt.
>
> > +static inline void pch_udc_clear_dma(struct pch_udc_dev *dev, int dir)
> > +{
> > + if (dir == DMA_DIR_RX)
> > + pch_udc_bit_clr(dev, UDC_DEVCTL_ADDR, UDC_DEVCTL_RDE);
> > + else if (dir == DMA_DIR_TX)
> > + pch_udc_bit_clr(dev, UDC_DEVCTL_ADDR, UDC_DEVCTL_TDE);
> > +
>
> Delete this extra blank line.  Check for unneeded blank lines
> throughout.
>
> > +}
>
>
> > + pr_debug("%s: enter  req->req.dma=0x%08x", __func__, req->req.dma);
> > + /* set buffer pointer */
> > + req->td_data->dataptr = req->req.dma;
> > + /* set last bit */
>
> These comments are useless, because they just repeat what the code says.
> Please remove them or replace them with comments that actually explain
> what is happening.  For example, this line could use a comment:
>
> > + req->td_data->status |= PCH_UDC_DMA_LAST;
>
> *Why* are we setting DMA_LAST?  (I *think* I know, but am not entirely
> sure.)  Probably it doesn't need a comment at all, but if it does, the
> comment should answer the "Why?" question.
>
> You have many examples of this pattern of one-comment-per-line-of-code.
> Please review them all.
>
> [snip]
>
> > + /* if bytes < max packet then tx bytes must
> > + * be written in packet per buffer mode
> > + */
>
> This is a good comment!
>
> > + if ((req->req.length < ep->ep.maxpacket) || !ep->num)
> > + /* write the count */
>
> This is a bad comment.
>
> > + req->td_data->status = (req->td_data->status &
> > + ~PCH_UDC_RXTX_BYTES) | req->req.length;
>
> [snip]
>
> > +static void pch_udc_start_rxrequest(struct pch_udc_ep *ep,
> > + struct pch_udc_request *req)
> > +{
> > + struct pch_udc_data_dma_desc *td_data;
> > +
> > + pch_udc_clear_dma(ep->dev, DMA_DIR_RX);
> > + td_data = req->td_data;
> > + ep->td_data = req->td_data;
> > + /* Set the status bits for all descriptors */
>
> Here is an example of a one-line comment that is not bad, since it
> explains why the loop is here.  So in your review, be careful not to
> remove good comments like this...
>
> > + while (1) {
> > + td_data->status = (td_data->status & ~PCH_UDC_BUFF_STS) |
> > +     PCH_UDC_BS_HST_RDY;
> > + if ((td_data->status & PCH_UDC_DMA_LAST) ==  PCH_UDC_DMA_LAST)
> > + break;
> > + td_data = phys_to_virt(td_data->next);
> > + }
> > + /* Write the descriptor pointer */
> > + pch_udc_ep_set_ddptr(ep, req->td_data_phys);
>
> Suprisingly, this comment is good too, I think, since it helps explain
> the effect of set_ddptr.
>
> > + dev_dbg(&dev->pdev->dev, "%s: req = 0x%p dma_desc = 0x%p, td_phys = "
> > + "0x%08lx", __func__, req, dma_desc,
> > + (unsigned long)req->td_data_phys);
> > + /* prevent from using desc. - set HOST BUSY */
> > + dma_desc->status |= PCH_UDC_BS_HST_BSY;
>
> This comment should explain what is being prevented from using desc, I
> think it's the USB controller but the comment should explain clearly.
>
> > +static int pch_udc_pcd_set_halt(struct usb_ep *usbep, int halt)
> > +{
> [snip]
> > + if (!list_empty(&ep->queue)) {
> > + dev_dbg(&dev->pdev->dev, "%s: list not empty", __func__);
> > + ret = -EAGAIN;
> > + } else if (!halt) { /* halt or clear halt */
> > + pch_udc_ep_clear_stall(ep);
> > + ret = 0;
> > + } else {
> > + if (ep->num == PCH_UDC_EP0)
> > + ep->dev->stall = 1;
> > + pch_udc_ep_set_stall(ep);
> > + pch_udc_enable_ep_interrupts(ep->dev,
> > +      PCH_UDC_EPINT(ep->in, ep->num));
> > + ret = 0;
> > + }
>
> I think this would be clearer as
>
> + if (!list_empty(&ep->queue)) {
> + dev_dbg(&dev->pdev->dev, "%s: list not empty", __func__);
> + ret = -EAGAIN;
> + }
> + if (halt) {
> + if (ep->num == PCH_UDC_EP0)
> + ep->dev->stall = 1;
> + pch_udc_ep_set_stall(ep);
> + pch_udc_enable_ep_interrupts(ep->dev,
> +      PCH_UDC_EPINT(ep->in, ep->num));
> + ret = 0;
> + } else {
> + pch_udc_ep_clear_stall(ep);
> + ret = 0;
> + }
>
> because:
> 1. if (!list_empty  is a standalone check, there is no if/else if/else
> connection between list_empty() and halt.
> 2. I prefer if (foo) {} else {} instead of if (!foo) {} else {}, unless
> there is a significant reason to do the negated test.
>
> > + struct pch_udc_ep  *ep ;
>
> random extra whitespace before ;.
>
> > + pr_debug("%s: %s", __func__, usbep->name);
>
> There are probably too many pr_debug() and dev_dbg()s in this driver.
> Please reconsider which ones are appropriate for mainline.
>
> > +#ifdef DMA_PPB_WITH_DESC_UPDATE
>
> I don't see this defined anywhere, is this dead code?
>
> > + } else if ((((stat & UDC_EPSTS_OUT_MASK) >> UDC_EPSTS_OUT_OFS) ==
> > +      UDC_EPSTS_OUT_DATA) && !dev->stall) {
> > + if (list_empty(&ep->queue)) {
> > + dev_err(&dev->pdev->dev, "%s: ZLP", __func__);
>
> Please provide a useful error message here.
>
> > + for (i = 0; i < PCH_UDC_EP_NUM; i++) {
> > + ep = &dev->ep[i];
> > + pch_udc_clear_ep_status(ep, 0x1F0006F0);
>
> This magic number needs a #define.
>
>
> Overall, the code cleanliness looks OK once the above are addressed.
> I am not qualified to review the USB gadget interfaces, but the general
> structure appears to be sane.
>
> -andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

