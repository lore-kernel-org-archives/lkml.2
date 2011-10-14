Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab1JNJ7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:59:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64887 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab1JNJ7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:59:10 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: fix for transport xfer attributes
Date: Fri, 14 Oct 2011 11:58:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9-0.7-desktop-00073-g37cf951-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gwendal Grignou `" <gwendal@google.com>,
        Grant Grundler <grundler@google.com>
References: <201110132203.45394.bzolnier@gmail.com> <4E9762DE.1060009@pobox.com>
In-Reply-To: <4E9762DE.1060009@pobox.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110141158.33983.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:

> On 10/13/2011 04:03 PM, Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> > Subject: [PATCH] libata: fix for transport xfer attributes
> >
> > Fix display of pio_mode, dma_mode and xfer_mode device attributes.
> >
> > before:
> > $ cat /sys/class/ata_device/dev1.0/xfer_mode
> > XFER_UDMA_7, XFER_UDMA_6, XFER_UDMA_5, XFER_UDMA_4, XFER_UDMA_3, XFER_UDMA_2, XF
> > ER_UDMA_1, XFER_UDMA_0, XFER_MW_DMA_4, XFER_MW_DMA_3, XFER_MW_DMA_2, XFER_SW_DMA
> > _2, XFER_PIO_6, XFER_PIO_5, XFER_PIO_4, XFER_PIO_3, XFER_PIO_2
> >
> > after:
> > $ cat /sys/class/ata_device/dev1.0/xfer_mode
> > XFER_UDMA_6
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> > ---
> >   Documentation/ABI/testing/sysfs-ata |    4 ++--
> >   drivers/ata/libata-transport.c      |    2 +-
> >   2 files changed, 3 insertions(+), 3 deletions(-)
> >
> > Index: b/Documentation/ABI/testing/sysfs-ata
> > ===================================================================
> > --- a/Documentation/ABI/testing/sysfs-ata
> > +++ b/Documentation/ABI/testing/sysfs-ata
> > @@ -59,12 +59,12 @@ class
> >
> >   dma_mode
> >
> > -	Transfer modes supported by the device when in DMA mode.
> > +	Transfer mode currently used by the device when in DMA mode.
> >   	Mostly used by PATA device.
> >
> >   pio_mode
> >
> > -	Transfer modes supported by the device when in PIO mode.
> > +	Transfer mode currently used by the device when in PIO mode.
> >   	Mostly used by PATA device.
> >
> >   xfer_mode
> > Index: b/drivers/ata/libata-transport.c
> > ===================================================================
> > --- a/drivers/ata/libata-transport.c
> > +++ b/drivers/ata/libata-transport.c
> > @@ -194,7 +194,7 @@ static struct {
> >   	{ XFER_PIO_0,			"XFER_PIO_0" },
> >   	{ XFER_PIO_SLOW,		"XFER_PIO_SLOW" }
> >   };
> > -ata_bitfield_name_match(xfer,ata_xfer_names)
> > +ata_bitfield_name_search(xfer, ata_xfer_names)
> 
> "fix" or not it is an ABI change... who is impacted?  Has anyone used 
> the current, pre-patch behavior as documented?

I doubt that anyone has used it given the current incorrect behavior but lets
ask libata transport authors..
