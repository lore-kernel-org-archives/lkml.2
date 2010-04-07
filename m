Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab0DGRka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:40:30 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:53105 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab0DGRk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:40:29 -0400
Date: Wed, 7 Apr 2010 10:38:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
       rolandd@cisco.com, peterz@infradead.org, pavel@ucw.cz, mingo@elte.hu
Subject: Re: [PATCH] [RFC] ummunotify: Userspace support for MMU
 notifications
Message-Id: <20100407103813.74b54a87.randy.dunlap@oracle.com>
In-Reply-To: <1270643429-20688-1-git-send-email-ebmunson@us.ibm.com>
References: <1270643429-20688-1-git-send-email-ebmunson@us.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BBCC374.0045:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Apr 2010 13:30:29 +0100 Eric B Munson wrote:

> Signed-off-by: Roland Dreier <rolandd <at> cisco.com>

Use unobfuscated @.

> Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
> 
> ---
> 
> Changes since v3:
>  - Fixed replaced [get|put] user with copy_[from|to]_user to fix x86
>    builds
> ---
>  Documentation/Makefile    |    3 +-
>  drivers/char/Kconfig      |   12 +
>  drivers/char/Makefile     |    1 +
>  drivers/char/ummunotify.c |  567 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 582 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/char/ummunotify.c
> 
> diff --git a/Documentation/Makefile b/Documentation/Makefile
> index 6fc7ea1..27ba76a 100644
> --- a/Documentation/Makefile
> +++ b/Documentation/Makefile
> @@ -1,3 +1,4 @@
>  obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
>  	filesystems/ filesystems/configfs/ ia64/ laptops/ networking/ \
> -	pcmcia/ spi/ timers/ video4linux/ vm/ watchdog/src/
> +	pcmcia/ spi/ timers/ video4linux/ vm/ ummunotify/ \
> +	watchdog/src/

What is this change to Documentation/Makefile for?
Is there some file that should be added in Documentation/ummunotify/ ?


> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index 3141dd3..cf26019 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -1111,6 +1111,18 @@ config DEVPORT
>  	depends on ISA || PCI
>  	default y
>  
> +config UMMUNOTIFY
> +       tristate "Userspace MMU notifications"
> +       select MMU_NOTIFIER
> +       help
> +         The ummunotify (userspace MMU notification) driver creates a
> +         character device that can be used by userspace libraries to
> +         get notifications when an application's memory mapping
> +         changed.  This is used, for example, by RDMA libraries to
> +         improve the reliability of memory registration caching, since
> +         the kernel's MMU notifications can be used to know precisely
> +         when to shoot down a cached registration.
> +
>  source "drivers/s390/char/Kconfig"
>  
>  endmenu
> diff --git a/drivers/char/Makefile b/drivers/char/Makefile
> index f957edf..521e5de 100644
> --- a/drivers/char/Makefile
> +++ b/drivers/char/Makefile
> @@ -97,6 +97,7 @@ obj-$(CONFIG_NSC_GPIO)		+= nsc_gpio.o
>  obj-$(CONFIG_CS5535_GPIO)	+= cs5535_gpio.o
>  obj-$(CONFIG_GPIO_TB0219)	+= tb0219.o
>  obj-$(CONFIG_TELCLOCK)		+= tlclk.o
> +obj-$(CONFIG_UMMUNOTIFY)	+= ummunotify.o
>  
>  obj-$(CONFIG_MWAVE)		+= mwave/
>  obj-$(CONFIG_AGP)		+= agp/


---
~Randy
