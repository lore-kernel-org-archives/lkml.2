Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab1G0WFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:05:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56897 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527Ab1G0WFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 18:05:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 1/2] MMC / TMIO: Fix build issue related to struct scatterlist
Date: Thu, 28 Jul 2011 00:06:26 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-mmc@vger.kernel.org
References: <201107262049.15333.rjw@sisk.pl> <201107262050.23379.rjw@sisk.pl> <m2pqkvl7l6.fsf@bob.laptop.org>
In-Reply-To: <m2pqkvl7l6.fsf@bob.laptop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201107280006.26466.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 27, 2011, Chris Ball wrote:
> Hi Rafael,
> 
> On Tue, Jul 26 2011, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Fix build issue caused by undefined struct scatterlist in
> > drivers/mmc/host/tmio_mmc.c.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/mmc/host/tmio_mmc.h      |    1 +
> >  drivers/usb/renesas_usbhs/fifo.c |    1 +
> >  2 files changed, 2 insertions(+)
> >
> > Index: linux-2.6/drivers/mmc/host/tmio_mmc.h
> > ===================================================================
> > --- linux-2.6.orig/drivers/mmc/host/tmio_mmc.h
> > +++ linux-2.6/drivers/mmc/host/tmio_mmc.h
> > @@ -21,6 +21,7 @@
> >  #include <linux/mutex.h>
> >  #include <linux/pagemap.h>
> >  #include <linux/spinlock.h>
> > +#include <linux/scatterlist.h>
> >  
> >  /* Definitions for values the CTRL_SDIO_STATUS register can take. */
> >  #define TMIO_SDIO_STAT_IOIRQ	0x0001
> 
> I'm not able to reproduce the build failure here.
> 
> drivers/mmc/host/tmio_mmc.c already performs "#include <linux/scatterlist.h>"
> itself (and always has done), so I'm confused about why this is necessary.
> Do you have a copy of your build log with the error?

tmio_mmc.h is included by sh_mobile_sdhi.c too and that one doesn't include
scatterlist.h, which causes a build failure to happen, becuase of the
bounce_sg member of struct tmio_mmc_host.

The patch has been merged already anyway.

Thanks,
Rafael
