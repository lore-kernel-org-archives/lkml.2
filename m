Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab1BVF3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 00:29:55 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:33946 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab1BVF3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 00:29:54 -0500
Date: Mon, 21 Feb 2011 21:29:33 -0800
From: Andres Salomon <dilinger@queued.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
        driverdevel <devel@driverdev.osuosl.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>
Subject: Re: [PATCH -next] staging: fix olpc_dcon kconfig and build errors
Message-ID: <20110221212933.573a8a3e@debxo>
In-Reply-To: <20110221143908.96e03b3c.randy.dunlap@oracle.com>
References: <20110221182134.09abd232.sfr@canb.auug.org.au>
	<20110221143908.96e03b3c.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks correct, thanks!

Acked-By: Andres Salomon <dilinger@queued.net>


On Mon, 21 Feb 2011
14:39:08 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c:106: error:
> 'acpi_gbl_FADT' undeclared (first use in this function)
> 
> Fixing that one gives:
> 
> ERROR:
> "backlight_device_register" [drivers/staging/olpc_dcon/olpc-dcon.ko]
> undefined! ERROR:
> "registered_fb" [drivers/staging/olpc_dcon/olpc-dcon.ko] undefined!
> ERROR: "lock_fb_info" [drivers/staging/olpc_dcon/olpc-dcon.ko]
> undefined! ERROR:
> "backlight_device_unregister" [drivers/staging/olpc_dcon/olpc-dcon.ko]
> undefined! ERROR:
> "num_registered_fb" [drivers/staging/olpc_dcon/olpc-dcon.ko]
> undefined! ERROR: "fb_blank" [drivers/staging/olpc_dcon/olpc-dcon.ko]
> undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Greg Kroah-Hartman <greg@kroah.com>
> Cc: Andres Salomon <dilinger@queued.net>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: Jon Nettleton <jon.nettleton@gmail.com>
> ---
>  drivers/staging/olpc_dcon/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-next-20110221.orig/drivers/staging/olpc_dcon/Kconfig
> +++ linux-next-20110221/drivers/staging/olpc_dcon/Kconfig
> @@ -1,6 +1,6 @@
>  config FB_OLPC_DCON
>  	tristate "One Laptop Per Child Display CONtroller support"
> -	depends on OLPC
> +	depends on OLPC && FB
>  	select I2C
>  	---help---
>  	  Add support for the OLPC XO DCON controller.  This
> controller is @@ -19,7 +19,7 @@ config FB_OLPC_DCON_1
>  
>  config FB_OLPC_DCON_1_5
>  	bool "OLPC XO-1.5 DCON support"
> -	depends on FB_OLPC_DCON
> +	depends on FB_OLPC_DCON && ACPI
>  	default y
>  	---help---
>  	  Enable support for the DCON in XO-1.5 model laptops.  The
> kernel

