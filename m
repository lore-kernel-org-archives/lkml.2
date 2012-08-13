Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab2HMVJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 17:09:25 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:51102 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752374Ab2HMVJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 17:09:23 -0400
Message-ID: <50296CA8.1060303@xenotime.net>
Date: Mon, 13 Aug 2012 14:07:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Thai Bui <blquythai@gmail.com>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] boot: Put initcall_debug into its own Kconfig option
 DEBUG_INITCALL
References: <n> <1344891431-30869-1-git-send-email-blquythai@gmail.com>
In-Reply-To: <1344891431-30869-1-git-send-email-blquythai@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 01:57 PM, Thai Bui wrote:

> Putting DEBUG_INITCALL config option to compile out the command-line option
> "initcall_debug".

The patch description does not tell us Why.

presumably to save some memory?

How much memory is saved by disabling DEBUG_INITCALL?


> Signed-off-by: Thai Bui <blquythai@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  Documentation/kernel-parameters.txt |    3 ++-
>  include/linux/init.h                |    4 ++++
>  init/main.c                         |    2 ++
>  lib/Kconfig.debug                   |    9 +++++++++
>  4 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index d99fd9c..3dbaf15 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1026,7 +1026,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  
>  	initcall_debug	[KNL] Trace initcalls as they are executed.  Useful
>  			for working out where the kernel is dying during
> -			startup.
> +			startup. DEBUG_INITCALL needs to be enabled in order
> +			for this option to work.
>  
>  	initrd=		[BOOT] Specify the location of the initial ramdisk
>  
> diff --git a/include/linux/init.h b/include/linux/init.h
> index 6b95109..d2f31f1 100644
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -157,7 +157,11 @@ void prepare_namespace(void);
>  
>  extern void (*late_time_init)(void);
>  
> +#ifdef CONFIG_DEBUG_INITCALL
>  extern bool initcall_debug;
> +#else
> +static const bool initcall_debug = false;
> +#endif /* CONFIG_DEBUG_INITCALL */
>  
>  #endif
>    
> diff --git a/init/main.c b/init/main.c
> index ff49a6d..65837f7 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -648,8 +648,10 @@ static void __init do_ctors(void)
>  #endif
>  }
>  
> +#ifdef CONFIG_DEBUG_INITCALL
>  bool initcall_debug;
>  core_param(initcall_debug, initcall_debug, bool, 0644);
> +#endif /* CONFIG_DEBUG_INITCALL */
>  
>  static char msgbuf[64];
>  
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 8745ac7..424ac93 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -769,6 +769,15 @@ config DEBUG_WRITECOUNT
>  
>  	  If unsure, say N.
>  
> +config DEBUG_INITCALL
> +	bool "Debug initcalls as they are executed"
> +	depends on DEBUG_KERNEL
> +	help
> +	  Enable this for tracing initcalls during startup. Useful for working
> +	  out where the kernel is dying during startup.
> +
> +	  If unsure, say N
> +
>  config DEBUG_MEMORY_INIT
>  	bool "Debug memory initialisation" if EXPERT
>  	default !EXPERT



-- 
~Randy
