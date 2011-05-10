Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab1EJT5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 15:57:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39783 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab1EJT5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 15:57:41 -0400
Subject: Re: linux-next: build failure after merge of the voltage tree
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <6B0D58A8-B278-49D6-835F-C38E7517FCD5@slimlogic.co.uk>
References: <20110510124434.b30a7631.sfr@canb.auug.org.au>
	 <1305016712.3206.2.camel@odin>
	 <6B0D58A8-B278-49D6-835F-C38E7517FCD5@slimlogic.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 20:57:37 +0100
Message-ID: <1305057457.3206.45.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 12:30 -0500, Jorge Eduardo Candelaria wrote:
> On May 10, 2011, at 3:38 AM, Liam Girdwood wrote:
> 
> > On Tue, 2011-05-10 at 12:44 +1000, Stephen Rothwell wrote:
> >> Hi Liam,
> >> 
> >> After merging the voltage tree, today's linux-next build (x86_64
> >> allmodconfig) failed like this:
> >> 
> >> ERROR: "tps65910_gpio_init" [drivers/mfd/tps65910.ko] undefined!
> >> ERROR: "tps65910_irq_init" [drivers/mfd/tps65910.ko] undefined!
> >> ERROR: "irq_modify_status" [drivers/mfd/tps65910-irq.ko] undefined!
> >> ERROR: "irq_set_chip_and_handler_name" [drivers/mfd/tps65910-irq.ko] undefined!
> >> ERROR: "handle_edge_irq" [drivers/mfd/tps65910-irq.ko] undefined!
> >> 
> >> I have used the voltage tree from next-20110509 for today.
> > 
> > Jorge, could you send a fix for this today.
> > 
> > Thanks
> > 
> > Liam
> > 
> 
> The following patch should solve this:
> 
> From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
> MFD: Fix TPS65910 build
> 
> Support for tps65910 as a module is not available. The driver can
> only be compiled as built-in. OTOH, the regulator driver can still
> be built as module without breaking the compilation.
> 
> Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
> ---
>  drivers/mfd/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 65930a7..c78865e 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -672,8 +672,8 @@ config MFD_OMAP_USB_HOST
>  	  OMAP USB Host drivers.
>  
>  config MFD_TPS65910
> -	tristate "TPS65910 Power Management chip"
> -	depends on I2C &&  GPIOLIB
> +	bool "TPS65910 Power Management chip"
> +	depends on I2C && GPIOLIB
>  	select MFD_CORE
>  	help
>  	  if you say yes here you get support for the TPS65910 series of


Applied.

Thanks

Liam

