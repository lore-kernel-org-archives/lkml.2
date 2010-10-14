Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab0JNJEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:04:46 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:38582 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab0JNJEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:04:44 -0400
Date: Thu, 14 Oct 2010 11:04:42 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH -next] mmc: fix cb710 kconfig dependency warning
Message-ID: <20101014090442.GA14454@rere.qmqm.pl>
References: <20101013181519.6ff00e10.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101013181519.6ff00e10.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 06:15:19PM -0700, Randy Dunlap wrote:
> Fix kconfig dependency warning to satisfy dependencies:
> 
> warning: (MMC_CB710 && MMC && PCI) selects CB710_CORE which has unmet direct dependencies (MISC_DEVICES && PCI)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: <mirq-linux@rere.qmqm.pl>
> ---
>  drivers/mmc/host/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20101013.orig/drivers/mmc/host/Kconfig
> +++ linux-next-20101013/drivers/mmc/host/Kconfig
> @@ -394,7 +394,7 @@ config MMC_TMIO
>  
>  config MMC_CB710
>  	tristate "ENE CB710 MMC/SD Interface support"
> -	depends on PCI
> +	depends on PCI && MISC_DEVICES
>  	select CB710_CORE
>  	help
>  	  This option enables support for MMC/SD part of ENE CB710/720 Flash

Is this really necessary? MISC_DEVICES is only a submenu enabler, not
a real dependency.

Maybe just select MISC_DEVICES instead? User/developer should not have
to know that for this specific MMC controller he has to first enable some
other device burried somewhere in the config tree.

Best Regards,
Micha³ Miros³aw

