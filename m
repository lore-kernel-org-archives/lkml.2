Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab0ESSIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:08:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58859 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0ESSII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:08:08 -0400
Date: Wed, 19 May 2010 11:06:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "David Dajun Chen" <Dajun.Chen@diasemi.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DA9052 Linux device drivers [9/9]
Message-Id: <20100519110644.fbdf732e.randy.dunlap@oracle.com>
In-Reply-To: <3495EC08FA53E94AAA00CC4743D5BA7E010C2107@pandora.diasemi.com>
References: <3495EC08FA53E94AAA00CC4743D5BA7E010C2107@pandora.diasemi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090207.4BF42902.00CF:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 13:46:00 +0100 David Dajun Chen wrote:

> Dear sir/madam,
> 
> The attached is the feature CONFIG part of the device drivers newly developed for DA9052 Power Management IC from Dialog Semiconductor.
> 
> Should you have any queries or comments please feel free to contact me.


Were all of these changes meant to be here?
If so, they need justification.


> ===========================================================================
> 
> 
> diff -Naur linux-2.6.33.2/drivers/Makefile linux-2.6.33.2_patch/drivers/Makefile
> --- linux-2.6.33.2/drivers/Makefile	2010-04-02 04:02:33.000000000 +0500
> +++ linux-2.6.33.2_patch/drivers/Makefile	2010-05-12 09:44:14.000000000 +0500
> @@ -5,13 +5,15 @@
>  # Rewritten to use lists instead of if-statements.
>  #
>  
> +ifneq ($(CONFIG_MFD_DA9052),y)
>  obj-y				+= gpio/
> +endif
> +
>  obj-$(CONFIG_PCI)		+= pci/
>  obj-$(CONFIG_PARISC)		+= parisc/
>  obj-$(CONFIG_RAPIDIO)		+= rapidio/
>  obj-y				+= video/
>  obj-$(CONFIG_ACPI)		+= acpi/
> -obj-$(CONFIG_SFI)		+= sfi/
>  # PnP must come after ACPI since it will eventually need to check if acpi
>  # was used and do nothing if so
>  obj-$(CONFIG_PNP)		+= pnp/
> @@ -19,9 +21,6 @@
>  
>  obj-$(CONFIG_XEN)		+= xen/
>  
> -# regulators early, since some subsystems rely on them to initialize
> -obj-$(CONFIG_REGULATOR)		+= regulator/
> -
>  # char/ comes before serial/ etc so that the VT console is the boot-time
>  # default.
>  obj-y				+= char/
> @@ -37,22 +36,27 @@
>  
>  obj-y				+= serial/
>  obj-$(CONFIG_PARPORT)		+= parport/
> -obj-y				+= base/ block/ misc/ mfd/
> +
> +ifneq ($(CONFIG_MFD_DA9052),y)
> +obj-y				+= base/ block/ misc/ mfd/ net/ media/
> +else
> +obj-y				+= base/ block/ misc/ net/ media/
> +endif
> +
>  obj-$(CONFIG_NUBUS)		+= nubus/
> +obj-$(CONFIG_ATM)		+= atm/
>  obj-y				+= macintosh/
>  obj-$(CONFIG_IDE)		+= ide/
>  obj-$(CONFIG_SCSI)		+= scsi/
>  obj-$(CONFIG_ATA)		+= ata/
> -obj-$(CONFIG_MTD)		+= mtd/
> -obj-$(CONFIG_SPI)		+= spi/
> -obj-y				+= net/
> -obj-$(CONFIG_ATM)		+= atm/
>  obj-$(CONFIG_FUSION)		+= message/
>  obj-$(CONFIG_FIREWIRE)		+= firewire/
>  obj-y				+= ieee1394/
>  obj-$(CONFIG_UIO)		+= uio/
>  obj-y				+= cdrom/
>  obj-y				+= auxdisplay/
> +obj-$(CONFIG_MTD)		+= mtd/
> +obj-$(CONFIG_SPI)		+= spi/
>  obj-$(CONFIG_PCCARD)		+= pcmcia/
>  obj-$(CONFIG_DIO)		+= dio/
>  obj-$(CONFIG_SBUS)		+= sbus/
> @@ -62,23 +66,37 @@
>  obj-$(CONFIG_PARIDE) 		+= block/paride/
>  obj-$(CONFIG_TC)		+= tc/
>  obj-$(CONFIG_UWB)		+= uwb/
> -obj-$(CONFIG_USB_OTG_UTILS)	+= usb/otg/
>  obj-$(CONFIG_USB)		+= usb/
>  obj-$(CONFIG_USB_MUSB_HDRC)	+= usb/musb/
>  obj-$(CONFIG_PCI)		+= usb/
>  obj-$(CONFIG_USB_GADGET)	+= usb/gadget/
>  obj-$(CONFIG_SERIO)		+= input/serio/
>  obj-$(CONFIG_GAMEPORT)		+= input/gameport/
> +
> +ifneq ($(CONFIG_MFD_DA9052),y)
>  obj-$(CONFIG_INPUT)		+= input/
> +endif
> +
>  obj-$(CONFIG_I2O)		+= message/
> +
> +ifneq ($(CONFIG_MFD_DA9052),y)
>  obj-$(CONFIG_RTC_LIB)		+= rtc/
> -obj-y				+= i2c/ media/
> -obj-$(CONFIG_PPS)		+= pps/
> +endif
> +
> +obj-y				+= i2c/
>  obj-$(CONFIG_W1)		+= w1/
> +
> +ifneq ($(CONFIG_MFD_DA9052),y)
>  obj-$(CONFIG_POWER_SUPPLY)	+= power/
> +endif
> +
>  obj-$(CONFIG_HWMON)		+= hwmon/
>  obj-$(CONFIG_THERMAL)		+= thermal/
> +
> +ifeq ($(CONFIG_MFD_DA9052),n)
>  obj-$(CONFIG_WATCHDOG)		+= watchdog/
> +endif
> +
>  obj-$(CONFIG_PHONE)		+= telephony/
>  obj-$(CONFIG_MD)		+= md/
>  obj-$(CONFIG_BT)		+= bluetooth/
> @@ -93,7 +111,11 @@
>  obj-y				+= idle/
>  obj-$(CONFIG_MMC)		+= mmc/
>  obj-$(CONFIG_MEMSTICK)		+= memstick/
> +
> +ifneq ($(CONFIG_MFD_DA9052),y)
>  obj-$(CONFIG_NEW_LEDS)		+= leds/
> +endif
> +
>  obj-$(CONFIG_INFINIBAND)	+= infiniband/
>  obj-$(CONFIG_SGI_SN)		+= sn/
>  obj-y				+= firmware/
> @@ -107,7 +129,20 @@
>  obj-$(CONFIG_OF)		+= of/
>  obj-$(CONFIG_SSB)		+= ssb/
>  obj-$(CONFIG_VIRTIO)		+= virtio/
> -obj-$(CONFIG_VLYNQ)		+= vlynq/
> +
> +ifneq ($(CONFIG_MFD_DA9052),y)
> +obj-$(CONFIG_REGULATOR)		+= regulator/
> +endif
> +
>  obj-$(CONFIG_STAGING)		+= staging/
> -obj-y				+= platform/
> -obj-y				+= ieee802154/
> +
> +ifeq ($(CONFIG_MFD_DA9052),y)
> +obj-y				+= mfd/
> +obj-y				+= gpio/
> +obj-$(CONFIG_INPUT)		+= input/
> +obj-$(CONFIG_RTC_LIB)		+= rtc/
> +obj-$(CONFIG_POWER_SUPPLY)	+= power/
> +obj-$(CONFIG_WATCHDOG)		+= watchdog/
> +obj-$(CONFIG_NEW_LEDS)		+= leds/
> +obj-$(CONFIG_REGULATOR)		+= regulator/
> +endif


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
