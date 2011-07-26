Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1GZQhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:37:39 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:35968 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753830Ab1GZQhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:37:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=TqUylQEXjuFT1pQKWk+abUeM30aLYQ/+TH0MpuvFYHIYVOTGAt765vZZg1tdRgoBZNM/6KR+gf705tNoMlHRJiSxtKNxulxcm4NYtTpaRCoaqZSjoRucLnlWKim7Qlle;
Date: Tue, 26 Jul 2011 09:37:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Dave Reisner <d@falconindy.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Dave Reisner <dreisner@archlinux.org>
Subject: Re: [PATCH] printk: add Kconfig for default console loglevel
Message-Id: <20110726093730.aa164c70.rdunlap@xenotime.net>
In-Reply-To: <1311694431-17037-1-git-send-email-dreisner@archlinux.org>
References: <1311694431-17037-1-git-send-email-dreisner@archlinux.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jul 2011 11:33:51 -0400 Dave Reisner wrote:

> Keep the historical default of 7, but allow distributions and users to
> tune this value instead of requiring a kernel cmdline parameter.

Hi,

Please explain how this is different from what is already in lib/Kconfig.debug:

config DEFAULT_MESSAGE_LOGLEVEL
	int "Default message log level (1-7)"
	range 1 7
	default "4"
	help
	  Default log level for printk statements with no specified priority.


> Signed-off-by: Dave Reisner <dreisner@archlinux.org>
> ---
>  kernel/printk.c   |    4 +++-
>  lib/Kconfig.debug |   10 ++++++++++
>  2 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 37dff34..fabc216 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -58,7 +58,9 @@ void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
>  
>  /* We show everything that is MORE important than this.. */
>  #define MINIMUM_CONSOLE_LOGLEVEL 1 /* Minimum loglevel we let people use */
> -#define DEFAULT_CONSOLE_LOGLEVEL 7 /* anything MORE serious than KERN_DEBUG */
> +
> +/* default to 7 -- anything MORE serious than KERN_DEBUG */
> +#define DEFAULT_CONSOLE_LOGLEVEL CONFIG_DEFAULT_CONSOLE_LOGLEVEL
>  
>  DECLARE_WAIT_QUEUE_HEAD(log_wait);
>  
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index c0cb9c4..6caa66e 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -21,6 +21,16 @@ config DEFAULT_MESSAGE_LOGLEVEL
>  	  that are auditing their logs closely may want to set it to a lower
>  	  priority.
>  
> +config DEFAULT_CONSOLE_LOGLEVEL
> +	int "Default console log level (1-7)"
> +	range 1 7
> +	default "7"
> +	help
> +	  Default console log level setting for printk statements.
> +
> +	  This was hard-coded to KERN_INFO (7) since at least 2.6.12. You may
> +	  wish to turn this down to 4 for a quieter console.
> +
>  config ENABLE_WARN_DEPRECATED
>  	bool "Enable __deprecated logic"
>  	default y
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
