Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1HRCqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 22:46:16 -0400
Received: from ebb05.tieto.com ([131.207.168.36]:57993 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab1HRCqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 22:46:13 -0400
X-AuditID: 83cfa824-b7be9ae000000a40-3a-4e4c7cf386a0
Message-ID: <4E4C8077.9070809@tieto.com>
Date: Thu, 18 Aug 2011 11:01:11 +0800
From: Yang Rui Rui <ruirui.r.yang@tieto.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Michal Nazarewicz <mnazarewicz@google.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Sergei Shtylyov <sshtylyov@mvista.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Ruirui R <ruirui.r.yang@tietoenator.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] usb: gadget: get rid of USB_GADGET_DUALSPEED and USB_GADGET_SUPERSPEED
References: <4E4B9D9C.2010607@linutronix.de> <fb37566fc5a85ea4e8711221253e5db98d919251.1313594405.git.mina86@mina86.com>
In-Reply-To: <fb37566fc5a85ea4e8711221253e5db98d919251.1313594405.git.mina86@mina86.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2011 11:33 PM, Michal Nazarewicz wrote:
> From: Michal Nazarewicz<mina86@mina86.com>
>
> This commit removes the use of USB_GADGET_DUALSPEED and
> USB_GADGET_SUPERSPEED Kconfig options.  Those were selected
> by UDC drivers which supported respective speeds.
>
> However, since kernel now allows multiple UDC drivers to be
> compiled, the options in question may no longer reflect the
> state of all gadgets.
>
> For instance, if one driver that supports dual speed is selected
> and another that does not, the USB_GADGE_DUALSPEED will be set
> "for both".
>
> This commit replaces all the #ifdefs by a run-time checks made
> by calling gadget_is_dualspeed().

I did not see the include/linux/usb/gadget.h changes, did you have another patch?
There's  CONFIG_USB_GADGET_DUALSPEED ifdefs in gadget_is_dualspeed function of the gadget.h
If so, I will get oops as before.
  
> ---
>   drivers/usb/gadget/Kconfig        |   30 -------------------------
>   drivers/usb/gadget/composite.c    |    9 +-------
>   drivers/usb/gadget/file_storage.c |    4 ---
>   drivers/usb/gadget/inode.c        |   10 --------
>   drivers/usb/gadget/printer.c      |   43 ++++++-------------------------------
>   drivers/usb/gadget/u_ether.c      |    7 ------
>   6 files changed, 8 insertions(+), 95 deletions(-)
>
> Like before, this has been only compile-tested (make allmodconfig
> bzImage modules on x86_64).
>
> Compared to v1:
>   * Removed unrelated whitespace changes
>   * Removed the use of min() in usb_composite_probe()
>
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index 5a084b9..c60c167 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -133,7 +133,6 @@ config USB_AT91
>
>   config USB_ATMEL_USBA
>          tristate "Atmel USBA"
> -       select USB_GADGET_DUALSPEED
>          depends on AVR32 || ARCH_AT91CAP9 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45
>          help
>            USBA is the integrated high-speed USB Device controller on
> @@ -142,7 +141,6 @@ config USB_ATMEL_USBA
>   config USB_FSL_USB2
>          tristate "Freescale Highspeed USB DR Peripheral Controller"
>          depends on FSL_SOC || ARCH_MXC
> -       select USB_GADGET_DUALSPEED
>          select USB_FSL_MPH_DR_OF if OF
>          help
>             Some of Freescale PowerPC processors have a High Speed
> @@ -158,7 +156,6 @@ config USB_FSL_USB2
>   config USB_FUSB300
>          tristate "Faraday FUSB300 USB Peripheral Controller"
>          depends on !PHYS_ADDR_T_64BIT
> -       select USB_GADGET_DUALSPEED
>          help
>             Faraday usb device controller FUSB300 driver
>
> @@ -206,7 +203,6 @@ config USB_PXA25X_SMALL
>
>   config USB_R8A66597
>          tristate "Renesas R8A66597 USB Peripheral Controller"
> -       select USB_GADGET_DUALSPEED
>          help
>             R8A66597 is a discrete USB host and peripheral controller chip that
>             supports both full and high speed USB 2.0 data transfers.
> @@ -220,7 +216,6 @@ config USB_RENESAS_USBHS_UDC
>          tristate 'Renesas USBHS controller'
>          depends on SUPERH || ARCH_SHMOBILE
>          depends on USB_RENESAS_USBHS
> -       select USB_GADGET_DUALSPEED
>          help
>             Renesas USBHS is a discrete USB host and peripheral controller chip
>             that supports both full and high speed USB 2.0 data transfers.
> @@ -249,7 +244,6 @@ config USB_S3C_HSOTG
>          tristate "S3C HS/OtG USB Device controller"
>          depends on S3C_DEV_USB_HSOTG
>          select USB_GADGET_S3C_HSOTG_PIO
> -       select USB_GADGET_DUALSPEED
>          help
>            The Samsung S3C64XX USB2.0 high-speed gadget controller
>            integrated into the S3C64XX series SoC.
> @@ -287,7 +281,6 @@ config USB_S3C2410_DEBUG
>   config USB_S3C_HSUDC
>          tristate "S3C2416, S3C2443 and S3C2450 USB Device Controller"
>          depends on ARCH_S3C2410
> -       select USB_GADGET_DUALSPEED
>          help
>            Samsung's S3C2416, S3C2443 and S3C2450 is an ARM9 based SoC
>            integrated with dual speed USB 2.0 device controller. It has
> @@ -298,7 +291,6 @@ config USB_S3C_HSUDC
>   config USB_PXA_U2O
>          tristate "PXA9xx Processor USB2.0 controller"
>          depends on ARCH_MMP
> -       select USB_GADGET_DUALSPEED
>          help
>            PXA9xx Processor series include a high speed USB2.0 device
>            controller, which support high speed and full speed USB peripheral.
> @@ -311,14 +303,12 @@ config USB_PXA_U2O
>   config USB_GADGET_MUSB_HDRC
>          tristate "Inventra HDRC USB Peripheral (TI, ADI, ...)"
>          depends on USB_MUSB_HDRC
> -       select USB_GADGET_DUALSPEED
>          help
>            This OTG-capable silicon IP is used in dual designs including
>            the TI DaVinci, OMAP 243x, OMAP 343x, TUSB 6010, and ADI Blackfin
>
>   config USB_M66592
>          tristate "Renesas M66592 USB Peripheral Controller"
> -       select USB_GADGET_DUALSPEED
>          help
>             M66592 is a discrete USB peripheral controller chip that
>             supports both full and high speed USB 2.0 data transfers.
> @@ -335,7 +325,6 @@ config USB_M66592
>   config USB_AMD5536UDC
>          tristate "AMD5536 UDC"
>          depends on PCI
> -       select USB_GADGET_DUALSPEED
>          help
>             The AMD5536 UDC is part of the AMD Geode CS5536, an x86 southbridge.
>             It is a USB Highspeed DMA capable USB device controller. Beside ep0
> @@ -363,7 +352,6 @@ config USB_FSL_QE
>   config USB_CI13XXX_PCI
>          tristate "MIPS USB CI13xxx PCI UDC"
>          depends on PCI
> -       select USB_GADGET_DUALSPEED
>          help
>            MIPS USB IP core family device controller
>            Currently it only supports IP part number CI13412
> @@ -374,7 +362,6 @@ config USB_CI13XXX_PCI
>
>   config USB_NET2272
>          tristate "PLX NET2272"
> -       select USB_GADGET_DUALSPEED
>          help
>            PLX NET2272 is a USB peripheral controller which supports
>            both full and high speed USB 2.0 data transfers.
> @@ -398,7 +385,6 @@ config USB_NET2272_DMA
>   config USB_NET2280
>          tristate "NetChip 228x"
>          depends on PCI
> -       select USB_GADGET_DUALSPEED
>          help
>             NetChip 2280 / 2282 is a PCI based USB peripheral controller which
>             supports both full and high speed USB 2.0 data transfers.
> @@ -429,7 +415,6 @@ config USB_LANGWELL
>          tristate "Intel Langwell USB Device Controller"
>          depends on PCI
>          depends on !PHYS_ADDR_T_64BIT
> -       select USB_GADGET_DUALSPEED
>          help
>             Intel Langwell USB Device Controller is a High-Speed USB
>             On-The-Go device controller.
> @@ -444,7 +429,6 @@ config USB_LANGWELL
>   config USB_EG20T
>          tristate "Intel EG20T PCH/OKI SEMICONDUCTOR ML7213 IOH UDC"
>          depends on PCI
> -       select USB_GADGET_DUALSPEED
>          help
>            This is a USB device driver for EG20T PCH.
>            EG20T PCH is the platform controller hub that is used in Intel's
> @@ -466,7 +450,6 @@ config USB_EG20T
>   config USB_CI13XXX_MSM
>          tristate "MIPS USB CI13xxx for MSM"
>          depends on ARCH_MSM
> -       select USB_GADGET_DUALSPEED
>          select USB_MSM_OTG
>          help
>            MSM SoC has chipidea USB controller.  This driver uses
> @@ -487,8 +470,6 @@ config USB_CI13XXX_MSM
>   config USB_DUMMY_HCD
>          tristate "Dummy HCD (DEVELOPMENT)"
>          depends on USB=y || (USB=m&&  USB_GADGET=m)
> -       select USB_GADGET_DUALSPEED
> -       select USB_GADGET_SUPERSPEED
>          help
>            This host controller driver emulates USB, looping all data transfer
>            requests back to a USB "gadget driver" in the same host.  The host
> @@ -513,17 +494,6 @@ config USB_DUMMY_HCD
>
>   endchoice
>
> -# Selected by UDC drivers that support high-speed operation.
> -config USB_GADGET_DUALSPEED
> -       bool
> -       depends on USB_GADGET
> -
> -# Selected by UDC drivers that support super-speed opperation
> -config USB_GADGET_SUPERSPEED
> -       bool
> -       depends on USB_GADGET
> -       depends on USB_GADGET_DUALSPEED
> -
>   #
>   # USB Gadget Drivers
>   #
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
> index 5a3461e..c5249b3 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -1559,12 +1559,6 @@ composite_resume(struct usb_gadget *gadget)
>   /*-------------------------------------------------------------------------*/
>
>   static struct usb_gadget_driver composite_driver = {
> -#ifdef CONFIG_USB_GADGET_SUPERSPEED
> -       .speed          = USB_SPEED_SUPER,
> -#else
> -       .speed          = USB_SPEED_HIGH,
> -#endif
> -
>          .unbind         = composite_unbind,
>
>          .setup          = composite_setup,
> @@ -1609,8 +1603,7 @@ int usb_composite_probe(struct usb_composite_driver *driver,
>                  driver->iProduct = driver->name;
>          composite_driver.function =  (char *) driver->name;
>          composite_driver.driver.name = driver->name;
> -       composite_driver.speed = min((u8)composite_driver.speed,
> -                                    (u8)driver->max_speed);
> +       composite_driver.speed = driver->max_speed;

This does not works, many drivers will check the driver->speed, ie in musg_gadget.c

static int musb_gadget_start(struct usb_gadget *g,
                 struct usb_gadget_driver *driver)
{
         struct musb             *musb = gadget_to_musb(g);
         unsigned long           flags;
         int                     retval = -EINVAL;

         if (driver->speed != USB_SPEED_HIGH)
                 goto err0;
[snip]

>          composite = driver;
>          composite_gadget_bind = bind;
>
> diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
> index cf875be..61ed4ec 100644
> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -3562,11 +3562,7 @@ static void fsg_resume(struct usb_gadget *gadget)
>   /*-------------------------------------------------------------------------*/
>
>   static struct usb_gadget_driver                fsg_driver = {
> -#ifdef CONFIG_USB_GADGET_DUALSPEED
>          .speed          = USB_SPEED_HIGH,
> -#else
> -       .speed          = USB_SPEED_FULL,
> -#endif
>          .function       = (char *) fsg_string_product,
>          .unbind         = fsg_unbind,
>          .disconnect     = fsg_disconnect,
> diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
> index 1b24099..dddb3e4 100644
> --- a/drivers/usb/gadget/inode.c
> +++ b/drivers/usb/gadget/inode.c
> @@ -837,7 +837,6 @@ ep_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
>                  if (value == 0)
>                          data->state = STATE_EP_ENABLED;
>                  break;
> -#ifdef CONFIG_USB_GADGET_DUALSPEED
>          case USB_SPEED_HIGH:
>                  /* fails if caller didn't provide that descriptor... */
>                  ep->desc =&data->hs_desc;
> @@ -845,7 +844,6 @@ ep_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
>                  if (value == 0)
>                          data->state = STATE_EP_ENABLED;
>                  break;
> -#endif
>          default:
>                  DBG(data->dev, "unconnected, %s init abandoned\n",
>                                  data->name);
> @@ -1331,7 +1329,6 @@ static const struct file_operations ep0_io_operations = {
>    * Unrecognized ep0 requests may be handled in user space.
>    */
>
> -#ifdef CONFIG_USB_GADGET_DUALSPEED
>   static void make_qualifier (struct dev_data *dev)
>   {
>          struct usb_qualifier_descriptor         qual;
> @@ -1354,7 +1351,6 @@ static void make_qualifier (struct dev_data *dev)
>
>          memcpy (dev->rbuf,&qual, sizeof qual);
>   }
> -#endif
>
>   static int
>   config_buf (struct dev_data *dev, u8 type, unsigned index)
> @@ -1434,7 +1430,6 @@ gadgetfs_setup (struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
>                          dev->dev->bMaxPacketSize0 = dev->gadget->ep0->maxpacket;
>                          req->buf = dev->dev;
>                          break;
> -#ifdef CONFIG_USB_GADGET_DUALSPEED
>                  case USB_DT_DEVICE_QUALIFIER:
>                          if (!dev->hs_config)
>                                  break;
> @@ -1444,7 +1439,6 @@ gadgetfs_setup (struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
>                          break;
>                  case USB_DT_OTHER_SPEED_CONFIG:
>                          // FALLTHROUGH
> -#endif
>                  case USB_DT_CONFIG:
>                          value = config_buf (dev,
>                                          w_value>>  8,
> @@ -1773,11 +1767,7 @@ gadgetfs_suspend (struct usb_gadget *gadget)
>   }
>
>   static struct usb_gadget_driver gadgetfs_driver = {
> -#ifdef CONFIG_USB_GADGET_DUALSPEED
>          .speed          = USB_SPEED_HIGH,
> -#else
> -       .speed          = USB_SPEED_FULL,
> -#endif
>          .function       = (char *) driver_desc,
>          .unbind         = gadgetfs_unbind,
>          .setup          = gadgetfs_setup,
> diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
> index a341dde..901b7ba 100644
> --- a/drivers/usb/gadget/printer.c
> +++ b/drivers/usb/gadget/printer.c
> @@ -164,12 +164,6 @@ module_param(qlen, uint, S_IRUGO|S_IWUSR);
>
>   #define QLEN   qlen
>
> -#ifdef CONFIG_USB_GADGET_DUALSPEED
> -#define DEVSPEED       USB_SPEED_HIGH
> -#else   /* full speed (low speed doesn't do bulk) */
> -#define DEVSPEED        USB_SPEED_FULL
> -#endif
> -
>   /*-------------------------------------------------------------------------*/
>
>   #define xprintk(d, level, fmt, args...) \
> @@ -288,8 +282,6 @@ static const struct usb_descriptor_header *fs_printer_function [11] = {
>          NULL
>   };
>
> -#ifdef CONFIG_USB_GADGET_DUALSPEED
> -
>   /*
>    * usb 2.0 devices need to expose both high speed and full speed
>    * descriptors, unless they only run at full speed.
> @@ -328,13 +320,6 @@ static const struct usb_descriptor_header *hs_printer_function [11] = {
>   /* maxpacket and other transfer characteristics vary by speed. */
>   #define ep_desc(g, hs, fs) (((g)->speed == USB_SPEED_HIGH)?(hs):(fs))
>
> -#else
> -
> -/* if there's no high speed support, maxpacket doesn't change. */
> -#define ep_desc(g, hs, fs) (((void)(g)), (fs))
> -
> -#endif /* !CONFIG_USB_GADGET_DUALSPEED */
> -
>   /*-------------------------------------------------------------------------*/
>
>   /* descriptors that are built on-demand */
> @@ -979,9 +964,7 @@ printer_set_config(struct printer_dev *dev, unsigned number)
>
>                  switch (gadget->speed) {
>                  case USB_SPEED_FULL:    speed = "full"; break;
> -#ifdef CONFIG_USB_GADGET_DUALSPEED
>                  case USB_SPEED_HIGH:    speed = "high"; break;
> -#endif
>                  default:                speed = "?"; break;
>                  }
>
> @@ -998,23 +981,15 @@ config_buf(enum usb_device_speed speed, u8 *buf, u8 type, unsigned index,
>   {
>          int                                     len;
>          const struct usb_descriptor_header      **function;
> -#ifdef CONFIG_USB_GADGET_DUALSPEED
>          int                                     hs = (speed == USB_SPEED_HIGH);
>
> +       if (index>= device_desc.bNumConfigurations)
> +               return -EINVAL;
> +
>          if (type == USB_DT_OTHER_SPEED_CONFIG)
>                  hs = !hs;
>
> -       if (hs) {
> -               function = hs_printer_function;
> -       } else {
> -               function = fs_printer_function;
> -       }
> -#else
> -       function = fs_printer_function;
> -#endif
> -
> -       if (index>= device_desc.bNumConfigurations)
> -               return -EINVAL;
> +       function = hs ? hs_printer_function : fs_printer_function;
>
>          /* for now, don't advertise srp-only devices */
>          if (!is_otg)
> @@ -1156,9 +1131,8 @@ printer_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
>                                  value = min(wLength, (u16) sizeof device_desc);
>                                  memcpy(req->buf,&device_desc, value);
>                                  break;
> -#ifdef CONFIG_USB_GADGET_DUALSPEED
>                          case USB_DT_DEVICE_QUALIFIER:
> -                               if (!gadget->is_dualspeed)
> +                               if (!gadget_is_dualspeed(gadget))
>                                          break;
>                                  /*
>                                   * assumes ep0 uses the same value for both
> @@ -1172,10 +1146,9 @@ printer_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
>                                  break;
>
>                          case USB_DT_OTHER_SPEED_CONFIG:
> -                               if (!gadget->is_dualspeed)
> +                               if (!gadget_is_dualspeed(gadget))
>                                          break;
>                                  /* FALLTHROUGH */
> -#endif /* CONFIG_USB_GADGET_DUALSPEED */
>                          case USB_DT_CONFIG:
>                                  value = config_buf(gadget->speed, req->buf,
>                                                  wValue>>  8,
> @@ -1460,11 +1433,9 @@ autoconf_fail:
>                  goto autoconf_fail;
>          out_ep->driver_data = out_ep;   /* claim */
>
> -#ifdef CONFIG_USB_GADGET_DUALSPEED
>          /* assumes that all endpoints are dual-speed */
>          hs_ep_in_desc.bEndpointAddress = fs_ep_in_desc.bEndpointAddress;
>          hs_ep_out_desc.bEndpointAddress = fs_ep_out_desc.bEndpointAddress;
> -#endif /* DUALSPEED */
>
>          usb_gadget_set_selfpowered(gadget);
>
> @@ -1552,7 +1523,7 @@ fail:
>   /*-------------------------------------------------------------------------*/
>
>   static struct usb_gadget_driver printer_driver = {
> -       .speed          = DEVSPEED,
> +       .speed          = USB_SPEED_HIGH,
>
>          .function       = (char *) driver_desc,
>          .unbind         = printer_unbind,
> diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
> index dfed4c1..8642abb 100644
> --- a/drivers/usb/gadget/u_ether.c
> +++ b/drivers/usb/gadget/u_ether.c
> @@ -92,17 +92,10 @@ struct eth_dev {
>
>   #define DEFAULT_QLEN   2       /* double buffering by default */
>
> -
> -#ifdef CONFIG_USB_GADGET_DUALSPEED
> -
>   static unsigned qmult = 5;
>   module_param(qmult, uint, S_IRUGO|S_IWUSR);
>   MODULE_PARM_DESC(qmult, "queue length multiplier at high/super speed");
>
> -#else  /* full speed (low speed doesn't do bulk) */
> -#define qmult          1
> -#endif
> -
>   /* for dual-speed hardware, use deeper queues at high/super speed */
>   static inline int qlen(struct usb_gadget *gadget)
>   {
> --
> 1.7.3.1
>


-- 
Thanks
Yang Ruirui
