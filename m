Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877Ab2D0RPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:15:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54885 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760840Ab2D0RPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:15:25 -0400
Date: Fri, 27 Apr 2012 18:14:33 +0100
From: Will Deacon <will.deacon@arm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Arnd Bergmann <arnd@arndb.de>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 1/2] asm-generic: io: remove {read,write} string functions
Message-ID: <20120427171433.GE14743@mudshark.cambridge.arm.com>
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com>
 <4F9AC806.60608@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9AC806.60608@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 05:23:34PM +0100, H. Peter Anvin wrote:
> On 04/27/2012 03:42 AM, Will Deacon wrote:
> > The {read,write}s{b,w,l} functions are not defined across all
> > architectures and therefore shouldn't be used by portable drivers. We
> > should encourage driver writers to use the io{read,write}{8,16,32}_rep
> > functions instead.
> 
> Why is that?  ioread/write are great if the address space is undefined,
> but do we need the extra overhead in any other cases?

I think it's because in reality not many drivers are using
the {read,write}s{b,w,l} accessors:

drivers/bluetooth/btmrvl_sdio.c
drivers/bluetooth/btsdio.c
drivers/i2c/busses/i2c-tegra.c
drivers/mmc/core/sdio_io.c
drivers/mmc/host/msm_sdcc.c
drivers/mmc/host/mvsdio.c
drivers/mmc/host/omap.c
drivers/mmc/host/tmio_mmc.h
drivers/mtd/nand/atmel_nand.c
drivers/mtd/nand/gpio.c
drivers/mtd/nand/omap2.c
drivers/mtd/nand/pxa3xx_nand.c
drivers/mtd/nand/s3c2410.c
drivers/net/ethernet/8390/ax88796.c
drivers/net/ethernet/8390/etherh.c
drivers/net/ethernet/davicom/dm9000.c
drivers/net/ethernet/seeq/ether3.c
drivers/net/ethernet/smsc/smc911x.h
drivers/net/ethernet/smsc/smc91x.h
drivers/net/ethernet/smsc/smsc911x.c
drivers/net/wireless/ath/ath6kl/sdio.c
drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
drivers/net/wireless/libertas/if_sdio.c
drivers/net/wireless/mwifiex/sdio.c
drivers/net/wireless/wl12xx/sdio.c
drivers/parport/parport_ip32.c
drivers/pci/hotplug/ibmphp_core.c
drivers/pci/hotplug/ibmphp_ebda.c
drivers/pci/hotplug/ibmphp.h
drivers/pci/hotplug/ibmphp_hpc.c
drivers/scsi/arm/arxescsi.c
drivers/scsi/arm/cumana_2.c
drivers/scsi/arm/oak.c
drivers/ssb/sdio.c
drivers/usb/gadget/at91_udc.c
drivers/usb/gadget/s3c2410_udc.c
drivers/usb/gadget/s3c-hsotg.c
drivers/usb/host/isp1362.h
drivers/usb/musb/am35x.c
drivers/usb/musb/musb_core.c
drivers/usb/musb/musb_io.h
drivers/usb/musb/tusb6010.c

If you remove the architecture-specific drivers, there's really not a lot left
and, even then, we only need to convert those drivers which are intended to
be portable between architectures where the string functions are not
consistently available.

By overheads, I assume you're referring to the IO_COND check on the address
space? I wouldn't expect this to be noticeable compared to the cost of the
I/O access and I'm not sure it's worth worrying about for the sake of the
small number of drivers affected.

Will
