Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab0D0Wam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 18:30:42 -0400
Received: from kroah.org ([198.145.64.141]:55947 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067Ab0D0WaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 18:30:09 -0400
Date: Tue, 27 Apr 2010 15:26:03 -0700
From: Greg KH <greg@kroah.com>
To: Gustavo Silva <silvagustavosilva@gmail.com>
Cc: gregkh@suse.de, shane.warden@onyxneon.com, randy.dunlap@oracle.com,
       mithlesh@linsyssoft.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: Re: Staging: comedi: fix macros do - while loop and spaces before
 tabs issues in comedidev.h
Message-ID: <20100427222603.GC21816@kroah.com>
References: <>
 <1271139181-10146-1-git-send-email-silvagustavo@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271139181-10146-1-git-send-email-silvagustavo@users.sourceforge.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 01:13:01AM -0500, Gustavo Silva wrote:
> This is a patch to the comedidev.h file that fixes up two macros do - while
> loop and a space before tabs warnings found by the checkpatch.pl tool.
> 
> Signed-off-by: Gustavo Silva <silvagustavo@users.sourceforge.net>
> 
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -57,14 +57,15 @@
>  	static int __init x ## _init_module(void)			\
>  		{return comedi_driver_register(&(x)); }			\
>  	static void __exit x ## _cleanup_module(void)			\
> -		{comedi_driver_unregister(&(x)); } 			\
> +		{comedi_driver_unregister(&(x)); }			\
>  	module_init(x ## _init_module);					\
>  	module_exit(x ## _cleanup_module);
>  
> -#define COMEDI_MODULE_MACROS						\
> -	MODULE_AUTHOR("Comedi http://www.comedi.org");		\
> +#define COMEDI_MODULE_MACROS	do {		                        \
> +	MODULE_AUTHOR("Comedi http://www.comedi.org");		        \
>  	MODULE_DESCRIPTION("Comedi low-level driver");			\
> -	MODULE_LICENSE("GPL");
> +	MODULE_LICENSE("GPL");                                          \
> +} while (0)
>  
>  #define COMEDI_INITCLEANUP(x)						\
>  	COMEDI_MODULE_MACROS		\
> @@ -402,7 +403,7 @@ int insn_inval(struct comedi_device *dev, struct comedi_subdevice *s,
>  #define RANGE(a, b)		{(a)*1e6, (b)*1e6, 0}
>  #define RANGE_ext(a, b)		{(a)*1e6, (b)*1e6, RF_EXTERNAL}
>  #define RANGE_mA(a, b)		{(a)*1e6, (b)*1e6, UNIT_mA}
> -#define RANGE_unitless(a, b)	{(a)*1e6, (b)*1e6, 0}	/* XXX */
> +#define RANGE_unitless(a, b)	do {(a)*1e6, (b)*1e6, 0} while (0) /* XXX */

This is not correct, you need to at least build your changes after
making them :(

Care to resend this, without this one change?

thanks,

greg k-h
