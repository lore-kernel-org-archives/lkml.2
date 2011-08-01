Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1HAAxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 20:53:13 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63243 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1HAAxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 20:53:07 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1107311812460.62769@linux>
References: <alpine.LNX.2.00.1107311812460.62769@linux>
Date: Sun, 31 Jul 2011 20:53:06 -0400
Message-ID: <CACqU3MWfOg+ZhUGAovWsds48Y37i7GRk7qSxWvt7-JmLMBcmgg@mail.gmail.com>
Subject: Re: [PATCH RFC] kconfig.h fix extraneous dependencies
From: Arnaud Lacombe <lacombar@gmail.com>
To: Peter Foley <pefoley2@verizon.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz, rdunlap@xenotime.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 31, 2011 at 8:36 PM, Peter Foley <pefoley2@verizon.net> wrote:
> The introduction of kconfig.h caused fixdep to create three extraneous
> dependencies.
> include/config/.h
> include/config/h.h
> include/config/foo.h
>
> Remove them by eliminating instances of CONFIG_
>
this seems ugly to me... I would rather try to fix fixdep, no ?

 - Arnaud

> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
>
> Suggestions for a better replacement for CONFIG_FOO would be appreciated.
>
> diff --git a/include/linux/kconfig.h b/include/linux/kconfig.h
> index 067eda0..66a0659 100644
> --- a/include/linux/kconfig.h
> +++ b/include/linux/kconfig.h
> @@ -1,15 +1,15 @@
> -#ifndef __LINUX_KCONFIG_H
> -#define __LINUX_KCONFIG_H
> +#ifndef __LINUX_KCONFIG
> +#define __LINUX_KCONFIG
>
>  #include <generated/autoconf.h>
>
>  /*
> - * Helper macros to use CONFIG_ options in C expressions. Note that
> + * Helper macros to use CONFIG options in C expressions. Note that
>  * these only work with boolean and tristate options.
>  */
>
>  /*
> - * IS_ENABLED(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y' or 'm',
> + * IS_ENABLED(CONFIG _FOO) evaluates to 1 if CONFIG _FOO is set to 'y' or 'm',
>  * 0 otherwise.
>  *
>  */
> @@ -17,16 +17,16 @@
>        (__enabled_ ## option || __enabled_ ## option ## _MODULE)
>
>  /*
> - * IS_BUILTIN(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y', 0
> + * IS_BUILTIN(CONFIG _FOO) evaluates to 1 if CONFIG _FOO is set to 'y', 0
>  * otherwise. For boolean options, this is equivalent to
> - * IS_ENABLED(CONFIG_FOO).
> + * IS_ENABLED(CONFIG _FOO).
>  */
>  #define IS_BUILTIN(option) __enabled_ ## option
>
>  /*
> - * IS_MODULE(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'm', 0
> + * IS_MODULE(CONFIG _FOO) evaluates to 1 if CONFIG _FOO is set to 'm', 0
>  * otherwise.
>  */
>  #define IS_MODULE(option) __enabled_ ## option ## _MODULE
>
> -#endif /* __LINUX_KCONFIG_H */
> +#endif /* __LINUX_KCONFIG */
>
