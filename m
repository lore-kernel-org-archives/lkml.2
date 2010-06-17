Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760838Ab0FQXHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:07:31 -0400
Received: from kroah.org ([198.145.64.141]:42897 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714Ab0FQXH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:07:29 -0400
Date: Thu, 17 Jun 2010 15:51:08 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Mark Rankilor <reodge@gmail.com>, devel@driverdev.osuosl.org,
       Henri =?iso-8859-1?Q?H=E4kkinen?= <henuxd@gmail.com>, gregkh@suse.de,
       andrea.gelmini@gelma.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:comedi: Fixed coding convention issues.
Message-ID: <20100617225108.GA32334@kroah.com>
References: <1276337681-4327-1-git-send-email-henuxd@gmail.com>
 <AANLkTimUt_Lhk6lG9spM9qjRT8T6PhEDVyOhh745lJhW@mail.gmail.com>
 <1276405626.1449.26.camel@Joe-Laptop.home>
 <1276407050.1449.28.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276407050.1449.28.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 12, 2010 at 10:30:50PM -0700, Joe Perches wrote:
> On Sat, 2010-06-12 at 22:07 -0700, Joe Perches wrote:
> > 2: Create some comedi logging functions or macros like:
> >    	comedi_<level>(fmt, arg...) (ie: comedi_info, comedi_err, etc)
> >    where "comedi:" is always prefixed and an
> >    optional #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >    could be used.
> 
> Maybe this is a start:
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/staging/comedi/comedidev.h |   54 ++++++++++++++++++++++++++++++++++--
>  1 files changed, 51 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index 4eb2b77..6c2bdde 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -43,11 +43,59 @@
>  
>  #include "comedi.h"
>  
> -#define DPRINTK(format, args...)	do {		\
> -	if (comedi_debug)				\
> -		printk(KERN_DEBUG "comedi: " format , ## args);	\
> +#define comedi_printk(level, fmt, args...)			\
> +	printk(level "comedi: " pr_fmt(fmt), ##args)
> +
> +#define DPRINTK(format, args...)				\
> +do {								\
> +	if (comedi_debug)					\
> +		comedi_printk(KERN_DEBUG, fmt, ##args);		\
>  } while (0)
>  
> +#define comedi_emerg(fmt, ...)				\
> +	comedi_printk(KERN_EMERG, fmt, ##__VA_ARGS__)

I would prefer the conversion of everything over to the dev_printk()
versions instead of creating a new macro for every individual subsystem.
That way you get the advantage of logging everything in the common
format and the dynamic debug functionality as well.

thanks,

greg k-h
