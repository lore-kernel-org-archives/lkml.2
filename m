Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab2GYHpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 03:45:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49782 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2GYHpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 03:45:07 -0400
Date: Wed, 25 Jul 2012 09:45:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-ia64@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] debug: Do not permit CONFIG_DEBUG_STACK_USAGE=y on IA64
 or PARISC
Message-ID: <20120725074501.GB27950@gmail.com>
References: <4a613b26cc402fb3ed8130cd07a37e76f4c133ef.1342634029.git.tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a613b26cc402fb3ed8130cd07a37e76f4c133ef.1342634029.git.tony.luck@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tony Luck <tony.luck@intel.com> wrote:

> The stack_not_used() function in <linux/sched.h> assumes that stacks
> grow downwards. This is not true on IA64 or PARISC, so this function
> would walk off in the wrong direction and into the weeds.
> 
> Found on IA64 because of a compilation failure with recursive dependencies
> on IA64_TASKSIZE and IA64_THREAD_INFO_SIZE.
> 
> Fixing the code is possible, but should be combined with other
> infrastructure additions to set up the "canary" at the end of the stack.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com> (failed allmodconfig build)
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  lib/Kconfig.debug | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index ff5bdee..4a18650 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -714,7 +714,7 @@ config STACKTRACE
>  
>  config DEBUG_STACK_USAGE
>  	bool "Stack utilization instrumentation"
> -	depends on DEBUG_KERNEL
> +	depends on DEBUG_KERNEL && !IA64 && !PARISC

The modern way of doing this is by adding an ARCH_SUPPORTS_ 
flag.

Thanks,

	Ingo
