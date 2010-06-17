Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877Ab0FQXHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:07:35 -0400
Received: from kroah.org ([198.145.64.141]:42912 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760848Ab0FQXHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:07:32 -0400
Date: Thu, 17 Jun 2010 16:02:09 -0700
From: Greg KH <greg@kroah.com>
To: Henri =?iso-8859-1?Q?H=E4kkinen?= <henuxd@gmail.com>
Cc: gregkh@suse.de, mithlesh@linsyssoft.com, wfp5p@virginia.edu,
       reodge@gmail.com, andrea.gelmini@gelma.net, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:comedi: Fixed coding convention issues.
Message-ID: <20100617230209.GA391@kroah.com>
References: <1276497255-2186-1-git-send-email-henuxd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1276497255-2186-1-git-send-email-henuxd@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 09:34:15AM +0300, Henri Häkkinen wrote:
> Cleaned up and fixed coding convention issues as reporteed by
> checkpatch.pl tool on the file `drivers.c'. Added logging macros
> to `comedidev.h'.  Replaced "BUG:" printk functions calls with
> BUG_ON macro.
> 
> Signed-off-by: Henri Häkkinen <henuxd@gmail.com>
> ---
>  drivers/staging/comedi/comedidev.h |   54 +++++++++++++++-
>  drivers/staging/comedi/drivers.c   |  118 +++++++++++++++--------------------
>  2 files changed, 102 insertions(+), 70 deletions(-)
> 
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index 4eb2b77..5c78564 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -43,11 +43,59 @@
>  
>  #include "comedi.h"
>  
> -#define DPRINTK(format, args...)	do {		\
> -	if (comedi_debug)				\
> -		printk(KERN_DEBUG "comedi: " format , ## args);	\
> +#define comedi_printk(level, fmt, args...) \
> +	printk(level "comedi: " pr_fmt(fmt), ##args)
> +
> +#define DPRINTK(format, args...) \
> +do { \
> +	if (comedi_debug) \
> +		comedi_printk(KERN_DEBUG, fmt, ##args); \
>  } while (0)
>  
> +#define comedi_emerg(fmt, ...) \
> +	comedi_printk(KERN_EMERG, fmt, ##__VA_ARGS__)

I'd much rather you use the real dev_printk() versions of this instead
(dev_warn, dev_err, etc.) instead of creating a new macro.

thanks,

greg k-h
