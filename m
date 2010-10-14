Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab0JNEf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:35:58 -0400
Received: from void.printf.net ([89.145.121.20]:39802 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab0JNEf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:35:57 -0400
Date: Thu, 14 Oct 2010 05:35:51 +0100
From: Chris Ball <cjb@laptop.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Alex Dubov <oakad@yahoo.com>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] tifm: fix kconfig dependencies
Message-ID: <20101014043551.GA4760@void.printf.net>
References: <20101013180729.766f2b3b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013180729.766f2b3b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 13, 2010 at 06:07:29PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kconfig dependency warning to satisfy dependencies:
> 
> warning: (MMC_TIFM_SD && MMC && EXPERIMENTAL && PCI || MEMSTICK_TIFM_MS && MEMSTICK && EXPERIMENTAL && PCI) selects TIFM_CORE which has unmet direct dependencies (MISC_DEVICES && EXPERIMENTAL && PCI)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/memstick/host/Kconfig |    1 +
>  drivers/mmc/host/Kconfig      |    1 +
>  2 files changed, 2 insertions(+)
> 
> --- linux-next-20101013.orig/drivers/memstick/host/Kconfig
> +++ linux-next-20101013/drivers/memstick/host/Kconfig
> @@ -7,6 +7,7 @@ comment "MemoryStick Host Controller Dri
>  config MEMSTICK_TIFM_MS
>  	tristate "TI Flash Media MemoryStick Interface support  (EXPERIMENTAL)"
>  	depends on EXPERIMENTAL && PCI
> +	select MISC_DEVICES
>  	select TIFM_CORE
>  	help
>  	  Say Y here if you want to be able to access MemoryStick cards with
> --- linux-next-20101013.orig/drivers/mmc/host/Kconfig
> +++ linux-next-20101013/drivers/mmc/host/Kconfig
> @@ -277,6 +277,7 @@ config MMC_MXC
>  config MMC_TIFM_SD
>  	tristate "TI Flash Media MMC/SD Interface support  (EXPERIMENTAL)"
>  	depends on EXPERIMENTAL && PCI
> +	select MISC_DEVICES
>  	select TIFM_CORE
>  	help
>  	  Say Y here if you want to be able to access MMC/SD cards with

Acked-by: Chris Ball <cjb@laptop.org>
for the mmc hunk.

Andrew, perhaps you should take this to keep the mmc/memstick trees
from modifying files outside of their namespace? (Or we could just
ask Randy to split up the patch; whatever is preferred.)

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
