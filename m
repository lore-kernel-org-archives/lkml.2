Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759869Ab0D3Wp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 18:45:27 -0400
Received: from xenotime.net ([72.52.115.56]:58644 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756620Ab0D3Wp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 18:45:26 -0400
Date: Fri, 30 Apr 2010 15:45:22 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Samo Pogacnik <samo_pogacnik@t-2.net>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console logging detour via printk
Message-Id: <20100430154522.489df8bc.rdunlap@xenotime.net>
In-Reply-To: <1272664980.10241.77.camel@itpsd6lap>
References: <1272664980.10241.77.camel@itpsd6lap>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 May 2010 00:03:00 +0200 Samo Pogacnik wrote:

> Hi,

> diff --git a_linux-2.6.33.3/drivers/char/Kconfig b_linux-2.6.33.3/drivers/char/Kconfig
> index e023682..b5d0909 100644
> --- a_linux-2.6.33.3/drivers/char/Kconfig
> +++ b_linux-2.6.33.3/drivers/char/Kconfig
> @@ -66,6 +66,23 @@ config VT_CONSOLE
>  
>  	  If unsure, say Y.
>  
> +config VT_CONSOLE_DETOUR
> +	bool "Support for VT console detour via printk"
> +	depends on VT_CONSOLE
> +	default n
> +	---help---
> +	  If you do say Y here, the support for writing console messages via

	  If you say Y here,

> +	  printk is included into VT console code.
> +
> +	  The feature is usefull to catch all console log. In order to use this

	                 useful                       log messages.

> +	  feature, you should specify kernel command line option "detour" or write a
> +	  positive number into /proc/sys/kernel/console_detour. You can disable
> +	  the feature on-line by writing zero into the proc file. By writing a
> +	  negative value into the proc file, the feature is disabled permanently
> +	  (until next boot).
> +
> +	  If unsure, say N.
> +
>  config HW_CONSOLE
>  	bool
>  	depends on VT && !S390 && !UML

> diff --git a_linux-2.6.33.3/drivers/serial/Kconfig b_linux-2.6.33.3/drivers/serial/Kconfig
> index 9ff47db..20acfab 100644
> --- a_linux-2.6.33.3/drivers/serial/Kconfig
> +++ b_linux-2.6.33.3/drivers/serial/Kconfig
> @@ -1031,6 +1031,23 @@ config SERIAL_CORE
>  config SERIAL_CORE_CONSOLE
>  	bool
>  
> +config SERIAL_CORE_CONSOLE_DETOUR
> +	bool "Support for serial console detour via printk"
> +	depends on SERIAL_CORE_CONSOLE
> +	default n
> +	---help---
> +	  If you do say Y here, the support for writing console messages via

	  If you say Y here,

> +	  printk is included into serial console code. 
> +
> +	  The feature is usefull to catch all console log. In order to use this

	                 useful                       log messages.

> +	  feature, you should specify kernel command line option "detour" or write a
> +	  positive number into /proc/sys/kernel/console_detour. You can disable
> +	  the feature on-line by writing zero into the proc file. By writing a
> +	  negative value into the proc file, the feature is disabled permanently
> +	  (until next boot).
> +
> +	  If unsure, say N.
> +

The kernel command line option needs to be added to Documentation/kernel-parameters.txt
also, please.

>  config CONSOLE_POLL
>  	bool
>  
> diff --git a_linux-2.6.33.3/include/linux/console.h b_linux-2.6.33.3/include/linux/console.h
> index dcca533..bc88030 100644
> --- a_linux-2.6.33.3/include/linux/console.h
> +++ b_linux-2.6.33.3/include/linux/console.h
> @@ -108,6 +108,12 @@ struct console {
>  	struct	 console *next;
>  };
>  
> +extern int console_detour;
> +extern void console_printk_detour(const unsigned char *, int);

Please include parameter names in function prototype(s).

> +
> +struct ctl_table;
> +int detour_sysctl_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);

ditto

> +
>  extern int console_set_on_cmdline;
>  
>  extern int add_preferred_console(char *name, int idx, char *options);


Looks interesting/useful to me.  Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
