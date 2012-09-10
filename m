Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab2IJN3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:29:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab2IJN3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:29:38 -0400
Date: Mon, 10 Sep 2012 09:32:51 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adjust hard-lockup related Kconfig options
Message-ID: <20120910133251.GK2151@redhat.com>
References: <504DF0FF020000780009A28E@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504DF0FF020000780009A28E@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 12:54:07PM +0100, Jan Beulich wrote:
> The main option should not appear in the resulting .config when the
> dependencies aren't met (i.e. use "depends on" rather than directly
> setting the default from the combined dependency values).
> 
> The sub-options should depend on the main option rather than a more
> generic higher level one.

Looks good to me.

Acked-by: Don Zickus <dzickus@redhat.com>

> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> ---
>  lib/Kconfig.debug |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> --- 3.6-rc5/lib/Kconfig.debug
> +++ 3.6-rc5-kconfig-cleanup-hardlockup/lib/Kconfig.debug
> @@ -196,12 +196,13 @@ config LOCKUP_DETECTOR
>  	  thresholds can be controlled through the sysctl watchdog_thresh.
>  
>  config HARDLOCKUP_DETECTOR
> -	def_bool LOCKUP_DETECTOR && PERF_EVENTS && HAVE_PERF_EVENTS_NMI && \
> -		 !HAVE_NMI_WATCHDOG
> +	def_bool y
> +	depends on LOCKUP_DETECTOR && !HAVE_NMI_WATCHDOG
> +	depends on PERF_EVENTS && HAVE_PERF_EVENTS_NMI
>  
>  config BOOTPARAM_HARDLOCKUP_PANIC
>  	bool "Panic (Reboot) On Hard Lockups"
> -	depends on LOCKUP_DETECTOR
> +	depends on HARDLOCKUP_DETECTOR
>  	help
>  	  Say Y here to enable the kernel to panic on "hard lockups",
>  	  which are bugs that cause the kernel to loop in kernel
> @@ -212,7 +213,7 @@ config BOOTPARAM_HARDLOCKUP_PANIC
>  
>  config BOOTPARAM_HARDLOCKUP_PANIC_VALUE
>  	int
> -	depends on LOCKUP_DETECTOR
> +	depends on HARDLOCKUP_DETECTOR
>  	range 0 1
>  	default 0 if !BOOTPARAM_HARDLOCKUP_PANIC
>  	default 1 if BOOTPARAM_HARDLOCKUP_PANIC
> 
> 
> 
