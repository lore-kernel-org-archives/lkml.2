Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967Ab2JHL6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 07:58:01 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57544 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2JHL57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 07:57:59 -0400
Date: Mon, 8 Oct 2012 07:58:43 -0400
From: Matt Porter <mporter@ti.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 7/7] ARM: davinci: register pruss_uio device on DA850
 EVM
Message-ID: <20121008115843.GP11149@beef>
References: <1349456686-22736-1-git-send-email-mporter@ti.com>
 <1349456686-22736-8-git-send-email-mporter@ti.com>
 <5072B091.1040007@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5072B091.1040007@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 04:23:05PM +0530, Sekhar Nori wrote:
> On 10/5/2012 10:34 PM, Matt Porter wrote:
> > Configures the required pdata and registers the pruss_uio
> > platform device on the DA850 EVM.
> > 
> > Tested on AM180x-EVM using the PRU_memAccessPRUDataRam and
> > PRU_memAccessL3andDDR examples from the PRU userspace tools
> > available from http://www.ti.com/tool/sprc940
> > 
> > Signed-off-by: Matt Porter <mporter@ti.com>
> > ---
> >  arch/arm/mach-davinci/board-da850-evm.c |   12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> > index 7359375..6f9478b 100644
> > --- a/arch/arm/mach-davinci/board-da850-evm.c
> > +++ b/arch/arm/mach-davinci/board-da850-evm.c
> > @@ -31,6 +31,7 @@
> >  #include <linux/platform_data/mtd-davinci.h>
> >  #include <linux/platform_data/mtd-davinci-aemif.h>
> >  #include <linux/platform_data/spi-davinci.h>
> > +#include <linux/platform_data/uio_pruss.h>
> >  #include <linux/regulator/machine.h>
> >  #include <linux/regulator/tps6507x.h>
> >  #include <linux/spi/spi.h>
> > @@ -40,6 +41,7 @@
> >  #include <mach/cp_intc.h>
> >  #include <mach/da8xx.h>
> >  #include <mach/mux.h>
> > +#include <mach/sram.h>
> >  
> >  #include <asm/mach-types.h>
> >  #include <asm/mach/arch.h>
> > @@ -1253,6 +1255,10 @@ static __init int da850_wl12xx_init(void)
> >  
> >  #endif /* CONFIG_DA850_WL12XX */
> >  
> > +struct uio_pruss_pdata da8xx_pruss_uio_pdata = {
> > +	.pintc_base	= 0x4000,
> > +};
> > +
> >  #define DA850EVM_SATA_REFCLKPN_RATE	(100 * 1000 * 1000)
> >  
> >  static __init void da850_evm_init(void)
> > @@ -1339,6 +1345,12 @@ static __init void da850_evm_init(void)
> >  		pr_warning("da850_evm_init: lcdcntl mux setup failed: %d\n",
> >  				ret);
> >  
> > +	da8xx_pruss_uio_pdata.sram_pool = sram_get_gen_pool();
> > +	ret = da8xx_register_pruss_uio(&da8xx_pruss_uio_pdata);
> > +	if (ret)
> > +		pr_warning("pruss_uio initialization failed: %d\n",
> > +				ret);
> 
> I failed to mention this last time around, but is there any reason
> platform data will change from board to board? Looks like the pintc_base
> is SoC specific and that all platforms would use SRAM when using the
> pruss driver. Looks like you can make da8xx_register_pruss_uio() take no
> parameters at all.

No reason, just oversight here. I'll update these two patches so this is
done at the SoC level.

-Matt
