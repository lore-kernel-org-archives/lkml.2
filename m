Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab2GYWrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 18:47:53 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51214 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751551Ab2GYWrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 18:47:52 -0400
X-Sasl-enc: xczFnabk5HGg+aJHwHTOIoCLZdTpEvpqSLTYL5W/eXOK 1343256471
Date: Wed, 25 Jul 2012 15:47:50 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20120725224750.GB14020@kroah.com>
References: <20120720132840.f8269e2c3658daa010904dca@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120720132840.f8269e2c3658daa010904dca@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 01:28:40PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the tty tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/staging/ipack/devices/ipoctal.c: In function 'ipoctal_set_termios':
> drivers/staging/ipack/devices/ipoctal.c:614:22: error: invalid type argument of '->' (have 'struct ktermios')
> drivers/staging/ipack/devices/ipoctal.c:640:15: error: invalid type argument of '->' (have 'struct ktermios')
> drivers/staging/ipack/devices/ipoctal.c:654:14: error: invalid type argument of '->' (have 'struct ktermios')
> drivers/staging/ipack/devices/ipoctal.c:691:2: error: incompatible type for argument 1 of 'tty_termios_encode_baud_rate'
> include/linux/tty.h:449:13: note: expected 'struct ktermios *' but argument is of type 'struct ktermios'
> drivers/staging/ipack/devices/ipoctal.c:694:22: error: invalid type argument of '->' (have 'struct ktermios')
> drivers/staging/ipack/devices/ipoctal.c:735:3: error: incompatible type for argument 1 of 'tty_termios_encode_baud_rate'
> include/linux/tty.h:449:13: note: expected 'struct ktermios *' but argument is of type 'struct ktermios'
> 
> Presumably caused by commit adc8d746caa6 ("tty: move the termios object
> into the tty").
> 
> Under previous instructions about staging drivers, I have added the
> following patch for today:
> 
> From c4bc70a8fc9cc687690aaf51865561ffcd6190f9 Mon Sep 17 00:00:00 2001
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 20 Jul 2012 13:25:12 +1000
> Subject: [PATCH] disable SERIAL_IPOCTAL broken by tty updates
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/staging/ipack/devices/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/ipack/devices/Kconfig b/drivers/staging/ipack/devices/Kconfig
> index 39f7188..8d69ce3 100644
> --- a/drivers/staging/ipack/devices/Kconfig
> +++ b/drivers/staging/ipack/devices/Kconfig
> @@ -1,6 +1,7 @@
>  config SERIAL_IPOCTAL
>  	tristate "IndustryPack IP-OCTAL uart support"
>  	depends on IPACK_BUS
> +	depends on BROKEN
>  	help
>  	  This driver supports the IPOCTAL serial port device for the IndustryPack bus.
>  	default n

Alan, care to send me a patch for this?

thanks,

greg k-h
