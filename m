Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab3AIQsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:48:06 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38257 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3AIQsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:48:04 -0500
Date: Wed, 9 Jan 2013 11:52:35 -0500
From: Matt Porter <mporter@ti.com>
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: tps65910: Select REGMAP_IRQ in Kconfig to fix build
 error
Message-ID: <20130109165235.GJ14660@beef>
References: <1355138096-7702-1-git-send-email-anilkumar@ti.com>
 <331ABD5ECB02734CA317220B2BBEABC13EAD58CF@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13EAD58CF@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 10:15:39AM +0000, AnilKumar wrote:
> On Mon, Dec 10, 2012 at 16:44:56, AnilKumar, Chimata wrote:
> > TPS65910 mfd driver uses functions that are only avaiable when
> > REGMAP_IRQ is enabled. So "select REGMAP_IRQ" is added to mfd
> > Kconfig to fix below build error:
> > 
> > drivers/built-in.o: In function `tps65910_irq_exit':
> > /media/anil/kernel/drivers/mfd/tps65910.c:265: undefined reference to `regmap_del_irq_chip'
> > drivers/built-in.o: In function `tps65910_irq_init':
> > /media/anil/kernel/drivers/mfd/tps65910.c:254: undefined reference to `regmap_add_irq_chip'
> > drivers/built-in.o: In function `tps65910_i2c_probe':
> > /media/anil/kernel/drivers/mfd/tps65910.c:509: undefined reference to `regmap_irq_get_domain'
> > make: *** [vmlinux] Error 1
> > 
> > Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
> > ---
> >  drivers/mfd/Kconfig |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index 1c0abd4..01413a2 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -237,6 +237,7 @@ config MFD_TPS65910
> >  	depends on I2C=y && GPIOLIB
> >  	select MFD_CORE
> >  	select REGMAP_I2C
> > +	select REGMAP_IRQ
> >  	select IRQ_DOMAIN
> >  	help
> >  	  if you say yes here you get support for the TPS65910 series of
> 
> Hi Samuel,
> 
> Could you please pull this fix?
 
Tested-by: Matt Porter <mporter@ti.com>

Fixes broken OMAP kernel build here too.

-Matt
