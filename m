Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab0EJXIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:08:51 -0400
Received: from mga05.intel.com ([192.55.52.89]:48244 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932907Ab0EJXIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 19:08:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,203,1272870000"; 
   d="scan'208";a="797188629"
Date: Tue, 11 May 2010 01:09:25 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] mfd: use menuconfig for quicker config editing
Message-ID: <20100510230924.GF3288@sortiz.org>
References: <20100507150525.70d76e17.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507150525.70d76e17.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Fri, May 07, 2010 at 03:05:25PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Change MFD 'menu' to 'menuconfig' to facilitate easy (one-click)
> disabling of all MFD drivers.
Thanks, patch applied.

Cheers,
Samuel.


> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/mfd/Kconfig |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.34-rc6-git5.orig/drivers/mfd/Kconfig
> +++ linux-2.6.34-rc6-git5/drivers/mfd/Kconfig
> @@ -2,8 +2,14 @@
>  # Multifunction miscellaneous devices
>  #
>  
> -menu "Multifunction device drivers"
> +menuconfig MFD_SUPPORT
> +	bool "Multifunction device drivers"
>  	depends on HAS_IOMEM
> +	default y
> +	help
> +	  Configure MFD device drivers.
> +
> +if MFD_SUPPORT
>  
>  config MFD_CORE
>  	tristate
> @@ -399,7 +405,7 @@ config LPC_SCH
>  	  LPC bridge function of the Intel SCH provides support for
>  	  System Management Bus and General Purpose I/O.
>  
> -endmenu
> +endif # MFD_SUPPORT
>  
>  menu "Multimedia Capabilities Port drivers"
>  	depends on ARCH_SA1100

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
