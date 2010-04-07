Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab0DGHmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 03:42:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:37926 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab0DGHmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 03:42:14 -0400
Subject: Re: [PATCH] 460EX on-chip SATA driver<kernel 2.6.33> <
 resubmission : 02>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Rupjyoti Sarmah <rsarmah@amcc.com>, linux-ide@vger.kernel.org, sr@denx.de,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <4BBB5045.5020004@pobox.com>
References: <201004061141.o36BfTsr028163@amcc.com>
	 <4BBB5045.5020004@pobox.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 17:41:56 +1000
Message-ID: <1270626116.2300.68.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 11:16 -0400, Jeff Garzik wrote:
> > +static irqreturn_t dma_dwc_interrupt(int irq, void *hsdev_instance)
> > +{
> > +     int chan;
> > +     u32 tfr_reg, err_reg;
> > +
> > +     struct sata_dwc_device *hsdev =
> > +             (struct sata_dwc_device *) hsdev_instance;
> > +     struct ata_host *host = (struct ata_host *) hsdev->host;
> > +     struct ata_port *ap;
> > +     struct sata_dwc_device_port *hsdevp;
> > +     u8 tag = 0;
> > +     unsigned int port = 0;
> > +     struct sata_dwc_host_priv *hp;
> > +     hp = kmalloc(sizeof(*hp), GFP_KERNEL);
> 
> 1) interrupt is not GFP_KERNEL
> 
> 2) you must failure kmalloc failure
> 
> 3) it is not clear to me where you initialize this structure???

And why the heck would you want to allocate it at interrupt time ? ? ?

BTW. Stefan mentioned earlier that they had some fixes for that driver
in the Denx tree. Are those fixes now included in that variant ?

Cheers,
Ben.


