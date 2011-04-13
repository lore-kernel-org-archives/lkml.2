Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328Ab1DMWYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 18:24:25 -0400
Received: from kroah.org ([198.145.64.141]:39074 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933296Ab1DMWYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 18:24:22 -0400
Date: Wed, 13 Apr 2011 15:23:32 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: "Mark A. Allyn" <mark.a.allyn@intel.com>, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, jayant.mangalampalli@intel.com,
        venkat.r.gokulrangan@intel.com
Subject: Re: Re-send (What else needs to be done to the sep driver
 (staging/sep))
Message-ID: <20110413222332.GA32013@kroah.com>
References: <alpine.DEB.2.00.1104131427260.31147@allyn-test>
 <1302731811.11415.38.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302731811.11415.38.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 02:56:51PM -0700, Joe Perches wrote:
> On Wed, 2011-04-13 at 14:29 -0700, Mark A. Allyn wrote:
> > What else needs to be done to the sep driver in order for it to be moved 
> > to the kernel from staging?
> 
> Maybe a patch from you to move it?
> It seems pretty clean to me.
> Are you going to keep all the _dbg statements?
> 
> You might add a Kconfig CONFIG_SEP_DEBUG block with a
> Makefile entry of:
> ccflags-$(CONFIG_SEP_DEBUG) := -DDEBUG
> to specifically enable DEBUG without dynamic debug.
> 
> Here's a Kconfig typo fix and a suggestion to rename the
> uses of dev_dbg and dev_warn to sep_<level> to make the
> code a bit shorter and more compact.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> ---
> 
>  drivers/staging/sep/Kconfig      |    2 +-
>  drivers/staging/sep/sep_driver.c |  340 +++++++++++++++++---------------------
>  2 files changed, 152 insertions(+), 190 deletions(-)
> 
> diff --git a/drivers/staging/sep/Kconfig b/drivers/staging/sep/Kconfig
> index 92bf166..84c1b2b 100644
> --- a/drivers/staging/sep/Kconfig
> +++ b/drivers/staging/sep/Kconfig
> @@ -3,7 +3,7 @@ config DX_SEP
>  	depends on PCI
>  	help
>  	  Discretix SEP driver; used for the security processor subsystem
> -	  on bard the Intel Mobile Internet Device.
> +	  on board the Intel Mobile Internet Device.
>  
>  	  The driver's name is sep_driver.
>  
> diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
> index 890eede..d0537ca 100644
> --- a/drivers/staging/sep/sep_driver.c
> +++ b/drivers/staging/sep/sep_driver.c
> @@ -66,6 +66,11 @@
>  
>  #define SEP_RAR_IO_MEM_REGION_SIZE 0x40000
>  
> +#define sep_dbg(sep, fmt, ...)				\
> +	dev_dbg(&sep->pdev->dev, fmt, ##__VA_ARGS__)
> +#define sep_warn(sep, fmt, ...)				\
> +	dev_warn(&sep->pdev->dev, fmt, ##__VA_ARGS__)


Ick, no, never use your own macros, just use the "real" things like is
done in this driver.  If it's a pain to get to that pointer, then use a
temporary variable in the code and then use it.

Otherwise, no, I don't like this patch at all, sorry.

thanks,

greg k-h
