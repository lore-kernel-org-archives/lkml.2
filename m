Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab1EKQ30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:29:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59842 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642Ab1EKQ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:29:20 -0400
Subject: Re: linux-next: build failure after merge of the voltage tree
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>
In-Reply-To: <9185B06E-E2C4-4F35-8605-9654CA3BA966@slimlogic.co.uk>
References: <20110510124434.b30a7631.sfr@canb.auug.org.au>
	 <1305016712.3206.2.camel@odin>
	 <6B0D58A8-B278-49D6-835F-C38E7517FCD5@slimlogic.co.uk>
	 <20110511122738.93d239cb.sfr@canb.auug.org.au>
	 <9185B06E-E2C4-4F35-8605-9654CA3BA966@slimlogic.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 14:29:43 +0100
Message-ID: <1305120583.3277.14.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 01:43 -0500, Jorge Eduardo Candelaria wrote:
> On May 10, 2011, at 9:27 PM, Stephen Rothwell wrote:
> 
> > Hi Jorge,
> > 
> > On Tue, 10 May 2011 12:30:36 -0500 Jorge Eduardo Candelaria <jedu@slimlogic.co.uk> wrote:
> >> 
> >> On May 10, 2011, at 3:38 AM, Liam Girdwood wrote:
> >> 
> >>> On Tue, 2011-05-10 at 12:44 +1000, Stephen Rothwell wrote:
> >>>> Hi Liam,
> >>>> 
> >>>> After merging the voltage tree, today's linux-next build (x86_64
> >>>> allmodconfig) failed like this:
> >>>> 
> >>>> ERROR: "tps65910_gpio_init" [drivers/mfd/tps65910.ko] undefined!
> >>>> ERROR: "tps65910_irq_init" [drivers/mfd/tps65910.ko] undefined!
> >>>> ERROR: "irq_modify_status" [drivers/mfd/tps65910-irq.ko] undefined!
> >>>> ERROR: "irq_set_chip_and_handler_name" [drivers/mfd/tps65910-irq.ko] undefined!
> >>>> ERROR: "handle_edge_irq" [drivers/mfd/tps65910-irq.ko] undefined!
> >>>> 
> >>>> I have used the voltage tree from next-20110509 for today.
> >>> 
> >>> Jorge, could you send a fix for this today.
> >> 
> >> The following patch should solve this:
> >> 
> >> From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
> >> MFD: Fix TPS65910 build
> >> 
> >> Support for tps65910 as a module is not available. The driver can
> >> only be compiled as built-in. OTOH, the regulator driver can still
> >> be built as module without breaking the compilation.
> >> 
> >> Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
> > 
> > Today (even with the above patch included) I got these errors from the
> > x86_64 allmodconfig build:
> > 
> > tps65910.c:(.text+0xf4140): undefined reference to `i2c_master_send'
> > drivers/built-in.o: In function `tps65910_i2c_read':
> > tps65910.c:(.text+0xf41d2): undefined reference to `i2c_transfer'
> > drivers/built-in.o: In function `tps65910_i2c_init':
> > tps65910.c:(.init.text+0xcb83): undefined reference to `i2c_register_driver'
> > drivers/built-in.o: In function `tps65910_i2c_exit':
> > tps65910.c:(.exit.text+0x6e0): undefined reference to `i2c_del_driver'
> > 
> > I have used the voltage tree from next-20110509 again today.
> 
> Following patch should fix the dependency problems. Please review:
> 
> From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
> [PATCH] MFD: TPS65910: Fix I2C dependency
> 
> TPS65910 driver can only be compiled built-in, so the I2C driver
> should be as well.
> 
> Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
> ---
>  drivers/mfd/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index c78865e..0131d49 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -673,7 +673,7 @@ config MFD_OMAP_USB_HOST
>  
>  config MFD_TPS65910
>  	bool "TPS65910 Power Management chip"
> -	depends on I2C && GPIOLIB
> +	depends on I2C=y && GPIOLIB
>  	select MFD_CORE
>  	help
>  	  if you say yes here you get support for the TPS65910 series of

Now applied.

Liam

