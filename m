Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab1D0Sgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:36:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11002 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759837Ab1D0Sgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:36:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        b=LryUSoKpj6+QZuolgKsP1CnZYsDYwwCn8Ka7nPiaX+8QnNeLvPIwsxe0/zPPdq0xaM
         GzQTAPfniFZIdxWkEdQQ==
Date: Wed, 27 Apr 2011 11:36:16 -0700
From: Mandeep Singh Baines <msb@google.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hung_task_timeout: configurable default
Message-ID: <20110427183616.GL6027@google.com>
References: <4DB8600C.8080000@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB8600C.8080000@suse.com>
X-Operating-System: Linux/2.6.32-gg426-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Mahoney (jeffm@suse.com) wrote:
>  This patch allows the default value for sysctl_hung_task_timeout_secs
>  to be set at build time. The feature carries virtually no overhead,
>  so it makes sense to keep it enabled. On heavily loaded systems, though,
>  it can end up triggering stack traces when there is no bug other than
>  the system being underprovisioned. We use this patch to keep the hung task
>  facility available but disabled at boot-time.
> 

Clever.

>  The default of 120 seconds is preserved. As a note, commit e162b39a may
>  have accidentally reverted commit fb822db4, which raised the default from
>  120 seconds to 480 seconds.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Acked-by: Mandeep Singh Baines <msb@google.com>

> ---
>  kernel/hung_task.c |    3 ++-
>  lib/Kconfig.debug  |   14 ++++++++++++++
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> --- a/kernel/hung_task.c
> +++ b/kernel/hung_task.c
> @@ -33,7 +33,8 @@ unsigned long __read_mostly sysctl_hung_
>  /*
>   * Zero means infinite timeout - no checking done:
>   */
> -unsigned long __read_mostly sysctl_hung_task_timeout_secs = 120;
> +unsigned long __read_mostly sysctl_hung_task_timeout_secs =
> +					CONFIG_DEFAULT_HUNG_TASK_TIMEOUT;
>  
>  unsigned long __read_mostly sysctl_hung_task_warnings = 10;
>  
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -214,6 +214,20 @@ config DETECT_HUNG_TASK
>  	  enabled then all held locks will also be reported. This
>  	  feature has negligible overhead.
>  
> +config DEFAULT_HUNG_TASK_TIMEOUT
> +	int "Default timeout for hung task detection (in seconds)"
> +	depends on DETECT_HUNG_TASK
> +	default 120
> +	help
> +	  This option controls the default timeout (in seconds) used
> +	  to determine when a task has become non-responsive and should
> +	  be considered hung.
> +
> +	  It can be adjusted at runtime via the kernel.hung_task_timeout
> +	  sysctl or by writing a value to /proc/sys/kernel/hung_task_timeout.
> +
> +	  A timeout of 0 disables the check.  The default is 120 seconds.
> +
>  config BOOTPARAM_HUNG_TASK_PANIC
>  	bool "Panic (Reboot) On Hung Tasks"
>  	depends on DETECT_HUNG_TASK
> -- 
> Jeff Mahoney
> SUSE Labs
